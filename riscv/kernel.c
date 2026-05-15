char ch[100] = "Hello, world!";

void iputc(char c) {
    //这里我们直接把字符输出到串口0
    //当然,这里现在还什么都干不了
    //我们先把它放在这里,等串口驱动做好了再来实现它
}

void main() {
    
    //当然,这里现在还什么都干不了
    for(int i=0;i<sizeof(ch);i++) {
        iputc(ch[i] );
    }

    while (1);
}

