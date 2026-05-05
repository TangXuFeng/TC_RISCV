    .section .text.startup
    .globl _start
    .type _start, @function

_start:
    li  sp, 0x10000
    jal ra, main

1:
    j 1b
