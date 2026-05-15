module immgen(
    input  logic [31:0] instr,
    output logic [31:0] imm
);
    always_comb begin
        case (instr[6:0])
            7'b0010011: imm = {{20{instr[31]}}, instr[31:20]}; // I-type
            7'b0100011: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
            7'b1100011: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            default:    imm = 32'h0;
        endcase
    end
endmodule
