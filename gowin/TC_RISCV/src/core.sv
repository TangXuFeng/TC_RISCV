module core(
    input   logic clk,
    input   logic rst_n,
    input   logic [31:0] rst_pc,
    //取指令
    output  logic [31:0] instr_addr,
    input   logic [31:0] instr,
    //内存读写
    output  logic mem_addr,
    output  logic [3:0] mem_ctrl,
    output  logic [31:0] mem_wdata,
    input   logic [31:0] mem_rdata,
    //就绪=1
    input   logic ready

);

logic   [31:0] pc;//这一条PC的地址
logic   [31:0] next_pc;//下一条PC的地址
logic   [31:0] next_pc_1;//下一条写入PC的地址
logic   icache_ready;
logic   [31:0] ext_instr; 
logic   [31:0] imm;
logic   c_op;
logic   [4:0] rs1_idx;
logic   [4:0] rs2_idx;
logic   [4:0] rd_idx;
logic   [31:0] rs1_data;
logic   [31:0] rs2_data;
logic   [31:0] rd_data;

always_latch begin
next_pc = pc + c_op ? 2 : 4; //如果是压缩指令，PC加2，否则加4  
next_pc_1 = next_pc;
instr_addr=pc;
end


pc u_pc(
    .clk(clk),
    .rst_n(rst_n),
    .rst_pc(rst_pc),
    .ce(1'b1),
    .pc(pc),
    .next_pc(next_pc_1)
);


decode u_decode(
    .instr(instr),
    .c_op(c_op),
    .instr32(ext_instr),
    .opcode(opcode),
    .rs1(rs1_idx),
    .rs2(rs2_idx),
    .rd(rd_idx),
    .funct3(funct3),
    .funct7(funct7)
);

immgen u_immgen(
    .instr(ext_instr),
    .opcode(opcode),
    .imm(imm)
);

control u_control(
    .opcode(opcode),
    .reg_do_write_ctrl(reg_do_write_ctrl),
    .alu_op1_ctrl(alu_op1_ctrl),
    .alu_op2_ctrl(alu_op2_ctrl),
    .mem_ctrl(mem_ctrl),
    .mem_do_write_ctrl(mem_do_write_ctrl),
    .reg_wr_src_ctrl(reg_wr_src_ctrl),
    .comp_ctrl(comp_ctrl),
    .do_branch(do_branch),
    .do_jump(do_jump)
);

branch u_branch(
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .comp_ctrl(comp_ctrl),
    .do_branch(do_branch),
    .do_jump(do_jump),
    .branch_taken(branch_taken)
);

regfile u_regfile(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rs1_addr(rs1_idx),
    .rs2_addr(rs2_idx),
    .rd_addr(rd_idx),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

alu u_alu(
    .op1(rs1_data),
    .op2(rs2_data),
    .ctrl(alu_ctrl),
    .result(alu_result)
);

endmodule