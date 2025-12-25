
parking.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	80100137          	lui	sp,0x80100
   4:	0c0000ef          	jal	c4 <main>

00000008 <loop>:
   8:	0000006f          	j	8 <loop>

0000000c <write_term>:
   c:	fe010113          	addi	sp,sp,-32 # 800fffe0 <term_addr+0x800ffd64>
  10:	00112e23          	sw	ra,28(sp)
  14:	00812c23          	sw	s0,24(sp)
  18:	02010413          	addi	s0,sp,32
  1c:	00050793          	mv	a5,a0
  20:	fef407a3          	sb	a5,-17(s0)
  24:	00000797          	auipc	a5,0x0
  28:	25878793          	addi	a5,a5,600 # 27c <term_addr>
  2c:	0007a703          	lw	a4,0(a5)
  30:	400007b7          	lui	a5,0x40000
  34:	00f707b3          	add	a5,a4,a5
  38:	fef44703          	lbu	a4,-17(s0)
  3c:	00e78023          	sb	a4,0(a5) # 40000000 <term_addr+0x3ffffd84>
  40:	00000797          	auipc	a5,0x0
  44:	23c78793          	addi	a5,a5,572 # 27c <term_addr>
  48:	0007a783          	lw	a5,0(a5)
  4c:	00478713          	addi	a4,a5,4
  50:	00000797          	auipc	a5,0x0
  54:	22c78793          	addi	a5,a5,556 # 27c <term_addr>
  58:	00e7a023          	sw	a4,0(a5)
  5c:	00000013          	nop
  60:	01c12083          	lw	ra,28(sp)
  64:	01812403          	lw	s0,24(sp)
  68:	02010113          	addi	sp,sp,32
  6c:	00008067          	ret

00000070 <iprint>:
  70:	fe010113          	addi	sp,sp,-32
  74:	00112e23          	sw	ra,28(sp)
  78:	00812c23          	sw	s0,24(sp)
  7c:	02010413          	addi	s0,sp,32
  80:	fea42623          	sw	a0,-20(s0)
  84:	0200006f          	j	a4 <iprint+0x34>
  88:	fec42783          	lw	a5,-20(s0)
  8c:	0007c783          	lbu	a5,0(a5)
  90:	00078513          	mv	a0,a5
  94:	f79ff0ef          	jal	c <write_term>
  98:	fec42783          	lw	a5,-20(s0)
  9c:	00178793          	addi	a5,a5,1
  a0:	fef42623          	sw	a5,-20(s0)
  a4:	fec42783          	lw	a5,-20(s0)
  a8:	fe0780e3          	beqz	a5,88 <iprint+0x18>
  ac:	00000013          	nop
  b0:	00000013          	nop
  b4:	01c12083          	lw	ra,28(sp)
  b8:	01812403          	lw	s0,24(sp)
  bc:	02010113          	addi	sp,sp,32
  c0:	00008067          	ret

000000c4 <main>:
  c4:	fe010113          	addi	sp,sp,-32
  c8:	00112e23          	sw	ra,28(sp)
  cc:	00812c23          	sw	s0,24(sp)
  d0:	02010413          	addi	s0,sp,32
  d4:	00000797          	auipc	a5,0x0
  d8:	01878793          	addi	a5,a5,24 # ec <main+0x28>
  dc:	fef42623          	sw	a5,-20(s0)
  e0:	fec42503          	lw	a0,-20(s0)
  e4:	f8dff0ef          	jal	70 <iprint>
  e8:	0000006f          	j	e8 <main+0x24>

Disassembly of section .rodata:

000000ec <.rodata>:
  ec:	6568                	.insn	2, 0x6568
  ee:	6c6c                	.insn	2, 0x6c6c
  f0:	00216f 	.3byte	0x00216f

Disassembly of section .interp:

000000f3 <.interp>:
  f3:	62696c2f          	.insn	4, 0x62696c2f
  f7:	2d646c2f          	.insn	4, 0x2d646c2f
  fb:	696c                	.insn	2, 0x696c
  fd:	756e                	.insn	2, 0x756e
  ff:	2d78                	.insn	2, 0x2d78
 101:	6972                	.insn	2, 0x6972
 103:	33766373          	.insn	4, 0x33766373
 107:	2d32                	.insn	2, 0x2d32
 109:	6c69                	.insn	2, 0x6c69
 10b:	3370                	.insn	2, 0x3370
 10d:	2e32                	.insn	2, 0x2e32
 10f:	312e6f73          	.insn	4, 0x312e6f73
	...

Disassembly of section .dynsym:

00000114 <.dynsym>:
	...
 130:	00010003          	lb	zero,0(sp)

Disassembly of section .dynstr:

00000134 <.dynstr>:
	...

Disassembly of section .gnu.hash:

00000138 <.gnu.hash>:
 138:	0001                	.insn	2, 0x0001
 13a:	0000                	.insn	2, 0x0000
 13c:	0001                	.insn	2, 0x0001
 13e:	0000                	.insn	2, 0x0000
 140:	0001                	.insn	2, 0x0001
	...

Disassembly of section .eh_frame:

00000150 <.eh_frame>:
 150:	0010                	.insn	2, 0x0010
 152:	0000                	.insn	2, 0x0000
 154:	0000                	.insn	2, 0x0000
 156:	0000                	.insn	2, 0x0000
 158:	00527a03          	.insn	4, 0x00527a03
 15c:	7c01                	.insn	2, 0x7c01
 15e:	0101                	.insn	2, 0x0101
 160:	00020c1b          	.insn	4, 0x00020c1b
 164:	0024                	.insn	2, 0x0024
 166:	0000                	.insn	2, 0x0000
 168:	0018                	.insn	2, 0x0018
 16a:	0000                	.insn	2, 0x0000
 16c:	fea0                	.insn	2, 0xfea0
 16e:	ffff                	.insn	2, 0xffff
 170:	0064                	.insn	2, 0x0064
 172:	0000                	.insn	2, 0x0000
 174:	4400                	.insn	2, 0x4400
 176:	200e                	.insn	2, 0x200e
 178:	8148                	.insn	2, 0x8148
 17a:	8801                	.insn	2, 0x8801
 17c:	4402                	.insn	2, 0x4402
 17e:	080c                	.insn	2, 0x080c
 180:	0200                	.insn	2, 0x0200
 182:	c148                	.insn	2, 0xc148
 184:	c844                	.insn	2, 0xc844
 186:	020c                	.insn	2, 0x020c
 188:	4420                	.insn	2, 0x4420
 18a:	000e                	.insn	2, 0x000e
 18c:	0024                	.insn	2, 0x0024
 18e:	0000                	.insn	2, 0x0000
 190:	0040                	.insn	2, 0x0040
 192:	0000                	.insn	2, 0x0000
 194:	fedc                	.insn	2, 0xfedc
 196:	ffff                	.insn	2, 0xffff
 198:	0054                	.insn	2, 0x0054
 19a:	0000                	.insn	2, 0x0000
 19c:	4400                	.insn	2, 0x4400
 19e:	200e                	.insn	2, 0x200e
 1a0:	8148                	.insn	2, 0x8148
 1a2:	8801                	.insn	2, 0x8801
 1a4:	4402                	.insn	2, 0x4402
 1a6:	080c                	.insn	2, 0x080c
 1a8:	7800                	.insn	2, 0x7800
 1aa:	44c1                	.insn	2, 0x44c1
 1ac:	0cc8                	.insn	2, 0x0cc8
 1ae:	2002                	.insn	2, 0x2002
 1b0:	0e44                	.insn	2, 0x0e44
 1b2:	0000                	.insn	2, 0x0000
 1b4:	001c                	.insn	2, 0x001c
 1b6:	0000                	.insn	2, 0x0000
 1b8:	0068                	.insn	2, 0x0068
 1ba:	0000                	.insn	2, 0x0000
 1bc:	ff08                	.insn	2, 0xff08
 1be:	ffff                	.insn	2, 0xffff
 1c0:	0028                	.insn	2, 0x0028
 1c2:	0000                	.insn	2, 0x0000
 1c4:	4400                	.insn	2, 0x4400
 1c6:	200e                	.insn	2, 0x200e
 1c8:	8148                	.insn	2, 0x8148
 1ca:	8801                	.insn	2, 0x8801
 1cc:	4402                	.insn	2, 0x4402
 1ce:	080c                	.insn	2, 0x080c
 1d0:	0000                	.insn	2, 0x0000
	...

Disassembly of section .eh_frame_hdr:

000001d4 <__GNU_EH_FRAME_HDR>:
 1d4:	1b01                	.insn	2, 0x1b01
 1d6:	ff783b03          	.insn	4, 0xff783b03
 1da:	ffff                	.insn	2, 0xffff
 1dc:	00000003          	lb	zero,0(zero) # 0 <_start>
 1e0:	fe38                	.insn	2, 0xfe38
 1e2:	ffff                	.insn	2, 0xffff
 1e4:	ff90                	.insn	2, 0xff90
 1e6:	ffff                	.insn	2, 0xffff
 1e8:	fe9c                	.insn	2, 0xfe9c
 1ea:	ffff                	.insn	2, 0xffff
 1ec:	ffb8                	.insn	2, 0xffb8
 1ee:	ffff                	.insn	2, 0xffff
 1f0:	fef0                	.insn	2, 0xfef0
 1f2:	ffff                	.insn	2, 0xffff
 1f4:	ffe0                	.insn	2, 0xffe0
 1f6:	ffff                	.insn	2, 0xffff

Disassembly of section .dynamic:

000001f8 <.dynamic>:
 1f8:	fef5                	.insn	2, 0xfef5
 1fa:	6fff 0138 0000 0005 	.insn	22, 0x0114000000060000013400000005000001386fff
 202:	0000 0134 0000 0006 
 20a:	0000 0114 0000 
 210:	000a                	.insn	2, 0x000a
 212:	0000                	.insn	2, 0x0000
 214:	0001                	.insn	2, 0x0001
 216:	0000                	.insn	2, 0x0000
 218:	0000000b          	.insn	4, 0x000b
 21c:	0010                	.insn	2, 0x0010
 21e:	0000                	.insn	2, 0x0000
 220:	0015                	.insn	2, 0x0015
 222:	0000                	.insn	2, 0x0000
 224:	0000                	.insn	2, 0x0000
 226:	0000                	.insn	2, 0x0000
 228:	00000007          	.insn	4, 0x0007
 22c:	0000                	.insn	2, 0x0000
 22e:	0000                	.insn	2, 0x0000
 230:	0008                	.insn	2, 0x0008
 232:	0000                	.insn	2, 0x0000
 234:	0000                	.insn	2, 0x0000
 236:	0000                	.insn	2, 0x0000
 238:	0009                	.insn	2, 0x0009
 23a:	0000                	.insn	2, 0x0000
 23c:	000c                	.insn	2, 0x000c
 23e:	0000                	.insn	2, 0x0000
 240:	6ffffffb          	.insn	4, 0x6ffffffb
 244:	0000                	.insn	2, 0x0000
 246:	0800                	.insn	2, 0x0800
	...

Disassembly of section .got:

00000278 <.got>:
 278:	01f8                	.insn	2, 0x01f8
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2941                	.insn	2, 0x2941
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <write_term+0x8>
   c:	001f 0000 1004      	.insn	6, 0x10040000001f
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	326d                	.insn	2, 0x326d
  1e:	3070                	.insn	2, 0x3070
  20:	7a5f 6d6d 6c75      	.insn	6, 0x6c756d6d7a5f
  26:	7031                	.insn	2, 0x7031
  28:	0030                	.insn	2, 0x0030

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	746e6547          	.insn	4, 0x746e6547
   a:	31206f6f          	jal	t5,631c <term_addr+0x60a0>
   e:	2e35                	.insn	2, 0x2e35
  10:	2e32                	.insn	2, 0x2e32
  12:	5f31                	.insn	2, 0x5f31
  14:	3270                	.insn	2, 0x3270
  16:	3230                	.insn	2, 0x3230
  18:	3135                	.insn	2, 0x3135
  1a:	3231                	.insn	2, 0x3231
  1c:	2032                	.insn	2, 0x2032
  1e:	3470                	.insn	2, 0x3470
  20:	2029                	.insn	2, 0x2029
  22:	3531                	.insn	2, 0x3531
  24:	322e                	.insn	2, 0x322e
  26:	312e                	.insn	2, 0x312e
  28:	3220                	.insn	2, 0x3220
  2a:	3230                	.insn	2, 0x3230
  2c:	3135                	.insn	2, 0x3135
  2e:	3231                	.insn	2, 0x3231
  30:	0032                	.insn	2, 0x0032
