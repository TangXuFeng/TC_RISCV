module pc(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] rst_pc,

    input  logic        ce,
    output logic [31:0] pc
    input  logic [31:0] next_pc
);
    always_ff @(posedge clk,negedge rst_n) begin
        if (!rst_n)
            pc <= rst_pc;
        else if(ce)begin
            pc <= next_pc;
        end else begin
            pc <= pc;
        end
    end
endmodule
