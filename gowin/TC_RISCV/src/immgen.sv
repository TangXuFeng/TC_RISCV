module imm(
    input  logic [31:0] instr,
    input  logic [4:0]  opcode,
    output logic [31:0] imm
);

`include "defender.vh"
    logic [31:0] imm_r = 32'b0;
    logic [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    logic [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    logic [31:0] imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    logic [31:0] imm_u = {instr[31:12], 12'b0};
    logic [31:0] imm_j = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

    always_comb begin
        case (opcode)
            `OPCODE_JALR:   imm = imm_i; // I-type
            `OPCODE_STORE:  imm = imm_s; // S-type
            `OPCODE_BRANCH: imm = imm_b; // B-type
            default:        imm = 32'h0;
        endcase
    end
endmoduleye
 