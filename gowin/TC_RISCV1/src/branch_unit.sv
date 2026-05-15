module branch_unit(
    input  logic branch,
    input  logic zero,
    input  logic [31:0] pc,
    input  logic [31:0] imm,
    output logic [31:0] next_pc
);
    assign next_pc = (branch && zero) ? pc + imm : pc + 4;
endmodule
