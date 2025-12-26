#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "rb");
    if (!fp) {
        perror("fopen");
        return 1;
    }

    uint8_t buf[4];
    size_t n;

    while ((n = fread(buf, 1, 4, fp)) > 0) {
        uint32_t value = 0;

        // 按小端序组合成 32 位（与 RISC‑V 内存一致）
        for (size_t i = 0; i < n; i++) {
            value |= ((uint32_t)buf[i]) << (8 * i);
        }

        printf("0x%08x\n", value);
    }

    fclose(fp);
    return 0;
}

