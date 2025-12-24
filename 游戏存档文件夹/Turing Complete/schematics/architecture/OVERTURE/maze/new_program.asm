st:
imm 2 //右转
mov r0,out

check://如果是墙,左转
mov in,r2
imm 1
mov r0,r1
sub
imm left
jz
//否则直行
imm 1
mov r0,out
imm st
jmp

left:
imm 0
mov r0,out
imm check
jmp