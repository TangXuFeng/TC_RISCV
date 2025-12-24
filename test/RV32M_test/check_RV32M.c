//一个测试乘法除法器的东西,我真的测不动
// gcc check_RV32M.c -o check_RV32M.elf
// check_RV32M.elf check_RV32M.txt
// 然后复制到游戏里面去
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

uint32_t mulh(int32_t a, int32_t b) {
    int64_t r = (int64_t)a * (int64_t)b;
    return (uint32_t)(r >> 32);
}

uint32_t mulhsu(int32_t a, uint32_t b) {
    int64_t r = (int64_t)a * (uint64_t)b;
    return (uint32_t)(r >> 32);
}

uint32_t mulhu(uint32_t a, uint32_t b) {
    uint64_t r = (uint64_t)a * (uint64_t)b;
    return (uint32_t)(r >> 32);
}

int main() {
    srand(time(NULL));
    //测试除0或者乘0结果
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 0, 1, 0, 0);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 1, 1, 0, 0);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 2, 1, 0, 0);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 3, 1, 0, 0);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 4, 1, 0, 0xFFFFFFFF);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 5, 1, 0, 0xFFFFFFFF);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 6, 1, 0, 1);
    printf("0x%02X 0x%08X 0x%08X 0x%08X\n", 7, 1, 0, 1);



    for (int i = 0; i < 2048-8; i++) {
        uint32_t a = rand();
        uint32_t b = rand();
        uint32_t opcode;
        uint32_t result = 0;

        uint32_t funct3 = rand() % 8;   // RV32M funct3
        opcode = 0x58 | funct3;     // bit5 = 1

        switch (funct3) {
            case 0: // MUL
                result = (uint32_t)((uint64_t)a * (uint64_t)b);
                break;

            case 1: // MULH
                result = mulh((int32_t)a, (int32_t)b);
                break;

            case 2: // MULHSU
                result = mulhsu((int32_t)a, b);
                break;

            case 3: // MULHU
                result = mulhu(a, b);
                break;

            case 4: // DIV
                result = (b == 0) ? 0xFFFFFFFF : (int32_t)a / (int32_t)b;
                break;

            case 5: // DIVU
                result = (b == 0) ? 0xFFFFFFFF : a / b;
                break;

            case 6: // REM
                result = (b == 0) ? a : (int32_t)a % (int32_t)b;
                break;

            case 7: // REMU
                result = (b == 0) ? a : a % b;
                break;
        }

        printf("0x%02X 0x%08X 0x%08X 0x%08X\n", opcode, a, b, result);
    }
    return 0;
}
