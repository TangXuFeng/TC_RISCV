//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.03 Education
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri May  8 11:39:31 2026

module Gowin_PADD (dout, a, b, ce, clk, reset);

output [17:0] dout;
input [17:0] a;
input [17:0] b;
input ce;
input clk;
input reset;

wire [17:0] so_w;
wire [17:0] sbo_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

PADD18 padd18_inst (
    .DOUT(dout),
    .SO(so_w),
    .SBO(sbo_w),
    .A(a),
    .B(b),
    .SI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .SBI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .CE(ce),
    .CLK(clk),
    .RESET(reset),
    .ASEL(gw_gnd)
);

defparam padd18_inst.AREG = 1'b1;
defparam padd18_inst.BREG = 1'b1;
defparam padd18_inst.ADD_SUB = 1'b0;
defparam padd18_inst.PADD_RESET_MODE = "SYNC";
defparam padd18_inst.BSEL_MODE = 1'b0;
defparam padd18_inst.SOREG = 1'b0;

endmodule //Gowin_PADD
