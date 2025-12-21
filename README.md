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
6.有cache
7.暂时不会实现特权模式

从PC出发,地址信号进入i_cache,映射物理内存到cache.
如果命中,返回opcode,如果没有命中,向内存控制器发送读命令.
内存控制器将地址转换成内存的本地地址,开始读写内存,如果收到wait信号,将信号发送到i_cache和c_cache

当cache收到wait信号,且自己正在访问内存,则将信号传递到core

核心只冻结PC,让t+1;PC=PC

当cache收到数据后,缓存到内部,并返回数据.

内存控制器同时有读写请求时,将优先处理当前任务,然后处理i_cache,最后处理d_cache

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
 cache()
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
-lb
-lh
-lw
-lbu
-lhu
-sb
-sh
-sw
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
-fence
-fence,i
-ecall
-ebreak
-csrrw
-csrrs
-csrrc
-csrrwi
-csrrsi
-csrrci
-mul
-mulh
-mulhsu
-mulhu
-div
-divu
-rem
-remu
</pre>

</details>
