module immgen(
    input  logic [31:0] instr,
    input  logic [4:0]  opcode,
    output logic [31:0] imm
);
    always_comb begin
        case (opcode)
            5'b11001: imm = {{20{instr[31]}}, instr[31:20]}; // I-type
            5'b01000: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
            5'b11000: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            default:    imm = 32'h0;
        endcase
    end
endmodule
