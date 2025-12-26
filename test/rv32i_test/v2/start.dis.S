
start.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	00100513          	li	a0,1
   8:	01400593          	li	a1,20
   c:	008000ef          	jal	14 <main>
  10:	0000006f          	j	10 <_start+0x10>

00000014 <main>:
  14:	00150513          	addi	a0,a0,1
  18:	00a52023          	sw	a0,0(a0)
  1c:	00b50463          	beq	a0,a1,24 <end>
  20:	ff5ff06f          	j	14 <main>

00000024 <end>:
  24:	0000006f          	j	24 <end>

Disassembly of section .interp:

00000028 <.interp>:
  28:	62696c2f          	.insn	4, 0x62696c2f
  2c:	2d646c2f          	.insn	4, 0x2d646c2f
  30:	696c                	.insn	2, 0x696c
  32:	756e                	.insn	2, 0x756e
  34:	2d78                	.insn	2, 0x2d78
  36:	6972                	.insn	2, 0x6972
  38:	33766373          	.insn	4, 0x33766373
  3c:	2d32                	.insn	2, 0x2d32
  3e:	6c69                	.insn	2, 0x6c69
  40:	3370                	.insn	2, 0x3370
  42:	2e32                	.insn	2, 0x2e32
  44:	312e6f73          	.insn	4, 0x312e6f73
	...

Disassembly of section .dynsym:

0000004c <.dynsym>:
	...
  68:	00010003          	lb	zero,0(sp) # 10000 <_GLOBAL_OFFSET_TABLE_+0xfef8>

Disassembly of section .dynstr:

0000006c <.dynstr>:
	...

Disassembly of section .gnu.hash:

00000070 <.gnu.hash>:
  70:	0001                	.insn	2, 0x0001
  72:	0000                	.insn	2, 0x0000
  74:	0001                	.insn	2, 0x0001
  76:	0000                	.insn	2, 0x0000
  78:	0001                	.insn	2, 0x0001
	...

Disassembly of section .dynamic:

00000088 <.dynamic>:
  88:	fef5                	.insn	2, 0xfef5
  8a:	6fff 0070 0000 0005 	.insn	22, 0x004c000000060000006c00000005000000706fff
  92:	0000 006c 0000 0006 
  9a:	0000 004c 0000 
  a0:	000a                	.insn	2, 0x000a
  a2:	0000                	.insn	2, 0x0000
  a4:	0001                	.insn	2, 0x0001
  a6:	0000                	.insn	2, 0x0000
  a8:	0000000b          	.insn	4, 0x000b
  ac:	0010                	.insn	2, 0x0010
  ae:	0000                	.insn	2, 0x0000
  b0:	0015                	.insn	2, 0x0015
  b2:	0000                	.insn	2, 0x0000
  b4:	0000                	.insn	2, 0x0000
  b6:	0000                	.insn	2, 0x0000
  b8:	00000007          	.insn	4, 0x0007
  bc:	0000                	.insn	2, 0x0000
  be:	0000                	.insn	2, 0x0000
  c0:	0008                	.insn	2, 0x0008
  c2:	0000                	.insn	2, 0x0000
  c4:	0000                	.insn	2, 0x0000
  c6:	0000                	.insn	2, 0x0000
  c8:	0009                	.insn	2, 0x0009
  ca:	0000                	.insn	2, 0x0000
  cc:	000c                	.insn	2, 0x000c
  ce:	0000                	.insn	2, 0x0000
  d0:	6ffffffb          	.insn	4, 0x6ffffffb
  d4:	0000                	.insn	2, 0x0000
  d6:	0800                	.insn	2, 0x0800
	...

Disassembly of section .got:

00000108 <.got>:
 108:	0088                	.insn	2, 0x0088
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2741                	.insn	2, 0x2741
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <main>
   c:	001d                	.insn	2, 0x001d
   e:	0000                	.insn	2, 0x0000
  10:	7205                	.insn	2, 0x7205
  12:	3376                	.insn	2, 0x3376
  14:	6932                	.insn	2, 0x6932
  16:	7032                	.insn	2, 0x7032
  18:	5f31                	.insn	2, 0x5f31
  1a:	326d                	.insn	2, 0x326d
  1c:	3070                	.insn	2, 0x3070
  1e:	7a5f 6d6d 6c75      	.insn	6, 0x6c756d6d7a5f
  24:	7031                	.insn	2, 0x7031
  26:	0030                	.insn	2, 0x0030
