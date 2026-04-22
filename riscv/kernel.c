__attribute__((section(".text.startup")))
__attribute__((naked))
void _start(){
	int *p=(int*)0xF0000000;
	*p=0x00eeeeee;
    asm volatile(
        "jal main\n"
    );
    while (1);
}

#include <stdint.h>

#define LED_MATRIX_0_BASE   0xF0000000
#define LED_MATRIX_0_WIDTH  35
#define LED_MATRIX_0_HEIGHT 25

// 直接写像素到 LED 显存
static inline void set_pixel(int x, int y, int zrgb) {
    volatile int* p = (int*) LED_MATRIX_0_BASE;
    p[y*LED_MATRIX_0_WIDTH + x]=zrgb;
}

void main() {
    
    for (int y = 0; y < LED_MATRIX_0_HEIGHT; y++) {
        for (int x = 0; x < LED_MATRIX_0_WIDTH; x++) {

            int zrgb = 0x80000*x + 0x900*y + x*16 + y*7;

            set_pixel(x, y, zrgb);
        }
    }

    while (1);
}

