module alu(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  ctrl,
    output logic [31:0] y,
    output logic        zero
);
    always_comb begin
        case (ctrl)
            3'b000: y = a + b;
            3'b001: y = a - b;
            3'b010: y = a & b;
            3'b011: y = a | b;
            default: y = 0;
        endcase
    end

    assign zero = (y == 0);
endmodule
