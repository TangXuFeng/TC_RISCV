module riscv (clk,rst_n,done);

input clk,rst_n;
output done;
wire clk,rst_n,done;



core core_inst(instruction,pc,clk,rst_n);

endmodule
