// 指令解码器
module instruction_decoder(
    input  [31:0] instruction
    ,output [17:0] state
    ,output [6:0]  opcode
    ,output [4:0]  rd
    ,output [2:0]  funct3
    ,output [4:0]  rs1_address
    ,output [4:0]  rs2_address
    ,output [6:0]  funct7
    ,output [31:0] immediate
);

    //判断是不是压缩指令,不处理
    wire op_c = (instruction[1:0]==2'b11)?1'b0:1'b1;

    //判断指令类型
    wire op_u_lui = (instruction[6:2]==5'b01101)?1'b1:1'b0;
    wire op_u_auipc =  (instruction[6:2]==5'b00101)?1'b1:1'b0;
    wire op_j_jal =  (instruction[6:2]==5'b11011)?1'b1:1'b0;
    wire op_i_jalr =  (instruction[6:2]==5'b11001)?1'b1:1'b0;
    wire op_b_b =  (instruction[6:2]==5'b11000)?1'b1:1'b0;
    wire op_i_load =  (instruction[6:2]==5'b00000)?1'b1:1'b0;
    wire op_s_store =  (instruction[6:2]==5'b01000)?1'b1:1'b0;
    wire op_i_alu =  (instruction[6:2]==5'b00100)?1'b1:1'b0;
    wire op_r_alu =  (instruction[6:2]==5'b01100)?1'b1:1'b0;
    wire op_i_fence =  (instruction[6:2]==5'b00011)?1'b1:1'b0;
    wire op_i_csr =  (instruction[6:2]==5'b11100)?1'b1:1'b0;

    wire op_r = op_r_alu;
    wire op_i = op_i_alu | op_i_csr | op_i_fence | op_i_jalr | op_i_load;
    wire op_s = op_s_store;
    wire op_b = op_b_b;
    wire op_u = op_u_auipc | op_u_lui;
    wire op_j = op_j_jal;

    // 基本字段
    assign state  = {op_c,op_u_lui,op_u_auipc,op_j_jal,op_i_jalr,op_b,op_i_load,
        op_s_store,op_i_alu,op_r_alu,op_i_fence,op_i_csr,op_r,op_i,op_s,op_b,op_u,op_j
    };

    assign opcode   = instruction[6:0];
    assign rd       = (op_r | op_i | op_u | op_j) ? instruction[11:7] : 5'b0;
    assign funct3   = (op_r | op_i | op_s | op_b) ? instruction[14:12] : 3'b0;
    assign rs1_address  = (op_r | op_i | op_s | op_b) ? instruction[19:15] : 5'b0;
    assign rs2_address  = (op_r | op_s | op_b) ? instruction[24:20] : 5'b0;
    assign funct7   = (op_r)?instruction[31:25]:7'b0;
    assign immediate    =
        op_r ? 32'b0 :
        op_i ? {{20{instruction[31]}}, instruction[31:20]} :
        op_s ? {{20{instruction[31]}}, instruction[31:25], instruction[11:7]} :
        op_b ? {{19{instruction[31]}}, instruction[31], instruction[7],
            instruction[30:25], instruction[11:8], 1'b0} :
        op_u ? {instruction[31:12], 12'b0} :
        op_j ? {{12{instruction[31]}}, instruction[19:12], instruction[20],
        instruction[30:25], instruction[24:21], 1'b0} : 32'b0;


endmodule
