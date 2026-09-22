module decode(
    input  logic [31:0] instr,
    output logic        c_op,
    output logic [31:0] instr32,
    output logic [4:0]  opcode,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7
);

    c_expand u_expand(
        .instr(instr),
        .is_c(c_op),
        .instr32(instr32)
    );

    idecode u_idecode(
        .instr32(instr32),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7)
    );

endmodule
