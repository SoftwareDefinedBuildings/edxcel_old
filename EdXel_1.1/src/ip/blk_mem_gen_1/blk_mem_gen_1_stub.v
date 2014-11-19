// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3.1 (lin64) Build 1056140 Thu Oct 30 16:30:39 MDT 2014
// Date        : Mon Nov 17 18:02:55 2014
// Host        : bunker running 64-bit Ubuntu 14.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/immesys/w/FPGA/edxcel/EdXel_1.1/XPR/XPR.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_stub.v
// Design      : blk_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.3.1" *)
module blk_mem_gen_1(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[7:0],dina[7:0],douta[7:0]" */;
  input clka;
  input [0:0]wea;
  input [7:0]addra;
  input [7:0]dina;
  output [7:0]douta;
endmodule
