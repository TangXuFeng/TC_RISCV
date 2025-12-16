#include <arpa/inet.h>
#include <ctype.h>
#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef int (*device_read_func)(char* buf, int max_len);
typedef int (*device_write_func)(const char* buf, int len);

typedef struct {
    const char* name;
    device_read_func read;
    device_write_func write;
} device_t;

#define BUF_SIZE 1024

// 判断是否可显示ASCII
int is_normal_ascii(unsigned char ch)
{
    return (ch >= 32 && ch <= 126); // 空格到~
}

// 终端读: 读取一行，原样放buf
int terminal_read(char* buf, int max_len)
{
    if (fgets(buf, max_len, stdin) == NULL)
        return 0;
    return strlen(buf);
}

// 终端写: 对每个字节判断，并打印
int terminal_write(const char* buf, int len)
{
    for (int i = 0; i < len; ++i) {
        unsigned char ch = (unsigned char)buf[i];
        if (is_normal_ascii(ch)) {
            putchar(ch);
        } else {
            printf(" 0x%02X ", ch);
        }:
    }
    fflush(stdout);
    return len;
}

device_t known_devices[] = {
    { "terminal", terminal_read, terminal_write }
    // 可以添加其他设备
};

#define NUM_KNOWN_DEVICES (sizeof(known_devices) / sizeof(device_t))

void usage(const char* prog)
{
    printf("Usage: %s --device DEV --port PORT [--host HOST]\n", prog);
    printf("Example: %s -d terminal -p 12345 -h 127.0.0.1\n", prog);
    exit(1);
}

int main(int argc, char* argv[])
{
    char* device_name = NULL;
    char* host = "127.0.0.1";
    int port = 0;
    int opt;
    while ((opt = getopt(argc, argv, "d:p:h:")) != -1) {
        switch (opt) {
        case 'd':
            device_name = optarg;
            break;
        case 'p':
            port = atoi(optarg);
            break;
        case 'h':
            host = optarg;
            break;
        default:
            usage(argv[0]);
        }
    }
    if (!device_name || port == 0)
        usage(argv[0]);

    // 选择设备
    device_t* dev = NULL;
    for (size_t i = 0; i < NUM_KNOWN_DEVICES; ++i) {
        if (strcmp(device_name, known_devices[i].name) == 0) {
            dev = &known_devices[i];
            break;
        }
    }
    if (!dev) {
        fprintf(stderr, "Unknown device: %s\n", device_name);
        usage(argv[0]);
    }

    // 连接TCP
    int sockfd;
    struct sockaddr_in servaddr;
    char buf[BUF_SIZE];
    int n;

    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket");
        exit(1);
    }
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(port);
    if (inet_pton(AF_INET, host, &servaddr.sin_addr) <= 0) {
        perror("inet_pton");
        exit(1);
    }
    if (connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0) {
        perror("connect");
        exit(1);
    }

    // 循环从 socket读写到/来自设备 （此处只单向演示, 可根据需求为全双工）
    while ((n = read(sockfd, buf, BUF_SIZE)) > 0) {
        dev->write(buf, n);
    }
    close(sockfd);
    return 0;
}
