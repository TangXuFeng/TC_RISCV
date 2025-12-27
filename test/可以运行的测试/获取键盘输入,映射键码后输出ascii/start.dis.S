
start.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	80000537          	lui	a0,0x80000
   4:	00050513          	mv	a0,a0
   8:	07300293          	li	t0,115
   c:	00550023          	sb	t0,0(a0) # 80000000 <_GLOBAL_OFFSET_TABLE_+0x7ffffb18>
  10:	00150513          	addi	a0,a0,1
  14:	07400293          	li	t0,116
  18:	00550023          	sb	t0,0(a0)
  1c:	00150513          	addi	a0,a0,1
  20:	06100293          	li	t0,97
  24:	00550023          	sb	t0,0(a0)
  28:	00150513          	addi	a0,a0,1
  2c:	07200293          	li	t0,114
  30:	00550023          	sb	t0,0(a0)
  34:	00150513          	addi	a0,a0,1
  38:	07400293          	li	t0,116
  3c:	00550023          	sb	t0,0(a0)
  40:	00150513          	addi	a0,a0,1
  44:	03a00293          	li	t0,58
  48:	00550023          	sb	t0,0(a0)
  4c:	00150513          	addi	a0,a0,1
  50:	00000293          	li	t0,0
  54:	00d00313          	li	t1,13

00000058 <map_zero_0_12>:
  58:	00550023          	sb	t0,0(a0)
  5c:	00150513          	addi	a0,a0,1
  60:	fff30313          	addi	t1,t1,-1
  64:	fe031ae3          	bnez	t1,58 <map_zero_0_12>
  68:	06000293          	li	t0,96
  6c:	00550023          	sb	t0,0(a0)
  70:	00150513          	addi	a0,a0,1
  74:	03100293          	li	t0,49
  78:	00c00313          	li	t1,12

0000007c <map_1_to_equal>:
  7c:	00550023          	sb	t0,0(a0)
  80:	00128293          	addi	t0,t0,1
  84:	00150513          	addi	a0,a0,1
  88:	fff30313          	addi	t1,t1,-1
  8c:	fe0318e3          	bnez	t1,7c <map_1_to_equal>
  90:	00050023          	sb	zero,0(a0)
  94:	00150513          	addi	a0,a0,1
  98:	00900293          	li	t0,9
  9c:	00550023          	sb	t0,0(a0)
  a0:	00150513          	addi	a0,a0,1
  a4:	07100293          	li	t0,113
  a8:	00550023          	sb	t0,0(a0)
  ac:	00150513          	addi	a0,a0,1
  b0:	07700293          	li	t0,119
  b4:	00550023          	sb	t0,0(a0)
  b8:	00150513          	addi	a0,a0,1
  bc:	06500293          	li	t0,101
  c0:	00550023          	sb	t0,0(a0)
  c4:	00150513          	addi	a0,a0,1
  c8:	07200293          	li	t0,114
  cc:	00550023          	sb	t0,0(a0)
  d0:	00150513          	addi	a0,a0,1
  d4:	07400293          	li	t0,116
  d8:	00550023          	sb	t0,0(a0)
  dc:	00150513          	addi	a0,a0,1
  e0:	07900293          	li	t0,121
  e4:	00550023          	sb	t0,0(a0)
  e8:	00150513          	addi	a0,a0,1
  ec:	07500293          	li	t0,117
  f0:	00550023          	sb	t0,0(a0)
  f4:	00150513          	addi	a0,a0,1
  f8:	06900293          	li	t0,105
  fc:	00550023          	sb	t0,0(a0)
 100:	00150513          	addi	a0,a0,1
 104:	06f00293          	li	t0,111
 108:	00550023          	sb	t0,0(a0)
 10c:	00150513          	addi	a0,a0,1
 110:	07000293          	li	t0,112
 114:	00550023          	sb	t0,0(a0)
 118:	00150513          	addi	a0,a0,1
 11c:	05b00293          	li	t0,91
 120:	00550023          	sb	t0,0(a0)
 124:	00150513          	addi	a0,a0,1
 128:	05d00293          	li	t0,93
 12c:	00550023          	sb	t0,0(a0)
 130:	00150513          	addi	a0,a0,1
 134:	05c00293          	li	t0,92
 138:	00550023          	sb	t0,0(a0)
 13c:	00150513          	addi	a0,a0,1
 140:	00050023          	sb	zero,0(a0)
 144:	00150513          	addi	a0,a0,1
 148:	06100293          	li	t0,97
 14c:	00550023          	sb	t0,0(a0)
 150:	00150513          	addi	a0,a0,1
 154:	07300293          	li	t0,115
 158:	00550023          	sb	t0,0(a0)
 15c:	00150513          	addi	a0,a0,1
 160:	06400293          	li	t0,100
 164:	00550023          	sb	t0,0(a0)
 168:	00150513          	addi	a0,a0,1
 16c:	06600293          	li	t0,102
 170:	00550023          	sb	t0,0(a0)
 174:	00150513          	addi	a0,a0,1
 178:	06700293          	li	t0,103
 17c:	00550023          	sb	t0,0(a0)
 180:	00150513          	addi	a0,a0,1
 184:	06800293          	li	t0,104
 188:	00550023          	sb	t0,0(a0)
 18c:	00150513          	addi	a0,a0,1
 190:	06a00293          	li	t0,106
 194:	00550023          	sb	t0,0(a0)
 198:	00150513          	addi	a0,a0,1
 19c:	06b00293          	li	t0,107
 1a0:	00550023          	sb	t0,0(a0)
 1a4:	00150513          	addi	a0,a0,1
 1a8:	06c00293          	li	t0,108
 1ac:	00550023          	sb	t0,0(a0)
 1b0:	00150513          	addi	a0,a0,1
 1b4:	03b00293          	li	t0,59
 1b8:	00550023          	sb	t0,0(a0)
 1bc:	00150513          	addi	a0,a0,1
 1c0:	02700293          	li	t0,39
 1c4:	00550023          	sb	t0,0(a0)
 1c8:	00150513          	addi	a0,a0,1
 1cc:	00a00293          	li	t0,10
 1d0:	00550023          	sb	t0,0(a0)
 1d4:	00150513          	addi	a0,a0,1
 1d8:	00050023          	sb	zero,0(a0)
 1dc:	00150513          	addi	a0,a0,1
 1e0:	07a00293          	li	t0,122
 1e4:	00550023          	sb	t0,0(a0)
 1e8:	00150513          	addi	a0,a0,1
 1ec:	07800293          	li	t0,120
 1f0:	00550023          	sb	t0,0(a0)
 1f4:	00150513          	addi	a0,a0,1
 1f8:	06300293          	li	t0,99
 1fc:	00550023          	sb	t0,0(a0)
 200:	00150513          	addi	a0,a0,1
 204:	07600293          	li	t0,118
 208:	00550023          	sb	t0,0(a0)
 20c:	00150513          	addi	a0,a0,1
 210:	06200293          	li	t0,98
 214:	00550023          	sb	t0,0(a0)
 218:	00150513          	addi	a0,a0,1
 21c:	06e00293          	li	t0,110
 220:	00550023          	sb	t0,0(a0)
 224:	00150513          	addi	a0,a0,1
 228:	06d00293          	li	t0,109
 22c:	00550023          	sb	t0,0(a0)
 230:	00150513          	addi	a0,a0,1
 234:	02c00293          	li	t0,44
 238:	00550023          	sb	t0,0(a0)
 23c:	00150513          	addi	a0,a0,1
 240:	02e00293          	li	t0,46
 244:	00550023          	sb	t0,0(a0)
 248:	00150513          	addi	a0,a0,1
 24c:	02f00293          	li	t0,47
 250:	00550023          	sb	t0,0(a0)
 254:	00150513          	addi	a0,a0,1
 258:	00050023          	sb	zero,0(a0)
 25c:	00150513          	addi	a0,a0,1
 260:	00050023          	sb	zero,0(a0)
 264:	00150513          	addi	a0,a0,1
 268:	00050023          	sb	zero,0(a0)
 26c:	00150513          	addi	a0,a0,1
 270:	02000293          	li	t0,32
 274:	00550023          	sb	t0,0(a0)
 278:	00150513          	addi	a0,a0,1
 27c:	00400313          	li	t1,4

00000280 <map_zero_69_72>:
 280:	00050023          	sb	zero,0(a0)
 284:	00150513          	addi	a0,a0,1
 288:	fff30313          	addi	t1,t1,-1
 28c:	fe031ae3          	bnez	t1,280 <map_zero_69_72>
 290:	00050023          	sb	zero,0(a0)
 294:	00150513          	addi	a0,a0,1
 298:	00a00293          	li	t0,10
 29c:	00550023          	sb	t0,0(a0)
 2a0:	00150513          	addi	a0,a0,1
 2a4:	00c00313          	li	t1,12

000002a8 <map_zero_75_86>:
 2a8:	00050023          	sb	zero,0(a0)
 2ac:	00150513          	addi	a0,a0,1
 2b0:	fff30313          	addi	t1,t1,-1
 2b4:	fe031ae3          	bnez	t1,2a8 <map_zero_75_86>
 2b8:	00400313          	li	t1,4

000002bc <map_zero_87_90>:
 2bc:	00050023          	sb	zero,0(a0)
 2c0:	00150513          	addi	a0,a0,1
 2c4:	fff30313          	addi	t1,t1,-1
 2c8:	fe031ae3          	bnez	t1,2bc <map_zero_87_90>
 2cc:	02a00293          	li	t0,42
 2d0:	00550023          	sb	t0,0(a0)
 2d4:	00150513          	addi	a0,a0,1
 2d8:	02f00293          	li	t0,47
 2dc:	00550023          	sb	t0,0(a0)
 2e0:	00150513          	addi	a0,a0,1
 2e4:	02d00293          	li	t0,45
 2e8:	00550023          	sb	t0,0(a0)
 2ec:	00150513          	addi	a0,a0,1
 2f0:	02e00293          	li	t0,46
 2f4:	00550023          	sb	t0,0(a0)
 2f8:	00150513          	addi	a0,a0,1
 2fc:	02b00293          	li	t0,43
 300:	00550023          	sb	t0,0(a0)
 304:	00150513          	addi	a0,a0,1
 308:	03000293          	li	t0,48
 30c:	00a00313          	li	t1,10

00000310 <map_kp_num>:
 310:	00550023          	sb	t0,0(a0)
 314:	00128293          	addi	t0,t0,1
 318:	00150513          	addi	a0,a0,1
 31c:	fff30313          	addi	t1,t1,-1
 320:	fe0318e3          	bnez	t1,310 <map_kp_num>
 324:	00050023          	sb	zero,0(a0)
 328:	00150513          	addi	a0,a0,1
 32c:	00050023          	sb	zero,0(a0)
 330:	00150513          	addi	a0,a0,1
 334:	00050023          	sb	zero,0(a0)
 338:	00150513          	addi	a0,a0,1
 33c:	09300313          	li	t1,147

00000340 <map_zero_rest>:
 340:	00050023          	sb	zero,0(a0)
 344:	00150513          	addi	a0,a0,1
 348:	fff30313          	addi	t1,t1,-1
 34c:	fe031ae3          	bnez	t1,340 <map_zero_rest>
 350:	90010537          	lui	a0,0x90010
 354:	00050513          	mv	a0,a0
 358:	900205b7          	lui	a1,0x90020
 35c:	00058593          	mv	a1,a1
 360:	80000637          	lui	a2,0x80000
 364:	00060613          	mv	a2,a2
 368:	07300293          	li	t0,115
 36c:	00550023          	sb	t0,0(a0) # 90010000 <_GLOBAL_OFFSET_TABLE_+0x9000fb18>
 370:	00150513          	addi	a0,a0,1
 374:	07400293          	li	t0,116
 378:	00550023          	sb	t0,0(a0)
 37c:	00150513          	addi	a0,a0,1
 380:	06100293          	li	t0,97
 384:	00550023          	sb	t0,0(a0)
 388:	00150513          	addi	a0,a0,1
 38c:	07200293          	li	t0,114
 390:	00550023          	sb	t0,0(a0)
 394:	00150513          	addi	a0,a0,1
 398:	07400293          	li	t0,116
 39c:	00550023          	sb	t0,0(a0)
 3a0:	00150513          	addi	a0,a0,1
 3a4:	03a00293          	li	t0,58
 3a8:	00550023          	sb	t0,0(a0)
 3ac:	00150513          	addi	a0,a0,1
 3b0:	00000293          	li	t0,0
 3b4:	10000313          	li	t1,256

000003b8 <keymap_loop>:
 3b8:	00560023          	sb	t0,0(a2) # 80000000 <_GLOBAL_OFFSET_TABLE_+0x7ffffb18>
 3bc:	00160613          	addi	a2,a2,1
 3c0:	00128293          	addi	t0,t0,1
 3c4:	fff30313          	addi	t1,t1,-1
 3c8:	fe0318e3          	bnez	t1,3b8 <keymap_loop>
 3cc:	80000637          	lui	a2,0x80000
 3d0:	00060613          	mv	a2,a2

000003d4 <poll_loop>:
 3d4:	00258283          	lb	t0,2(a1) # 90020002 <_GLOBAL_OFFSET_TABLE_+0x9001fb1a>
 3d8:	fe028ee3          	beqz	t0,3d4 <poll_loop>
 3dc:	0040006f          	j	3e0 <handle_event>

000003e0 <handle_event>:
 3e0:	00058023          	sb	zero,0(a1)
 3e4:	00058e03          	lb	t3,0(a1)
 3e8:	00158e83          	lb	t4,1(a1)
 3ec:	fe0e94e3          	bnez	t4,3d4 <poll_loop>
 3f0:	01c60f33          	add	t5,a2,t3
 3f4:	000f4f83          	lbu	t6,0(t5)
 3f8:	01f50023          	sb	t6,0(a0)
 3fc:	00150513          	addi	a0,a0,1
 400:	fd5ff06f          	j	3d4 <poll_loop>

00000404 <done>:
 404:	0000006f          	j	404 <done>

Disassembly of section .interp:

00000408 <.interp>:
 408:	62696c2f          	.insn	4, 0x62696c2f
 40c:	2d646c2f          	.insn	4, 0x2d646c2f
 410:	696c                	.insn	2, 0x696c
 412:	756e                	.insn	2, 0x756e
 414:	2d78                	.insn	2, 0x2d78
 416:	6972                	.insn	2, 0x6972
 418:	33766373          	.insn	4, 0x33766373
 41c:	2d32                	.insn	2, 0x2d32
 41e:	6c69                	.insn	2, 0x6c69
 420:	3370                	.insn	2, 0x3370
 422:	2e32                	.insn	2, 0x2e32
 424:	312e6f73          	.insn	4, 0x312e6f73
	...

Disassembly of section .dynsym:

0000042c <.dynsym>:
	...
 448:	00010003          	lb	zero,0(sp)

Disassembly of section .dynstr:

0000044c <.dynstr>:
	...

Disassembly of section .gnu.hash:

00000450 <.gnu.hash>:
 450:	0001                	.insn	2, 0x0001
 452:	0000                	.insn	2, 0x0000
 454:	0001                	.insn	2, 0x0001
 456:	0000                	.insn	2, 0x0000
 458:	0001                	.insn	2, 0x0001
	...

Disassembly of section .dynamic:

00000468 <.dynamic>:
 468:	fef5                	.insn	2, 0xfef5
 46a:	6fff 0450 0000 0005 	.insn	22, 0x042c000000060000044c00000005000004506fff
 472:	0000 044c 0000 0006 
 47a:	0000 042c 0000 
 480:	000a                	.insn	2, 0x000a
 482:	0000                	.insn	2, 0x0000
 484:	0001                	.insn	2, 0x0001
 486:	0000                	.insn	2, 0x0000
 488:	0000000b          	.insn	4, 0x000b
 48c:	0010                	.insn	2, 0x0010
 48e:	0000                	.insn	2, 0x0000
 490:	0015                	.insn	2, 0x0015
 492:	0000                	.insn	2, 0x0000
 494:	0000                	.insn	2, 0x0000
 496:	0000                	.insn	2, 0x0000
 498:	00000007          	.insn	4, 0x0007
 49c:	0000                	.insn	2, 0x0000
 49e:	0000                	.insn	2, 0x0000
 4a0:	0008                	.insn	2, 0x0008
 4a2:	0000                	.insn	2, 0x0000
 4a4:	0000                	.insn	2, 0x0000
 4a6:	0000                	.insn	2, 0x0000
 4a8:	0009                	.insn	2, 0x0009
 4aa:	0000                	.insn	2, 0x0000
 4ac:	000c                	.insn	2, 0x000c
 4ae:	0000                	.insn	2, 0x0000
 4b0:	6ffffffb          	.insn	4, 0x6ffffffb
 4b4:	0000                	.insn	2, 0x0000
 4b6:	0800                	.insn	2, 0x0800
	...

Disassembly of section .got:

000004e8 <.got>:
 4e8:	0468                	.insn	2, 0x0468
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2741                	.insn	2, 0x2741
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <_start+0x14>
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
