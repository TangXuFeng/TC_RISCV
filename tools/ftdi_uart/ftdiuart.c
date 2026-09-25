// 直接使用ftdi第二个通道读取sipeed tang primer 20k 开发板的uart
// 使用 gcc ftdiuart.c -o ftdiuart -lftdi1 -lpthread
//
// 架构：输入/输出分离 + 全量重绘
//   - 所有输出（RX/TX/CMD/提示）先入 out_queue
//   - 所有输入写进 input_buf
//   - 主循环调用 render()，把两者统一画到终端
//   - 输入行永远固定在底部，避免输出打断输入

#include <libftdi1/ftdi.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

/* 返回 "HH:MM:SS" 形式的静态缓冲区（每次调用覆盖） */
static const char* now_hms(void)
{
    static _Thread_local char buf[16];
    time_t t = time(NULL);
    struct tm tm;
    localtime_r(&t, &tm);
    strftime(buf, sizeof(buf), "%H:%M:%S", &tm);
    return buf;
}

static struct ftdi_context* ftdi;

/* ============================
 *  RX 队列（读线程 → 主线程）
 *  ============================ */
#define RX_QSIZE 128
static char* rx_queue[RX_QSIZE];
static int rx_head = 0, rx_tail = 0;
static pthread_mutex_t rx_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t rx_cond = PTHREAD_COND_INITIALIZER;

static void rx_queue_push(const char* s)
{
    pthread_mutex_lock(&rx_lock);
    int next = (rx_tail + 1) % RX_QSIZE;
    if (next != rx_head) {
        rx_queue[rx_tail] = strdup(s);
        rx_tail = next;
        pthread_cond_signal(&rx_cond);
    }
    pthread_mutex_unlock(&rx_lock);
}

static char* rx_queue_pop_blocking(void)
{
    pthread_mutex_lock(&rx_lock);
    while (rx_head == rx_tail)
        pthread_cond_wait(&rx_cond, &rx_lock);
    char* s = rx_queue[rx_head];
    rx_head = (rx_head + 1) % RX_QSIZE;
    pthread_mutex_unlock(&rx_lock);
    return s;
}

/* ============================
 *  输出队列（任何线程 → 渲染线程）
 *  只存"一整行"（不含 \n）
 *  ============================ */
#define OUT_QSIZE 256
static char* out_queue[OUT_QSIZE];
static int out_head = 0, out_tail = 0;
static pthread_mutex_t out_lock = PTHREAD_MUTEX_INITIALIZER;

static void out_push(const char* s)
{
    pthread_mutex_lock(&out_lock);
    int next = (out_tail + 1) % OUT_QSIZE;
    if (next != out_head) {
        out_queue[out_tail] = strdup(s);
        out_tail = next;
    }
    /* 队列满则丢弃，避免阻塞渲染 */
    pthread_mutex_unlock(&out_lock);
}

static char* out_pop_nonblock(void)
{
    pthread_mutex_lock(&out_lock);
    if (out_head == out_tail) {
        pthread_mutex_unlock(&out_lock);
        return NULL;
    }
    char* s = out_queue[out_head];
    out_head = (out_head + 1) % OUT_QSIZE;
    pthread_mutex_unlock(&out_lock);
    return s;
}

/* ============================
 *  写函数（线程安全）
 *  ============================ */
static pthread_mutex_t tx_lock = PTHREAD_MUTEX_INITIALIZER;

static void uart_write(const unsigned char* data, int len)
{
    pthread_mutex_lock(&tx_lock);
    ftdi_write_data(ftdi, data, len);
    pthread_mutex_unlock(&tx_lock);
}

/* ============================
 *  读线程：只负责把收到的"整行"塞进 RX 队列
 *  ============================ */
static void* uart_read_thread(void* arg)
{
    (void)arg;
    unsigned char buf[512];
    unsigned char line[4096];
    int pos = 0;

    while (1) {
        int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
        if (ret <= 0) {
            usleep(1000); // 避免空转烧 CPU
            continue;
        }

        for (int i = 0; i < ret; i++) {
            unsigned char c = buf[i];

            if (c == '\n') {
                line[pos] = 0;
                rx_queue_push((char*)line);
                pos = 0;
                continue;
            }
            if (c == '\r')
                continue; // 忽略 CR

            line[pos++] = c;
            if (pos >= (int)sizeof(line) - 1) {
                line[pos] = 0;
                rx_queue_push((char*)line);
                pos = 0;
            }
        }
    }
    return NULL;
}

/* ============================
 *  终端原始模式
 *  ============================ */
static struct termios g_saved_termios;
static int g_raw_enabled = 0;

static void enable_raw_mode(void)
{
    struct termios t;
    tcgetattr(0, &t);
    g_saved_termios = t;
    t.c_lflag &= ~(ICANON | ECHO);
    t.c_cc[VMIN] = 0;
    t.c_cc[VTIME] = 0;
    tcsetattr(0, TCSANOW, &t);
    g_raw_enabled = 1;
}

static void disable_raw_mode(void)
{
    if (g_raw_enabled)
        tcsetattr(0, TCSANOW, &g_saved_termios);
}

/* ============================
 *  输入缓冲（只被主线程访问）
 *  ============================ */
#define INPUT_MAX 1024
static char input_buf[INPUT_MAX];
static int input_len = 0;

/* 把 input_len 回退到上一个 UTF-8 字符边界 */
static void backspace_utf8(void)
{
    if (input_len <= 0)
        return;
    int i = input_len - 1;
    while (i > 0 && (input_buf[i] & 0xC0) == 0x80)
        i--;
    input_len = i;
}

/* ============================
 *  渲染：所有绘制都走这里
 *  顺序：清输入行 → 打所有输出 → 重画输入行
 *  ============================ */
static void render(void)
{
    /* 1. 光标回行首，清掉整行（此时光标在输入行） */
    fputs("\r\033[K", stdout);

    /* 2. 输出所有待打印的消息 */
    char* msg;
    while ((msg = out_pop_nonblock()) != NULL) {
        fputs(msg, stdout);
        fputc('\n', stdout);
        free(msg);
    }

    /* 3. 重画输入行 */
    fputs("uart> ", stdout);
    if (input_len > 0)
        fwrite(input_buf, 1, input_len, stdout);

    fflush(stdout);
}

/* ============================
 *  命令行命令（以 '.' 开头）
 *  ============================ */
static void handle_cli_command(const char* cmd)
{
    char buf[1200];
    snprintf(buf, sizeof(buf), "[%s] [CMD] %s", now_hms(), cmd);
    out_push(buf);
    // TODO: 以后在这里扩展命令
}

/* ============================
 *  提交一行输入
 *  ============================ */
static void handle_submit(void)
{
    input_buf[input_len] = 0;

    if (input_len == 0) {
        return;
    }

    if (input_buf[0] == '.') {
        handle_cli_command(input_buf);
    } else {
        /* 普通 TX：发出去，并本地回显 */
        uart_write((unsigned char*)input_buf, input_len);
        uart_write((unsigned char*)"\n", 1);

        char buf[INPUT_MAX + 8];
        snprintf(buf, sizeof(buf), "[%s] [TX] %s", now_hms(), input_buf);
        out_push(buf);
    }

    input_len = 0;
}

/* ============================
 *  主线程：事件循环
 *  ============================ */
int main(void)
{
    ftdi = ftdi_new();
    if (!ftdi) {
        fprintf(stderr, "ftdi_new failed\n");
        return 1;
    }
    ftdi_set_interface(ftdi, INTERFACE_B);

    int r = ftdi_usb_open(ftdi, 0x0403, 0x6010);
    if (r < 0) {
        fprintf(stderr, "ftdi_usb_open failed: %s\n", ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        return 1;
    }

    ftdi_set_baudrate(ftdi, 115200);
    ftdi_set_line_property(ftdi, 8, STOP_BIT_1, NONE);
    ftdi_setflowctrl(ftdi, SIO_DISABLE_FLOW_CTRL);
    ftdi_set_latency_timer(ftdi, 2);

    pthread_t rth;
    pthread_create(&rth, NULL, uart_read_thread, NULL);

    enable_raw_mode();
    atexit(disable_raw_mode);

    /* 初始提示 */
    out_push("Type '.' prefixed line for commands. Ctrl-C to quit.");

    while (1) {
        /* ---------- 把 RX 队列内容搬到输出队列 ---------- */
        /* 用非阻塞方式：加一个 try_pop 也行，这里直接 detach 一个线程读也行，
         *          简单起见我们用 cond + 非阻塞检查： */
        pthread_mutex_lock(&rx_lock);
        int has_rx = (rx_head != rx_tail);
        pthread_mutex_unlock(&rx_lock);

        while (has_rx) {
            char* line = rx_queue_pop_blocking();
            char buf[4200];
            snprintf(buf, sizeof(buf), "[%s] [RX] %s", now_hms(), line);
            out_push(buf);
            free(line);

            pthread_mutex_lock(&rx_lock);
            has_rx = (rx_head != rx_tail);
            pthread_mutex_unlock(&rx_lock);
        }

        /* ---------- 非阻塞读键盘，一次读多字节 ---------- */
        fd_set rfds;
        FD_ZERO(&rfds);
        FD_SET(0, &rfds);

        struct timeval tv = { 0, 20000 }; // 20ms
        int n = select(1, &rfds, NULL, NULL, &tv);

        if (n > 0 && FD_ISSET(0, &rfds)) {
            unsigned char kbuf[64];
            int rn = read(0, kbuf, sizeof(kbuf));

            if (rn > 0) {
                for (int i = 0; i < rn; i++) {
                    unsigned char c = kbuf[i];

                    if (c == 0x03) { // Ctrl-C
                        disable_raw_mode();
                        fputs("\n", stdout);
                        exit(0);
                    }

                    if (c == '\n' || c == '\r') {
                        handle_submit();
                        continue;
                    }

                    if (c == 127 || c == 8) { // Backspace
                        backspace_utf8();
                        continue;
                    }

                    /* 过滤掉其他控制字符 */
                    if (c < 0x20 && c != '\t')
                        continue;

                    if (input_len < INPUT_MAX - 1) {
                        input_buf[input_len++] = c;
                    }
                }
            }
        }

        /* ---------- 全量重绘 ---------- */
        render();
    }

    disable_raw_mode();
    return 0;
}
