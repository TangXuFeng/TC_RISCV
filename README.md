* 一个Turing Complete中网络接口的胶水代码(还没做完,诚实...)
* 关于文档,去看: http://riscvbook.com/


<details>
<summary>整体结构</summary>

<pre>

1.实现部分riscv指令
2.实现中断功能
3.实现定时器
4.将功能映射到内存地址
5.单周期
6.暂时不会实现特权模式




整体布局
riscv(
 core(
  pc()
  regfile()
  instruction_decoder()
  executor(
   alu()
  )
 )
 memory_contorller()
 memory()
 network_mmio()
 console_mmio()
 keyboard_mmio()
 interrup_controller(
  timer_imterrup()
 )
 clock_mmio()
)


</pre>

</details>


<details>
<summary>指令集</summary>

<pre>

实现指令集
标记-的是还没实现,但是准备实现的
标记/-是不准备实现的
标记?的是已经实现,但是被禁用的,都是RV32M
嗯,如果你的综合器真的能做出来这东西的话,可以在ALU中启用

```

add      x[rd] = x[rs1] + x[rs2]
addi     x[rd] = x[rs1] + sext(immediate)
and      x[rd] = x[rs1] & x[rs2]
andi     x[rd] = x[rs1] & sext(immediate)
auipc    x[rd] = pc + sext(immediate[31:12] << 12)
beq      if (rs1 == rs2) pc += sext(offset)
bge      if (rs1 ≥s rs2) pc += sext(offset)
bgeu     if (rs1 ≥u rs2) pc += sext(offset)
blt      if (rs1 <s rs2) pc += sext(offset)
bltu     if (rs1 <u rs2) pc += sext(offset)
bne      if (rs1 ̸= rs2) pc += sext(offset)
div      x[rd] = x[rs1] ÷s x[rs2]
divu     x[rd] = x[rs1] ÷u x[rs2]
ebreak   RaiseException(Breakpoint)
ecall    RaiseException(EnvironmentCall)
jal      x[rd] = pc+4; pc += sext(offset)
jalr     t=pc+4; pc=(x[rs1]+sext(offset))&∼1; x[rd]=t
lb       x[rd] = sext(M[x[rs1] + sext(offset)][7:0])
lbu      x[rd] = M[x[rs1] + sext(offset)][7:0]
lh       x[rd] = sext(M[x[rs1] + sext(offset)][15:0])
lhu      x[rd] = M[x[rs1] + sext(offset)][15:0]
lui      x[rd] = sext(immediate[31:12] << 12)
lw       x[rd] = sext(M[x[rs1] + sext(offset)][31:0])
mul      x[rd] = x[rs1] × x[rs2]
mulh     x[rd] = (x[rs1] s ×s x[rs2]) >>s XLEN
mulhsu   x[rd] = (x[rs1] s ×u x[rs2]) >>s XLEN
mulhu    x[rd] = (x[rs1] u ×u x[rs2]) >> u XLEN
or       x[rd] = x[rs1] | x[rs2]
ori      x[rd] = x[rs1] | sext(immediate)
sb       M[x[rs1] + sext(offset)] = x[rs2][7:0]
sh       M[x[rs1] + sext(offset)] = x[rs2][15:0]
sll      x[rd] = x[rs1] << x[rs2]
slli     x[rd] = x[rs1] << shamt
slt      x[rd] = x[rs1] <s x[rs2]
slti     x[rd] = x[rs1] <s sext(immediate)
sltiu    x[rd] = x[rs1] <u sext(immediate)
sltu     x[rd] = x[rs1] <u x[rs2]
sra      x[rd] = x[rs1] >>s x[rs2]
srai     x[rd] = x[rs1] >>s shamt
srl      x[rd] = x[rs1] >>u x[rs2]
srli     x[rd] = x[rs1] >>u shamt
sub      x[rd] = x[rs1] - x[rs2]
sw       M[x[rs1] + sext(offset)] = x[rs2][31:0]
xor      x[rd] = x[rs1] ˆ x[rs2]
xori     x[rd] = x[rs1] ˆ sext(immediate)
/-fence
/-fence,i
/-csrrw
/-csrrs
/-csrrc
/-csrrwi
/-csrrsi
/-csrrci

```

</pre>

</details>
<details>

<summary>地址分配</summary>

| 名称     | 起始地址    | 结束地址    | 大小 |
| -------- | ----------- | ----------- | ---- |
| 程序     | 0x0000 0000 | 0x---- ---- | NAN  |
| 内存     | 0x8000 0000 | 0x800F FFFF | 1M   |
| 终端内存 | 0x9000 0000 | 0x9000 FFFF | 64K  |
| 终端卷屏 | 0x9001 0000 | 0x9001 0007 | 4B   |

** 程序是独立的地址总线,和内存不互通.无大小限制

<pre>
</details>

