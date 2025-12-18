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
    ,input [2:0]  cmp_lsx


    ,output [31:0] pc_inc
    ,output [31:0] add_1_o
    ,output [31:0] add_2_o
    ,output [31:0] pc_mod_o
    ,output        cmp_o
);

    // 用于正常程序指针自增
    assign pc_inc = pc + (opcode_c_mode ? 32'h2 : 32'h4);
    // 第一个加法器
    assign add_1_o = add_1_a + add_1_b;
    // 第二个加法器
    assign add_2_o = add_2_a + add_2_b;
    // 对最低温置0
    assign pc_mod_o = pc_mod & ~32'b1;
    // 判断两个数,根据cmp_lsx比较,l==0:a==b,l==1:a<b. s==0:有符号比较,s==1:无符号比较,x=0不取反,x=1,取反
    assign eq_o = cmp_lsx[0] ^ (
        (~cmp_lsx[1])?(cmp_a == cmp_b) :
        (~cmp_lsx[2])?($signed(cmp_a)<$signed(cmp_b)):
        (cmp_a < cmp_b));
endmodule
