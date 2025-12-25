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

lui
auipc
jal
jalr
beq
bne
blt
bge
bltu
bgeu
lb
lh
lw
lbu
lhu
sb
sh
sw
addi
slti
sltiu
xori
ori
andi
slli
srli
rsai
add
sub
sll
slt
sltu
xor
srl
sra
or
and
/-fence
/-fence,i
ecall
ebreak
/-csrrw
/-csrrs
/-csrrc
/-csrrwi
/-csrrsi
/-csrrci
?mul
?mulh
?mulhsu
?mulhu
?div
?divu
?rem
?remu
</pre>

</details>
<details>

<summary>地址分配</summary>

0x8000_0000 - 0x800F_0000
### 内存
<pre>
</details>

