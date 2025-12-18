module alu(
    input [31:0] pc
    ,input        opcode_c_mode
    ,input [31:0] add_1_a
    ,input [31:0] add_1_b
    ,input [31:0] add_2_a
    ,input [31:0] add_2_b
    ,input [31:0] pc_mod
    ,input [31:0] cmp_a
    ,input [31:0] cmp_b
    ,input [31:0] sub_a
    ,input [31:0] sub_b
    ,input [31:0] slt_a
    ,input [31:0] slt_b
    ,input [31:0] sltu_a
    ,input [31:0] sltu_b
    ,input [31:0] xor_a
    ,input [31:0] xor_b
    ,input [31:0] or_a
    ,input [31:0] or_b
    ,input [31:0] and_a
    ,input [31:0] and_b
    ,input [31:0] sll_a
    ,input [4:0]  sll_shamt
    ,input [31:0] srl_a
    ,input [4:0]  srl_shamt
    ,input [31:0] sra_a
    ,input [4:0]  sra_shamt

    ,input [2:0]  cmp_lsx

    ,output [31:0] pc_inc
    ,output [31:0] add_1_o
    ,output [31:0] add_2_o
    ,output [31:0] pc_mod_o
    ,output [31:0] sub_o
    ,output [31:0] slt_o
    ,output [31:0] sltu_o
    ,output [31:0] xor_o
    ,output [31:0] or_o
    ,output [31:0] and_o
    ,output [31:0] sll_o
    ,output [31:0] srl_o
    ,output [31:0] sra_o

    ,output        cmp_o
);

// 用于正常程序指针自增
assign pc_inc = pc + (opcode_c_mode ? 32'h2 : 32'h4);

// 加法器
assign add_1_o = add_1_a + add_1_b;
assign add_2_o = add_2_a + add_2_b;

// 对最低位清零
assign pc_mod_o = pc_mod & ~32'b1;

// 减法
assign sub_o = sub_a - sub_b;

// SLT 有符号比较
assign slt_o = ($signed(slt_a) < $signed(slt_b)) ? 32'b1 : 32'b0;

// SLTU 无符号比较
assign sltu_o = (sltu_a < sltu_b) ? 32'b1 : 32'b0;

// XOR
assign xor_o = xor_a ^ xor_b;

// OR
assign or_o = or_a | or_b;

// AND
assign and_o = and_a & and_b;

// SLL (逻辑左移)
assign sll_o = sll_a << sll_shamt;

// SRL (逻辑右移)
assign srl_o = srl_a >> srl_shamt;

// SRA (算术右移)
assign sra_o = $signed(sra_a) >>> sra_shamt;

// 分支比较逻辑
assign cmp_o = cmp_lsx[0] ^ (
    (cmp_lsx[2] == 1'b0) ? (cmp_a == cmp_b) :
    (cmp_lsx[1] == 1'b0) ? ($signed(cmp_a) < $signed(cmp_b)) :
    (cmp_a < cmp_b)
);

endmodule
