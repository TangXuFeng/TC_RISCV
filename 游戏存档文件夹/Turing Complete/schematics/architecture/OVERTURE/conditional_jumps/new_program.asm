
imm 5 ; Moves 5 to r0
jmp   ; Jumps to byte 5 of the program

; <- Click Assembly to see the other jump instructions
imm 0
mov r0,r4
st:

mov r4,r2
imm 1
mov r0,r1
add
mov r3,r4

mov in,r2
imm 37
mov r0,r1
sub
imm my_label
jz

imm st
jmp


my_label:    ; This is a label
imm my_label ; You can load it's offset like this
mov r4,out
