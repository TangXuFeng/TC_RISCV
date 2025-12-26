.global _start
_start:
    la sp,0x10000 #初始化堆栈,避免进入main崩溃
    addi x10,x0,1
    addi x11,x0,20
    call main
1:  j 1b

main:

addi x10,x10,0x1
sw x10, (x10)
beq x10,x11,end
j main

end:
j end
