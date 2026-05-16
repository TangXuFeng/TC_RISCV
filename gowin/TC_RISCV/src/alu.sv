module alu(
    input  logic [31:0] op1,
    input  logic [31:0] op2,
    input  logic [4:0]  ctrl,
    output logic [31:0] result
);
    always_comb begin
        case (ctrl)
            5'b00000: result = op1 + op2; // ADD
            5'b00001: result = op1 - op2; // SUB
            5'b00010: result = op1 & op2; // AND
            5'b00011: result = op1 | op2; // OR
            5'b00100: result = op1 ^ op2; // XOR
            5'b00101: result = (op1 < op2) ? 32'h1 : 32'h0; // SLT
            default:   result = 32'h0;
        endcase
    end

endmodule