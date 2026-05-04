    .section .text.startup
    .globl _start
    .type _start, @function

_start:

    jal  ra, main

1:
    j 1b
