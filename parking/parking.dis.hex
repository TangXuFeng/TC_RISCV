
parking_baremetal.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	36c000ef          	jal	370 <main>
   8:	0000006f          	j	8 <_start+0x8>

0000000c <my_putc>:
   c:	fd010113          	addi	sp,sp,-48 # ffd0 <cursor+0xf898>
  10:	02112623          	sw	ra,44(sp)
  14:	02812423          	sw	s0,40(sp)
  18:	03010413          	addi	s0,sp,48
  1c:	00050793          	mv	a5,a0
  20:	fcf40fa3          	sb	a5,-33(s0)
  24:	500007b7          	lui	a5,0x50000
  28:	fef42623          	sw	a5,-20(s0)
  2c:	fdf44703          	lbu	a4,-33(s0)
  30:	00a00793          	li	a5,10
  34:	04f71863          	bne	a4,a5,84 <my_putc+0x78>
  38:	00000797          	auipc	a5,0x0
  3c:	70078793          	addi	a5,a5,1792 # 738 <cursor>
  40:	0007a783          	lw	a5,0(a5)
  44:	66666737          	lui	a4,0x66666
  48:	66770713          	addi	a4,a4,1639 # 66666667 <cursor+0x66665f2f>
  4c:	02e79733          	mulh	a4,a5,a4
  50:	40575713          	srai	a4,a4,0x5
  54:	41f7d793          	srai	a5,a5,0x1f
  58:	40f707b3          	sub	a5,a4,a5
  5c:	00178713          	addi	a4,a5,1
  60:	00070793          	mv	a5,a4
  64:	00279793          	slli	a5,a5,0x2
  68:	00e787b3          	add	a5,a5,a4
  6c:	00479793          	slli	a5,a5,0x4
  70:	00078713          	mv	a4,a5
  74:	00000797          	auipc	a5,0x0
  78:	6c478793          	addi	a5,a5,1732 # 738 <cursor>
  7c:	00e7a023          	sw	a4,0(a5)
  80:	0340006f          	j	b4 <my_putc+0xa8>
  84:	00000797          	auipc	a5,0x0
  88:	6b478793          	addi	a5,a5,1716 # 738 <cursor>
  8c:	0007a783          	lw	a5,0(a5)
  90:	00178693          	addi	a3,a5,1
  94:	00000717          	auipc	a4,0x0
  98:	6a470713          	addi	a4,a4,1700 # 738 <cursor>
  9c:	00d72023          	sw	a3,0(a4)
  a0:	00078713          	mv	a4,a5
  a4:	fec42783          	lw	a5,-20(s0)
  a8:	00e787b3          	add	a5,a5,a4
  ac:	fdf44703          	lbu	a4,-33(s0)
  b0:	00e78023          	sb	a4,0(a5)
  b4:	00000797          	auipc	a5,0x0
  b8:	68478793          	addi	a5,a5,1668 # 738 <cursor>
  bc:	0007a703          	lw	a4,0(a5)
  c0:	7cf00793          	li	a5,1999
  c4:	00e7d863          	bge	a5,a4,d4 <my_putc+0xc8>
  c8:	00000797          	auipc	a5,0x0
  cc:	67078793          	addi	a5,a5,1648 # 738 <cursor>
  d0:	0007a023          	sw	zero,0(a5)
  d4:	00000013          	nop
  d8:	02c12083          	lw	ra,44(sp)
  dc:	02812403          	lw	s0,40(sp)
  e0:	03010113          	addi	sp,sp,48
  e4:	00008067          	ret

000000e8 <my_console_print>:
  e8:	fe010113          	addi	sp,sp,-32
  ec:	00112e23          	sw	ra,28(sp)
  f0:	00812c23          	sw	s0,24(sp)
  f4:	02010413          	addi	s0,sp,32
  f8:	fea42623          	sw	a0,-20(s0)
  fc:	01c0006f          	j	118 <my_console_print+0x30>
 100:	fec42783          	lw	a5,-20(s0)
 104:	00178713          	addi	a4,a5,1
 108:	fee42623          	sw	a4,-20(s0)
 10c:	0007c783          	lbu	a5,0(a5)
 110:	00078513          	mv	a0,a5
 114:	ef9ff0ef          	jal	c <my_putc>
 118:	fec42783          	lw	a5,-20(s0)
 11c:	0007c783          	lbu	a5,0(a5)
 120:	fe0790e3          	bnez	a5,100 <my_console_print+0x18>
 124:	00000013          	nop
 128:	00000013          	nop
 12c:	01c12083          	lw	ra,28(sp)
 130:	01812403          	lw	s0,24(sp)
 134:	02010113          	addi	sp,sp,32
 138:	00008067          	ret

0000013c <handle_keyboard_interrupt>:
 13c:	fe010113          	addi	sp,sp,-32
 140:	00112e23          	sw	ra,28(sp)
 144:	00812c23          	sw	s0,24(sp)
 148:	00e12a23          	sw	a4,20(sp)
 14c:	00f12823          	sw	a5,16(sp)
 150:	02010413          	addi	s0,sp,32
 154:	400007b7          	lui	a5,0x40000
 158:	0007a783          	lw	a5,0(a5) # 40000000 <cursor+0x3ffff8c8>
 15c:	fef407a3          	sb	a5,-17(s0)
 160:	00000797          	auipc	a5,0x0
 164:	5d078793          	addi	a5,a5,1488 # 730 <head>
 168:	0007a783          	lw	a5,0(a5)
 16c:	00178713          	addi	a4,a5,1
 170:	41f75793          	srai	a5,a4,0x1f
 174:	01a7d793          	srli	a5,a5,0x1a
 178:	00f70733          	add	a4,a4,a5
 17c:	03f77713          	andi	a4,a4,63
 180:	40f707b3          	sub	a5,a4,a5
 184:	fef42423          	sw	a5,-24(s0)
 188:	00000797          	auipc	a5,0x0
 18c:	5ac78793          	addi	a5,a5,1452 # 734 <tail>
 190:	0007a783          	lw	a5,0(a5)
 194:	fe842703          	lw	a4,-24(s0)
 198:	02f70a63          	beq	a4,a5,1cc <handle_keyboard_interrupt+0x90>
 19c:	00000797          	auipc	a5,0x0
 1a0:	59478793          	addi	a5,a5,1428 # 730 <head>
 1a4:	0007a783          	lw	a5,0(a5)
 1a8:	00000717          	auipc	a4,0x0
 1ac:	54870713          	addi	a4,a4,1352 # 6f0 <kbd_buffer>
 1b0:	00f707b3          	add	a5,a4,a5
 1b4:	fef44703          	lbu	a4,-17(s0)
 1b8:	00e78023          	sb	a4,0(a5)
 1bc:	00000797          	auipc	a5,0x0
 1c0:	57478793          	addi	a5,a5,1396 # 730 <head>
 1c4:	fe842703          	lw	a4,-24(s0)
 1c8:	00e7a023          	sw	a4,0(a5)
 1cc:	00000013          	nop
 1d0:	01c12083          	lw	ra,28(sp)
 1d4:	01812403          	lw	s0,24(sp)
 1d8:	01412703          	lw	a4,20(sp)
 1dc:	01012783          	lw	a5,16(sp)
 1e0:	02010113          	addi	sp,sp,32
 1e4:	30200073          	mret

000001e8 <my_get_char>:
 1e8:	fe010113          	addi	sp,sp,-32
 1ec:	00112e23          	sw	ra,28(sp)
 1f0:	00812c23          	sw	s0,24(sp)
 1f4:	02010413          	addi	s0,sp,32
 1f8:	00000013          	nop
 1fc:	00000797          	auipc	a5,0x0
 200:	53478793          	addi	a5,a5,1332 # 730 <head>
 204:	0007a703          	lw	a4,0(a5)
 208:	00000797          	auipc	a5,0x0
 20c:	52c78793          	addi	a5,a5,1324 # 734 <tail>
 210:	0007a783          	lw	a5,0(a5)
 214:	fef704e3          	beq	a4,a5,1fc <my_get_char+0x14>
 218:	00000797          	auipc	a5,0x0
 21c:	51c78793          	addi	a5,a5,1308 # 734 <tail>
 220:	0007a783          	lw	a5,0(a5)
 224:	00000717          	auipc	a4,0x0
 228:	4cc70713          	addi	a4,a4,1228 # 6f0 <kbd_buffer>
 22c:	00f707b3          	add	a5,a4,a5
 230:	0007c783          	lbu	a5,0(a5)
 234:	fef407a3          	sb	a5,-17(s0)
 238:	00000797          	auipc	a5,0x0
 23c:	4fc78793          	addi	a5,a5,1276 # 734 <tail>
 240:	0007a783          	lw	a5,0(a5)
 244:	00178713          	addi	a4,a5,1
 248:	41f75793          	srai	a5,a4,0x1f
 24c:	01a7d793          	srli	a5,a5,0x1a
 250:	00f70733          	add	a4,a4,a5
 254:	03f77713          	andi	a4,a4,63
 258:	40f707b3          	sub	a5,a4,a5
 25c:	00078713          	mv	a4,a5
 260:	00000797          	auipc	a5,0x0
 264:	4d478793          	addi	a5,a5,1236 # 734 <tail>
 268:	00e7a023          	sw	a4,0(a5)
 26c:	fef44783          	lbu	a5,-17(s0)
 270:	00078513          	mv	a0,a5
 274:	01c12083          	lw	ra,28(sp)
 278:	01812403          	lw	s0,24(sp)
 27c:	02010113          	addi	sp,sp,32
 280:	00008067          	ret

00000284 <my_print_int>:
 284:	fd010113          	addi	sp,sp,-48
 288:	02112623          	sw	ra,44(sp)
 28c:	02812423          	sw	s0,40(sp)
 290:	03010413          	addi	s0,sp,48
 294:	fca42e23          	sw	a0,-36(s0)
 298:	fdc42783          	lw	a5,-36(s0)
 29c:	00079863          	bnez	a5,2ac <my_print_int+0x28>
 2a0:	03000513          	li	a0,48
 2a4:	d69ff0ef          	jal	c <my_putc>
 2a8:	0b80006f          	j	360 <my_print_int+0xdc>
 2ac:	fe042623          	sw	zero,-20(s0)
 2b0:	0780006f          	j	328 <my_print_int+0xa4>
 2b4:	fdc42703          	lw	a4,-36(s0)
 2b8:	666667b7          	lui	a5,0x66666
 2bc:	66778793          	addi	a5,a5,1639 # 66666667 <cursor+0x66665f2f>
 2c0:	02f717b3          	mulh	a5,a4,a5
 2c4:	4027d693          	srai	a3,a5,0x2
 2c8:	41f75793          	srai	a5,a4,0x1f
 2cc:	40f686b3          	sub	a3,a3,a5
 2d0:	00068793          	mv	a5,a3
 2d4:	00279793          	slli	a5,a5,0x2
 2d8:	00d787b3          	add	a5,a5,a3
 2dc:	00179793          	slli	a5,a5,0x1
 2e0:	40f706b3          	sub	a3,a4,a5
 2e4:	0ff6f713          	zext.b	a4,a3
 2e8:	fec42783          	lw	a5,-20(s0)
 2ec:	00178693          	addi	a3,a5,1
 2f0:	fed42623          	sw	a3,-20(s0)
 2f4:	03070713          	addi	a4,a4,48
 2f8:	0ff77713          	zext.b	a4,a4
 2fc:	ff078793          	addi	a5,a5,-16
 300:	008787b3          	add	a5,a5,s0
 304:	fee78823          	sb	a4,-16(a5)
 308:	fdc42783          	lw	a5,-36(s0)
 30c:	66666737          	lui	a4,0x66666
 310:	66770713          	addi	a4,a4,1639 # 66666667 <cursor+0x66665f2f>
 314:	02e79733          	mulh	a4,a5,a4
 318:	40275713          	srai	a4,a4,0x2
 31c:	41f7d793          	srai	a5,a5,0x1f
 320:	40f707b3          	sub	a5,a4,a5
 324:	fcf42e23          	sw	a5,-36(s0)
 328:	fdc42783          	lw	a5,-36(s0)
 32c:	f8f044e3          	bgtz	a5,2b4 <my_print_int+0x30>
 330:	0280006f          	j	358 <my_print_int+0xd4>
 334:	fec42783          	lw	a5,-20(s0)
 338:	fff78793          	addi	a5,a5,-1
 33c:	fef42623          	sw	a5,-20(s0)
 340:	fec42783          	lw	a5,-20(s0)
 344:	ff078793          	addi	a5,a5,-16
 348:	008787b3          	add	a5,a5,s0
 34c:	ff07c783          	lbu	a5,-16(a5)
 350:	00078513          	mv	a0,a5
 354:	cb9ff0ef          	jal	c <my_putc>
 358:	fec42783          	lw	a5,-20(s0)
 35c:	fcf04ce3          	bgtz	a5,334 <my_print_int+0xb0>
 360:	02c12083          	lw	ra,44(sp)
 364:	02812403          	lw	s0,40(sp)
 368:	03010113          	addi	sp,sp,48
 36c:	00008067          	ret

00000370 <main>:
 370:	fd010113          	addi	sp,sp,-48
 374:	02112623          	sw	ra,44(sp)
 378:	02812423          	sw	s0,40(sp)
 37c:	03010413          	addi	s0,sp,48
 380:	00000517          	auipc	a0,0x0
 384:	10c50513          	addi	a0,a0,268 # 48c <main+0x11c>
 388:	d61ff0ef          	jal	e8 <my_console_print>
 38c:	00800793          	li	a5,8
 390:	fef42023          	sw	a5,-32(s0)
 394:	01e00793          	li	a5,30
 398:	fcf42e23          	sw	a5,-36(s0)
 39c:	00a00793          	li	a5,10
 3a0:	fcf42c23          	sw	a5,-40(s0)
 3a4:	02d00793          	li	a5,45
 3a8:	fcf42a23          	sw	a5,-44(s0)
 3ac:	fd842703          	lw	a4,-40(s0)
 3b0:	00070793          	mv	a5,a4
 3b4:	00479793          	slli	a5,a5,0x4
 3b8:	40e787b3          	sub	a5,a5,a4
 3bc:	00279793          	slli	a5,a5,0x2
 3c0:	00078713          	mv	a4,a5
 3c4:	fd442783          	lw	a5,-44(s0)
 3c8:	00f706b3          	add	a3,a4,a5
 3cc:	fe042703          	lw	a4,-32(s0)
 3d0:	00070793          	mv	a5,a4
 3d4:	00479793          	slli	a5,a5,0x4
 3d8:	40e787b3          	sub	a5,a5,a4
 3dc:	00279793          	slli	a5,a5,0x2
 3e0:	00078713          	mv	a4,a5
 3e4:	fdc42783          	lw	a5,-36(s0)
 3e8:	00f707b3          	add	a5,a4,a5
 3ec:	40f687b3          	sub	a5,a3,a5
 3f0:	fef42623          	sw	a5,-20(s0)
 3f4:	fec42783          	lw	a5,-20(s0)
 3f8:	0007d863          	bgez	a5,408 <main+0x98>
 3fc:	fec42783          	lw	a5,-20(s0)
 400:	5a078793          	addi	a5,a5,1440
 404:	fef42623          	sw	a5,-20(s0)
 408:	fe042423          	sw	zero,-24(s0)
 40c:	fec42783          	lw	a5,-20(s0)
 410:	03b78793          	addi	a5,a5,59
 414:	fef42223          	sw	a5,-28(s0)
 418:	01c0006f          	j	434 <main+0xc4>
 41c:	fe442783          	lw	a5,-28(s0)
 420:	fc478793          	addi	a5,a5,-60
 424:	fef42223          	sw	a5,-28(s0)
 428:	fe842783          	lw	a5,-24(s0)
 42c:	00178793          	addi	a5,a5,1
 430:	fef42423          	sw	a5,-24(s0)
 434:	fe442703          	lw	a4,-28(s0)
 438:	03b00793          	li	a5,59
 43c:	fee7c0e3          	blt	a5,a4,41c <main+0xac>
 440:	fe842703          	lw	a4,-24(s0)
 444:	00070793          	mv	a5,a4
 448:	00279793          	slli	a5,a5,0x2
 44c:	00e787b3          	add	a5,a5,a4
 450:	fcf42823          	sw	a5,-48(s0)
 454:	00000517          	auipc	a0,0x0
 458:	05c50513          	addi	a0,a0,92 # 4b0 <_PROCEDURE_LINKAGE_TABLE_+0x20>
 45c:	c8dff0ef          	jal	e8 <my_console_print>
 460:	fec42503          	lw	a0,-20(s0)
 464:	e21ff0ef          	jal	284 <my_print_int>
 468:	00000517          	auipc	a0,0x0
 46c:	05450513          	addi	a0,a0,84 # 4bc <_PROCEDURE_LINKAGE_TABLE_+0x2c>
 470:	c79ff0ef          	jal	e8 <my_console_print>
 474:	fd042503          	lw	a0,-48(s0)
 478:	e0dff0ef          	jal	284 <my_print_int>
 47c:	00000517          	auipc	a0,0x0
 480:	04c50513          	addi	a0,a0,76 # 4c8 <_PROCEDURE_LINKAGE_TABLE_+0x38>
 484:	c65ff0ef          	jal	e8 <my_console_print>
 488:	0000006f          	j	488 <main+0x118>

Disassembly of section .rodata:

0000048c <.rodata>:
 48c:	74737953          	.insn	4, 0x74737953
 490:	6d65                	.insn	2, 0x6d65
 492:	5220                	.insn	2, 0x5220
 494:	6165                	.insn	2, 0x6165
 496:	7964                	.insn	2, 0x7964
 498:	202e                	.insn	2, 0x202e
 49a:	74696157          	.insn	4, 0x74696157
 49e:	6e69                	.insn	2, 0x6e69
 4a0:	6f662067          	.insn	4, 0x6f662067
 4a4:	2072                	.insn	2, 0x2072
 4a6:	6e69                	.insn	2, 0x6e69
 4a8:	7570                	.insn	2, 0x7570
 4aa:	2e74                	.insn	2, 0x2e74
 4ac:	2e2e                	.insn	2, 0x2e2e
 4ae:	000a                	.insn	2, 0x000a
 4b0:	7544                	.insn	2, 0x7544
 4b2:	6172                	.insn	2, 0x6172
 4b4:	6974                	.insn	2, 0x6974
 4b6:	203a6e6f          	jal	t3,a6eb8 <cursor+0xa6780>
 4ba:	0000                	.insn	2, 0x0000
 4bc:	6d20                	.insn	2, 0x6d20
 4be:	6e69                	.insn	2, 0x6e69
 4c0:	65460a73          	.insn	4, 0x65460a73
 4c4:	3a65                	.insn	2, 0x3a65
 4c6:	0020                	.insn	2, 0x0020
 4c8:	5920                	.insn	2, 0x5920
 4ca:	6175                	.insn	2, 0x6175
 4cc:	0a6e                	.insn	2, 0x0a6e
	...

Disassembly of section .interp:

000004cf <.interp>:
 4cf:	62696c2f          	.insn	4, 0x62696c2f
 4d3:	2d646c2f          	.insn	4, 0x2d646c2f
 4d7:	696c                	.insn	2, 0x696c
 4d9:	756e                	.insn	2, 0x756e
 4db:	2d78                	.insn	2, 0x2d78
 4dd:	6972                	.insn	2, 0x6972
 4df:	33766373          	.insn	4, 0x33766373
 4e3:	2d32                	.insn	2, 0x2d32
 4e5:	6c69                	.insn	2, 0x6c69
 4e7:	3370                	.insn	2, 0x3370
 4e9:	2e32                	.insn	2, 0x2e32
 4eb:	312e6f73          	.insn	4, 0x312e6f73
	...

Disassembly of section .dynsym:

000004f0 <.dynsym>:
	...
 50c:	00010003          	lb	zero,0(sp)

Disassembly of section .dynstr:

00000510 <.dynstr>:
	...

Disassembly of section .gnu.hash:

00000514 <.gnu.hash>:
 514:	0001                	.insn	2, 0x0001
 516:	0000                	.insn	2, 0x0000
 518:	0001                	.insn	2, 0x0001
 51a:	0000                	.insn	2, 0x0000
 51c:	0001                	.insn	2, 0x0001
	...

Disassembly of section .eh_frame:

0000052c <.eh_frame>:
 52c:	0010                	.insn	2, 0x0010
 52e:	0000                	.insn	2, 0x0000
 530:	0000                	.insn	2, 0x0000
 532:	0000                	.insn	2, 0x0000
 534:	00527a03          	.insn	4, 0x00527a03
 538:	7c01                	.insn	2, 0x7c01
 53a:	0101                	.insn	2, 0x0101
 53c:	00020c1b          	.insn	4, 0x00020c1b
 540:	0024                	.insn	2, 0x0024
 542:	0000                	.insn	2, 0x0000
 544:	0018                	.insn	2, 0x0018
 546:	0000                	.insn	2, 0x0000
 548:	fac4                	.insn	2, 0xfac4
 54a:	ffff                	.insn	2, 0xffff
 54c:	00dc                	.insn	2, 0x00dc
 54e:	0000                	.insn	2, 0x0000
 550:	4400                	.insn	2, 0x4400
 552:	300e                	.insn	2, 0x300e
 554:	8148                	.insn	2, 0x8148
 556:	8801                	.insn	2, 0x8801
 558:	4402                	.insn	2, 0x4402
 55a:	080c                	.insn	2, 0x080c
 55c:	0200                	.insn	2, 0x0200
 55e:	c1c0                	.insn	2, 0xc1c0
 560:	c844                	.insn	2, 0xc844
 562:	020c                	.insn	2, 0x020c
 564:	4430                	.insn	2, 0x4430
 566:	000e                	.insn	2, 0x000e
 568:	0024                	.insn	2, 0x0024
 56a:	0000                	.insn	2, 0x0000
 56c:	0040                	.insn	2, 0x0040
 56e:	0000                	.insn	2, 0x0000
 570:	fb78                	.insn	2, 0xfb78
 572:	ffff                	.insn	2, 0xffff
 574:	0054                	.insn	2, 0x0054
 576:	0000                	.insn	2, 0x0000
 578:	4400                	.insn	2, 0x4400
 57a:	200e                	.insn	2, 0x200e
 57c:	8148                	.insn	2, 0x8148
 57e:	8801                	.insn	2, 0x8801
 580:	4402                	.insn	2, 0x4402
 582:	080c                	.insn	2, 0x080c
 584:	7800                	.insn	2, 0x7800
 586:	44c1                	.insn	2, 0x44c1
 588:	0cc8                	.insn	2, 0x0cc8
 58a:	2002                	.insn	2, 0x2002
 58c:	0e44                	.insn	2, 0x0e44
 58e:	0000                	.insn	2, 0x0000
 590:	002c                	.insn	2, 0x002c
 592:	0000                	.insn	2, 0x0000
 594:	0068                	.insn	2, 0x0068
 596:	0000                	.insn	2, 0x0000
 598:	fba4                	.insn	2, 0xfba4
 59a:	ffff                	.insn	2, 0xffff
 59c:	00ac                	.insn	2, 0x00ac
 59e:	0000                	.insn	2, 0x0000
 5a0:	4400                	.insn	2, 0x4400
 5a2:	200e                	.insn	2, 0x200e
 5a4:	8150                	.insn	2, 0x8150
 5a6:	8801                	.insn	2, 0x8801
 5a8:	8e02                	.insn	2, 0x8e02
 5aa:	44048f03          	lb	t5,1088(s1)
 5ae:	080c                	.insn	2, 0x080c
 5b0:	0200                	.insn	2, 0x0200
 5b2:	c180                	.insn	2, 0xc180
 5b4:	c844                	.insn	2, 0xc844
 5b6:	020c                	.insn	2, 0x020c
 5b8:	4420                	.insn	2, 0x4420
 5ba:	44ce                	.insn	2, 0x44ce
 5bc:	000e44cf          	.insn	4, 0x000e44cf
 5c0:	0024                	.insn	2, 0x0024
 5c2:	0000                	.insn	2, 0x0000
 5c4:	0098                	.insn	2, 0x0098
 5c6:	0000                	.insn	2, 0x0000
 5c8:	fc20                	.insn	2, 0xfc20
 5ca:	ffff                	.insn	2, 0xffff
 5cc:	009c                	.insn	2, 0x009c
 5ce:	0000                	.insn	2, 0x0000
 5d0:	4400                	.insn	2, 0x4400
 5d2:	200e                	.insn	2, 0x200e
 5d4:	8148                	.insn	2, 0x8148
 5d6:	8801                	.insn	2, 0x8801
 5d8:	4402                	.insn	2, 0x4402
 5da:	080c                	.insn	2, 0x080c
 5dc:	0200                	.insn	2, 0x0200
 5de:	c180                	.insn	2, 0xc180
 5e0:	c844                	.insn	2, 0xc844
 5e2:	020c                	.insn	2, 0x020c
 5e4:	4420                	.insn	2, 0x4420
 5e6:	000e                	.insn	2, 0x000e
 5e8:	0024                	.insn	2, 0x0024
 5ea:	0000                	.insn	2, 0x0000
 5ec:	00c0                	.insn	2, 0x00c0
 5ee:	0000                	.insn	2, 0x0000
 5f0:	fc94                	.insn	2, 0xfc94
 5f2:	ffff                	.insn	2, 0xffff
 5f4:	00ec                	.insn	2, 0x00ec
 5f6:	0000                	.insn	2, 0x0000
 5f8:	4400                	.insn	2, 0x4400
 5fa:	300e                	.insn	2, 0x300e
 5fc:	8148                	.insn	2, 0x8148
 5fe:	8801                	.insn	2, 0x8801
 600:	4402                	.insn	2, 0x4402
 602:	080c                	.insn	2, 0x080c
 604:	0200                	.insn	2, 0x0200
 606:	c1d0                	.insn	2, 0xc1d0
 608:	c844                	.insn	2, 0xc844
 60a:	020c                	.insn	2, 0x020c
 60c:	4430                	.insn	2, 0x4430
 60e:	000e                	.insn	2, 0x000e
 610:	001c                	.insn	2, 0x001c
 612:	0000                	.insn	2, 0x0000
 614:	00e8                	.insn	2, 0x00e8
 616:	0000                	.insn	2, 0x0000
 618:	fd58                	.insn	2, 0xfd58
 61a:	ffff                	.insn	2, 0xffff
 61c:	011c                	.insn	2, 0x011c
 61e:	0000                	.insn	2, 0x0000
 620:	4400                	.insn	2, 0x4400
 622:	300e                	.insn	2, 0x300e
 624:	8148                	.insn	2, 0x8148
 626:	8801                	.insn	2, 0x8801
 628:	4402                	.insn	2, 0x4402
 62a:	080c                	.insn	2, 0x080c
 62c:	0000                	.insn	2, 0x0000
	...

Disassembly of section .eh_frame_hdr:

00000630 <__GNU_EH_FRAME_HDR>:
 630:	1b01                	.insn	2, 0x1b01
 632:	fef83b03          	.insn	4, 0xfef83b03
 636:	ffff                	.insn	2, 0xffff
 638:	0006                	.insn	2, 0x0006
 63a:	0000                	.insn	2, 0x0000
 63c:	f9dc                	.insn	2, 0xf9dc
 63e:	ffff                	.insn	2, 0xffff
 640:	ff10                	.insn	2, 0xff10
 642:	ffff                	.insn	2, 0xffff
 644:	fab8                	.insn	2, 0xfab8
 646:	ffff                	.insn	2, 0xffff
 648:	ff38                	.insn	2, 0xff38
 64a:	ffff                	.insn	2, 0xffff
 64c:	fb0c                	.insn	2, 0xfb0c
 64e:	ffff                	.insn	2, 0xffff
 650:	ff60                	.insn	2, 0xff60
 652:	ffff                	.insn	2, 0xffff
 654:	fbb8                	.insn	2, 0xfbb8
 656:	ffff                	.insn	2, 0xffff
 658:	ff90                	.insn	2, 0xff90
 65a:	ffff                	.insn	2, 0xffff
 65c:	fc54                	.insn	2, 0xfc54
 65e:	ffff                	.insn	2, 0xffff
 660:	ffb8                	.insn	2, 0xffb8
 662:	ffff                	.insn	2, 0xffff
 664:	fd40                	.insn	2, 0xfd40
 666:	ffff                	.insn	2, 0xffff
 668:	ffe0                	.insn	2, 0xffe0
 66a:	ffff                	.insn	2, 0xffff

Disassembly of section .dynamic:

0000066c <.dynamic>:
 66c:	fef5                	.insn	2, 0xfef5
 66e:	6fff 0514 0000 0005 	.insn	22, 0x04f0000000060000051000000005000005146fff
 676:	0000 0510 0000 0006 
 67e:	0000 04f0 0000 
 684:	000a                	.insn	2, 0x000a
 686:	0000                	.insn	2, 0x0000
 688:	0001                	.insn	2, 0x0001
 68a:	0000                	.insn	2, 0x0000
 68c:	0000000b          	.insn	4, 0x000b
 690:	0010                	.insn	2, 0x0010
 692:	0000                	.insn	2, 0x0000
 694:	0015                	.insn	2, 0x0015
 696:	0000                	.insn	2, 0x0000
 698:	0000                	.insn	2, 0x0000
 69a:	0000                	.insn	2, 0x0000
 69c:	00000007          	.insn	4, 0x0007
 6a0:	0000                	.insn	2, 0x0000
 6a2:	0000                	.insn	2, 0x0000
 6a4:	0008                	.insn	2, 0x0008
 6a6:	0000                	.insn	2, 0x0000
 6a8:	0000                	.insn	2, 0x0000
 6aa:	0000                	.insn	2, 0x0000
 6ac:	0009                	.insn	2, 0x0009
 6ae:	0000                	.insn	2, 0x0000
 6b0:	000c                	.insn	2, 0x000c
 6b2:	0000                	.insn	2, 0x0000
 6b4:	6ffffffb          	.insn	4, 0x6ffffffb
 6b8:	0000                	.insn	2, 0x0000
 6ba:	0800                	.insn	2, 0x0800
	...

Disassembly of section .got:

000006ec <.got>:
 6ec:	066c                	.insn	2, 0x066c
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2d41                	.insn	2, 0x2d41
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <my_putc+0x8>
   c:	00000023          	sb	zero,0(zero) # 0 <_start>
  10:	1004                	.insn	2, 0x1004
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
  2a:	0108                	.insn	2, 0x0108
  2c:	0b0a                	.insn	2, 0x0b0a

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	746e6547          	.insn	4, 0x746e6547
   a:	31206f6f          	jal	t5,631c <cursor+0x5be4>
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
