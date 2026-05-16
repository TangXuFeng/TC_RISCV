module soc(
    input   logic clk,
    input   logic rst_n,
    input   logic [31:0] rst_pc
);

core u_core(
    .clk(clk),
    .rst_n(rst_n),
    .rst_pc(rst_pc),
    .instr_addr(instr_addr),
    .instr(instr),
    .mem_ready(mem_ready)
);


endmodule