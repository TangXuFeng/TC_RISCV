	.file	"parking.c"
	.option pic
	.attribute arch, "rv32i2p1_m2p0_zmmul1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	term_addr
	.bss
	.align	2
	.type	term_addr, @object
	.size	term_addr, 4
term_addr:
	.zero	4
	.text
	.align	2
	.globl	write_term
	.type	write_term, @function
write_term:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sw	ra,28(sp)
	sw	s0,24(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	mv	a5,a0
	sb	a5,-17(s0)
	lla	a5,term_addr
	lw	a4,0(a5)
	li	a5,1073741824
	add	a5,a4,a5
	lbu	a4,-17(s0)
	sb	a4,0(a5)
	lla	a5,term_addr
	lw	a5,0(a5)
	addi	a4,a5,4
	lla	a5,term_addr
	sw	a4,0(a5)
	nop
	lw	ra,28(sp)
	.cfi_restore 1
	lw	s0,24(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	write_term, .-write_term
	.align	2
	.globl	iprint
	.type	iprint, @function
iprint:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sw	ra,28(sp)
	sw	s0,24(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	sw	a0,-20(s0)
	j	.L3
.L4:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	mv	a0,a5
	call	write_term
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	lw	a5,-20(s0)
	beq	a5,zero,.L4
	nop
	nop
	lw	ra,28(sp)
	.cfi_restore 1
	lw	s0,24(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE1:
	.size	iprint, .-iprint
	.section	.rodata
	.align	2
.LC0:
	.string	"hello!"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sw	ra,28(sp)
	sw	s0,24(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	lla	a5,.LC0
	sw	a5,-20(s0)
	lw	a0,-20(s0)
	call	iprint
.L6:
	j	.L6
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Gentoo 15.2.1_p20251122 p4) 15.2.1 20251122"
	.section	.note.GNU-stack,"",@progbits
