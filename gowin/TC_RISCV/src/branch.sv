module branch(
    input  logic [31:0] op1,
    input  logic [31:0] op2,
    input  logic [2:0]  comp_ctrl,
    output logic        res
);
    always_comb begin
        case (comp_ctrl)
            3'b000: res = (op1 == op2); // beq
            3'b001: res = (op1 != op2); // bne
            3'b100: res = ($signed(op1) < $signed(op2)); // blt
            3'b101: res = ($signed(op1) >= $signed(op2)); // bge
            3'b110: res = (op1 < op2); // bltu
            3'b111: res = (op1 >= op2); // bgeu
            default: res = 0;
        endcase
    end
endmodule