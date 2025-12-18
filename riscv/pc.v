// 程序指针
module pc #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS=32'h0
)(
     input  [31:0] jump_pc
    ,input         j
    ,output [31:0] pc
    ,input         clk
    ,input         rst_n
);

// ========= PC 寄存器 =========
reg [31:0] pc_r;

// 异步低电平复位 + 时钟推进
always @(posedge clk or negedge rst_n) begin
if (rst_n == 1'b0) begin
    pc_r <= 32'h0000_0000;
end else begin
    pc_r <= next_pc;
end
end

assign pc = pc_r;

// ========= 下一条PC =========
wire [31:0] next_pc =
(j) ? jump_pc : (pc_r + 32'd4);

endmodule
