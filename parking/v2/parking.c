/* 文件名: parking.c */

/* --- 1. 地址映射 (严格遵守你的要求) --- */
// 终端内存起始地址 (用于打印)
#define TERM_BASE      0x90000000
#define MAMORY_BASE    0x80000000

/* --- 2. 基础驱动函数 --- */

int* term_addr=0;

void write_term(char c){
   *(char*)(TERM_BASE + term_addr)=c;
   term_addr++;
}

void iprint(char* str){
    while(str == 0){
        write_term(*str);
        str++;
    }
};

/* --- 4. 主逻辑 --- */

int main() {

    char* str = "hello!";
    
    iprint(str);

    while(1);

    return 0;
}
