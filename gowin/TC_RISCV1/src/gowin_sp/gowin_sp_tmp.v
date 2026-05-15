//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri May  8 14:24:37 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_SP your_instance_name(
        .dout(dout), //output [0:0] dout
        .clk(clk), //input clk
        .oce(oce), //input oce
        .ce(ce), //input ce
        .reset(reset), //input reset
        .wre(wre), //input wre
        .ad(ad), //input [0:0] ad
        .din(din) //input [0:0] din
    );

//--------Copy end-------------------
