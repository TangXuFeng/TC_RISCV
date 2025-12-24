# 测试指令
.org 0

start:
    # -------------------------
    # R-type 指令
    # -------------------------
    add   x1, x0, x0        # x1 = 0
    addi  x1, x0, 5         # x1 = 5
    addi  x2, x0, 3         # x2 = 3

    add   x3, x1, x2        # x3 = 8
    sub   x4, x1, x2        # x4 = 2
    xor   x5, x1, x2        # x5 = 6
    or    x6, x1, x2        # x6 = 7
    and   x7, x1, x2        # x7 = 1

    sll   x8, x1, x2        # x8 = 5 << 3 = 40
    srl   x9, x1, x2        # x9 = 5 >> 3 = 0
    sra   x10, x1, x2       # x10 = 5 >> 3 = 0 (算术右移)

    slt   x11, x2, x1       # x11 = (3 < 5) = 1
    sltu  x12, x2, x1       # x12 = (3 < 5) = 1

    # -------------------------
    # I-type 算术
    # -------------------------
    addi  x13, x1, -2       # x13 = 3
    xori  x14, x1, 0xF      # x14 = 5 ^ 15 = 10
    ori   x15, x1, 0xF      # x15 = 5 | 15 = 15
    andi  x16, x1, 0xF      # x16 = 5 & 15 = 5
    slti  x17, x1, 10       # x17 = 1
    sltiu x18, x1, 10       # x18 = 1

    # -------------------------
    # Load / Store
    # -------------------------
    addi  x20, x0, 20      # x20 = 200 (内存地址)
    sw    x1, 0(x20)        # mem[200] = 5
    lw    x21, 0(x20)       # x21 = 5

    addi  x22, x0, 0x1234
    sw    x22, 4(x20)       # mem[204] = 0x1234
    lw    x23, 4(x20)       # x23 = 0x1234

    # -------------------------
    # Branch
    # -------------------------
    beq   x21, x1, br_eq_ok
    jal   x0, fail

br_eq_ok:
    bne   x21, x2, br_ne_ok
    jal   x0, fail

br_ne_ok:
    blt   x2, x1, br_lt_ok
    jal   x0, fail

br_lt_ok:
    bge   x1, x2, br_ge_ok
    jal   x0, fail

br_ge_ok:
    bltu  x2, x1, br_ltu_ok
    jal   x0, fail

br_ltu_ok:
    bgeu  x1, x2, br_geu_ok
    jal   x0, fail

br_geu_ok:

    # -------------------------
    # JAL / JALR
    # -------------------------
    jal   x24, jump_target   # x24 = return addr
    jal   x0, fail

jump_target:
    addi  x25, x24, 4        # 简单验证返回地址

    # jalr 测试
    addi  x26, x0, 0
    addi  x27, x0, 0
    addi  x28, x0, 0
    addi  x29, x0, 0

    addi  x30, x0, 0         # x30 = 0
    addi  x31, x0, 0         # x31 = 0

    addi  x5, x0, 4
    addi  x6, x0, 0
    jalr  x7, x6, jump2 - start  # 跳到 jump2

    jal   x0, fail

jump2:
    addi  x28, x0, 99        # 标记 jalr 成功

    # -------------------------
    # U-type
    # -------------------------
    lui   x10, 0x12345       # x10 = 0x12345000
    auipc x11, 0x10          # x11 = PC + 0x10000

    # -------------------------
    # 全部成功
    # -------------------------
success:
    jal x0, success

fail:
    jal x0, fail

