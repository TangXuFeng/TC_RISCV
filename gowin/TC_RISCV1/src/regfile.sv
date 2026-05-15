module regfile(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        we,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] wdata,
    output logic [31:0] r1,
    output logic [31:0] r2
);
    logic [31:0] regs [0:31];

    assign r1 = regs[rs1];
    assign r2 = regs[rs2];

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)begin
            for (integer i=0;i<32;i=i+1 ) begin
                regs[i] <= 32'h0;
            end
        end
        else if (we && rd != 0)begin
            regs[rd] <= wdata;
        end
    end
endmodule
