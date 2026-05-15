//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri May  8 11:24:54 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_RAM16S your_instance_name(
        .dout(dout), //output [15:0] dout
        .wre(wre), //input wre
        .ad(ad), //input [4:0] ad
        .di(di), //input [15:0] di
        .clk(clk) //input clk
    );

//--------Copy end-------------------
