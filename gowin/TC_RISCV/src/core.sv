module core(
    input   logic clk,
    input   logic rst_n,
    input   logic [31:0] rst_pc

);

logic   [31:0] pc;//这一条PC的地址
logic   [31:0] next_pc;//下一条PC的地址
logic   [31:0] next_pc_1;//下一条写入PC的地址
logic   icache_ready;
logic   [31:0] instr;
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
end


pc u_pc(
    .clk(clk),
    .rst_n(rst_n),
    .rst_pc(rst_pc),
    .ce(1'b1),
    .pc(pc),
    .next_pc(next_pc_1)
)

icache u_icache(
    .clk(clk),
    .rst_n(rst_n),
    .addr(pc),
    .ready(icache_ready),
    .instr(instr),
    .mem_rdata(),
    .mem_ready(),
    .mem_read(),
    .mem_addr(),
    .direct_mode(1'b0)
);

decode u_decode(
    .instr(instr),
    .c_op(c_op),
    .instr32(ext_instr),
    .opcode(),
    .rs1(rs1_idx),
    .rs2(rs2_idx),
    .rd(rd_idx),
    .funct3(),
    .funct7()
);

immgen u_immgen(
    .instr(ext_instr),
    .imm(imm)
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

endmodule