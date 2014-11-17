// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3.1 (lin64) Build 1056140 Thu Oct 30 16:30:39 MDT 2014
// Date        : Sun Nov 16 21:39:38 2014
// Host        : bunker running 64-bit Ubuntu 14.04.1 LTS
// Command     : write_verilog -force -mode synth_stub /home/immesys/w/FPGA/edxcel/EdXel_1.1/src/add64/add64_stub.v
// Design      : add64
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_addsub_v12_0,Vivado 2014.3.1" *)
module add64(A, B, CLK, S)
/* synthesis syn_black_box black_box_pad_pin="A[63:0],B[63:0],CLK,S[63:0]" */;
  input [63:0]A;
  input [63:0]B;
  input CLK;
  output [63:0]S;
endmodule
