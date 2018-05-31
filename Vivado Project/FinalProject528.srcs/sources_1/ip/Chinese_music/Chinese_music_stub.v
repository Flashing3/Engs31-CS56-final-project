// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3.1 (win64) Build 2035080 Fri Oct 20 14:20:01 MDT 2017
// Date        : Sat May 26 13:47:46 2018
// Host        : MECHA-7 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               O:/ENGS31/Demo/lab6/lab6.srcs/sources_1/ip/Chinese_music/Chinese_music_stub.v
// Design      : Chinese_music
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_0,Vivado 2017.3.1" *)
module Chinese_music(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[16:0],douta[15:0]" */;
  input clka;
  input ena;
  input [16:0]addra;
  output [15:0]douta;
endmodule
