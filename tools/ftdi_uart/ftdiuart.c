// 直接使用ftdi第二个通道读取sipeed tang primer 20k 开发板的uart
// 不知道为什么，linux下作为串口读写，ftdi_sio总是有问题
// 使用 gcc ftdiuart.c -o ftdiuart -lftdi1
// 进行编译

#include <libftdi1/ftdi.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <termios.h>
#include <unistd.h>

static struct ftdi_context* ftdi;

/* ============================
   RX 队列（读线程 → 主线程）
   ============================ */
#define QSIZE 128
char* rx_queue[QSIZE];
int q_head = 0, q_tail = 0;

pthread_mutex_t q_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t q_cond = PTHREAD_COND_INITIALIZER;

void rx_queue_push(const char* s)
{
    pthread_mutex_lock(&q_lock);

    int next = (q_tail + 1) % QSIZE;
    if (next != q_head) {
        rx_queue[q_tail] = strdup(s);
        q_tail = next;
        pthread_cond_signal(&q_cond);
    }

    pthread_mutex_unlock(&q_lock);
}

char* rx_queue_pop()
{
    pthread_mutex_lock(&q_lock);

    while (q_head == q_tail)
        pthread_cond_wait(&q_cond, &q_lock);

    char* s = rx_queue[q_head];
    q_head = (q_head + 1) % QSIZE;

    pthread_mutex_unlock(&q_lock);
    return s;
}

/* ============================
   写函数（线程安全）
   ============================ */
pthread_mutex_t tx_lock = PTHREAD_MUTEX_INITIALIZER;

void uart_write(const unsigned char* data, int len)
{
    pthread_mutex_lock(&tx_lock);
    ftdi_write_data(ftdi, data, len);
    pthread_mutex_unlock(&tx_lock);
}

/* ============================
   读线程（阻塞读）
   ============================ */
void* uart_read_thread(void* arg)
{
    unsigned char buf[512];
    unsigned char line[4096];
    int pos = 0;

    while (1) {
        int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
        if (ret <= 0)
            continue;

        for (int i = 0; i < ret; i++) {
            unsigned char c = buf[i];

            if (c == '\n') {
                line[pos] = 0;
                rx_queue_push((char*)line);
                pos = 0;
                continue;
            }

            line[pos++] = c;

            if (pos >= sizeof(line) - 1) {
                line[pos] = 0;
                rx_queue_push((char*)line);
                pos = 0;
            }
        }
    }
    return NULL;
}

/* ============================
   终端原始模式
   ============================ */
void enable_raw_mode()
{
    struct termios t;
    tcgetattr(0, &t);
    t.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(0, TCSANOW, &t);
}

void disable_raw_mode()
{
    struct termios t;
    tcgetattr(0, &t);
    t.c_lflag |= (ICANON | ECHO);
    tcsetattr(0, TCSANOW, &t);
}

void handle_cli_command(const char* cmd)
{
    // TODO: 你以后在这里扩展命令
    // 可以加入比如输入hex，或者从文件输入等
    printf("\n[CMD] %s\n", cmd);
}

/* ============================
   主线程：CLI（非阻塞输入）
   ============================ */
int main()
{
    ftdi = ftdi_new();
    ftdi_set_interface(ftdi, INTERFACE_B);
    ftdi_usb_open(ftdi, 0x0403, 0x6010);
    ftdi_set_baudrate(ftdi, 115200);

    pthread_t rth;
    pthread_create(&rth, NULL, uart_read_thread, NULL);

    enable_raw_mode();

    unsigned char line[1024];
    int len = 0;

    printf("uart> ");
    fflush(stdout);

    while (1) {

        /* ========== 处理 RX 队列 ========== */
        while (q_head != q_tail) {
            char* rx = rx_queue_pop();

            printf("\r\033[K"); // 清除输入行
            printf("[RX] %s\n", rx);
            free(rx);

            printf("uart> %.*s", len, line); // 恢复输入行
            fflush(stdout);
        }

        /* ========== 非阻塞键盘输入 ========== */
        fd_set rfds;
        FD_ZERO(&rfds);
        FD_SET(0, &rfds);

        struct timeval tv = { 0, 20000 }; // 20ms

        int n = select(1, &rfds, NULL, NULL, &tv);

        if (n > 0 && FD_ISSET(0, &rfds)) {
            int c = getchar();

            if (c == '\n' || c == '\r') {

                line[len] = 0;

                /* ========== 新增：命令模式 ========== */
                if (line[0] == '.') {
                    handle_cli_command((char*)line);

                    printf("uart> ");
                    fflush(stdout);
                    len = 0;
                    continue;
                }

                /* ========== 普通 TX ========== */
                uart_write(line, len);
                uart_write((unsigned char*)"\n", 1);

                printf("\n[TX] %s\n", line);
                len = 0;

                printf("uart> ");
                fflush(stdout);
                continue;
            }

            if (c == 127 || c == 8) {
                if (len > 0) {
                    len--;
                    printf("\b \b");
                    fflush(stdout);
                }
                continue;
            }

            if (len < sizeof(line) - 1) {
                line[len++] = c;
                putchar(c);
                fflush(stdout);
            }
        }
    }

    disable_raw_mode();
    return 0;
}
