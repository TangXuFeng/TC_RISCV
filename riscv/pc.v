// 程序指针
module pc #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS = 32'h0
)(
    input         clk
    ,input         rst_n
    ,input  [31:0] pc_next
    ,output [31:0] pc
);

// ========= PC 寄存器 =========
reg [31:0] pc_r;

// 异步低电平复位 + 时钟推进
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
    pc_r <= RST_PC_ADDRESS;
end else begin
    pc_r <= pc_next;
end
end

assign pc      = pc_r;

endmodule
