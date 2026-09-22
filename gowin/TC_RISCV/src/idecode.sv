module idecode(
    input  logic [31:0] instr32,
    output logic [4:0]  opcode,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7
);

    always_comb begin
        opcode = instr32[6:2];
        rd     = instr32[11:7];
        funct3 = instr32[14:12];
        rs1    = instr32[19:15];
        rs2    = instr32[24:20];
        funct7 = instr32[31:25];
    end

endmodule
