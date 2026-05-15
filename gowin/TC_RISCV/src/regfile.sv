module regfile(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
    logic [31:0] regs [0:31];

    assign rs1_data = regs[rs1_addr];
    assign rs2_data = regs[rs2_addr];

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)begin
            for (integer i=0;i<32;i=i+1 ) begin
                regs[i] <= 32'h0;
            end
        end
        else if (wr_en && rd_addr != 0)begin
            regs[rd_addr] <= rd_data;
        end
    end
endmodule
