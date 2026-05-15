//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.03 Education
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri May  8 11:24:54 2026

module Gowin_RAM16S (dout, wre, ad, di, clk);

output [15:0] dout;
input wre;
input [4:0] ad;
input [15:0] di;
input clk;

wire ad4_inv;
wire lut_f_0;
wire lut_f_1;
wire [3:0] ram16s_inst_0_dout;
wire [7:4] ram16s_inst_1_dout;
wire [11:8] ram16s_inst_2_dout;
wire [15:12] ram16s_inst_3_dout;
wire [3:0] ram16s_inst_4_dout;
wire [7:4] ram16s_inst_5_dout;
wire [11:8] ram16s_inst_6_dout;
wire [15:12] ram16s_inst_7_dout;
wire gw_vcc;

assign gw_vcc = 1'b1;

INV inv_inst_0 (.I(ad[4]), .O(ad4_inv));

LUT4 lut_inst_0 (
  .F(lut_f_0),
  .I0(wre),
  .I1(ad4_inv),
  .I2(gw_vcc),
  .I3(gw_vcc)
);
defparam lut_inst_0.INIT = 16'h8000;
LUT4 lut_inst_1 (
  .F(lut_f_1),
  .I0(wre),
  .I1(ad[4]),
  .I2(gw_vcc),
  .I3(gw_vcc)
);
defparam lut_inst_1.INIT = 16'h8000;
RAM16S4 ram16s_inst_0 (
    .DO(ram16s_inst_0_dout[3:0]),
    .DI(di[3:0]),
    .AD(ad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16s_inst_0.INIT_0 = 16'h0000;
defparam ram16s_inst_0.INIT_1 = 16'h0000;
defparam ram16s_inst_0.INIT_2 = 16'h0000;
defparam ram16s_inst_0.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_1 (
    .DO(ram16s_inst_1_dout[7:4]),
    .DI(di[7:4]),
    .AD(ad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16s_inst_1.INIT_0 = 16'h0000;
defparam ram16s_inst_1.INIT_1 = 16'h0000;
defparam ram16s_inst_1.INIT_2 = 16'h0000;
defparam ram16s_inst_1.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_2 (
    .DO(ram16s_inst_2_dout[11:8]),
    .DI(di[11:8]),
    .AD(ad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16s_inst_2.INIT_0 = 16'h0000;
defparam ram16s_inst_2.INIT_1 = 16'h0000;
defparam ram16s_inst_2.INIT_2 = 16'h0000;
defparam ram16s_inst_2.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_3 (
    .DO(ram16s_inst_3_dout[15:12]),
    .DI(di[15:12]),
    .AD(ad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16s_inst_3.INIT_0 = 16'h0000;
defparam ram16s_inst_3.INIT_1 = 16'h0000;
defparam ram16s_inst_3.INIT_2 = 16'h0000;
defparam ram16s_inst_3.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_4 (
    .DO(ram16s_inst_4_dout[3:0]),
    .DI(di[3:0]),
    .AD(ad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16s_inst_4.INIT_0 = 16'h0000;
defparam ram16s_inst_4.INIT_1 = 16'h0000;
defparam ram16s_inst_4.INIT_2 = 16'h0000;
defparam ram16s_inst_4.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_5 (
    .DO(ram16s_inst_5_dout[7:4]),
    .DI(di[7:4]),
    .AD(ad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16s_inst_5.INIT_0 = 16'h0000;
defparam ram16s_inst_5.INIT_1 = 16'h0000;
defparam ram16s_inst_5.INIT_2 = 16'h0000;
defparam ram16s_inst_5.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_6 (
    .DO(ram16s_inst_6_dout[11:8]),
    .DI(di[11:8]),
    .AD(ad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16s_inst_6.INIT_0 = 16'h0000;
defparam ram16s_inst_6.INIT_1 = 16'h0000;
defparam ram16s_inst_6.INIT_2 = 16'h0000;
defparam ram16s_inst_6.INIT_3 = 16'h0000;

RAM16S4 ram16s_inst_7 (
    .DO(ram16s_inst_7_dout[15:12]),
    .DI(di[15:12]),
    .AD(ad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16s_inst_7.INIT_0 = 16'h0000;
defparam ram16s_inst_7.INIT_1 = 16'h0000;
defparam ram16s_inst_7.INIT_2 = 16'h0000;
defparam ram16s_inst_7.INIT_3 = 16'h0000;

MUX2 mux_inst_0 (
  .O(dout[0]),
  .I0(ram16s_inst_0_dout[0]),
  .I1(ram16s_inst_4_dout[0]),
  .S0(ad[4])
);
MUX2 mux_inst_1 (
  .O(dout[1]),
  .I0(ram16s_inst_0_dout[1]),
  .I1(ram16s_inst_4_dout[1]),
  .S0(ad[4])
);
MUX2 mux_inst_2 (
  .O(dout[2]),
  .I0(ram16s_inst_0_dout[2]),
  .I1(ram16s_inst_4_dout[2]),
  .S0(ad[4])
);
MUX2 mux_inst_3 (
  .O(dout[3]),
  .I0(ram16s_inst_0_dout[3]),
  .I1(ram16s_inst_4_dout[3]),
  .S0(ad[4])
);
MUX2 mux_inst_4 (
  .O(dout[4]),
  .I0(ram16s_inst_1_dout[4]),
  .I1(ram16s_inst_5_dout[4]),
  .S0(ad[4])
);
MUX2 mux_inst_5 (
  .O(dout[5]),
  .I0(ram16s_inst_1_dout[5]),
  .I1(ram16s_inst_5_dout[5]),
  .S0(ad[4])
);
MUX2 mux_inst_6 (
  .O(dout[6]),
  .I0(ram16s_inst_1_dout[6]),
  .I1(ram16s_inst_5_dout[6]),
  .S0(ad[4])
);
MUX2 mux_inst_7 (
  .O(dout[7]),
  .I0(ram16s_inst_1_dout[7]),
  .I1(ram16s_inst_5_dout[7]),
  .S0(ad[4])
);
MUX2 mux_inst_8 (
  .O(dout[8]),
  .I0(ram16s_inst_2_dout[8]),
  .I1(ram16s_inst_6_dout[8]),
  .S0(ad[4])
);
MUX2 mux_inst_9 (
  .O(dout[9]),
  .I0(ram16s_inst_2_dout[9]),
  .I1(ram16s_inst_6_dout[9]),
  .S0(ad[4])
);
MUX2 mux_inst_10 (
  .O(dout[10]),
  .I0(ram16s_inst_2_dout[10]),
  .I1(ram16s_inst_6_dout[10]),
  .S0(ad[4])
);
MUX2 mux_inst_11 (
  .O(dout[11]),
  .I0(ram16s_inst_2_dout[11]),
  .I1(ram16s_inst_6_dout[11]),
  .S0(ad[4])
);
MUX2 mux_inst_12 (
  .O(dout[12]),
  .I0(ram16s_inst_3_dout[12]),
  .I1(ram16s_inst_7_dout[12]),
  .S0(ad[4])
);
MUX2 mux_inst_13 (
  .O(dout[13]),
  .I0(ram16s_inst_3_dout[13]),
  .I1(ram16s_inst_7_dout[13]),
  .S0(ad[4])
);
MUX2 mux_inst_14 (
  .O(dout[14]),
  .I0(ram16s_inst_3_dout[14]),
  .I1(ram16s_inst_7_dout[14]),
  .S0(ad[4])
);
MUX2 mux_inst_15 (
  .O(dout[15]),
  .I0(ram16s_inst_3_dout[15]),
  .I1(ram16s_inst_7_dout[15]),
  .S0(ad[4])
);
endmodule //Gowin_RAM16S
