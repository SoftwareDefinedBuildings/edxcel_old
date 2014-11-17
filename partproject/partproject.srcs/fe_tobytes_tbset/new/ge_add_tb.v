module ge_add_tb;


reg [319:0] p_x, 
reg [319:0] p_y, 
reg [319:0] p_z, 
reg [319:0] p_t, 
reg [319:0] q_yplusx,
reg [319:0] q_yminusx,
reg [319:0] q_t2d,
reg [319:0] q_z,
wire [319:0] r_x,
wire [319:0] r_y,
wire [319:0] r_z,
wire [319:0] r_t,
reg clk,
reg rst,
reg valid,
wire done


initial begin
  clk = 0;
  rst = 1;
  req0 = 0;
  req1 = 0;
  #5 rst = 0;
  #15 rst = 1;
  #20 p_x = 320'hfee357b0007f52ebfe377ada0050d0460133cb41ff95f756011d7b40ff8cd6dffff6a71a00a2384e;
  p_y = 320'hfea097ea00e087db00624c9200971965ffa199b1ffb5525dfe3ff23f009dfcf2010c44b800577563;
  p_z = 320'hfe6e55e6ff657c15fe3ef28e00dfdbeffe7c6fbbff68221ffe75c13100551e6bffb4de9b005fae49;
  p_t = 320'hffdab706ff56ca33fe1fde2400ad90ef01e0d67aff8be8a8fe6ac8ca008772f0fe14ad4100cfa961;
  q_yplusx = 320'hffbcaf5f00f20b2efd5a3edaff514f9bfed39b5afee31a21fefb05d7fff31033019e1efbffc3571b;
  q_yminusx = 320'h036fe1b5000123640070048e00441801fd8b8db6ffe04875ff03721101558c7fff38924d0042f863;
  q_z = 320'h00000001000000000000000000000000000000000000000000000000000000000000000000000000;
  q_t2d = 320'hfe07d26d004e2f3600af59a6004b9cb4feb7698900fcfe75feded0e4ff93156500bd54900021897d;
  
end

always @ (done)
  //rX:025192580092303a027e424c014169a901cc4bb00006b28700515d30fe883853fece1c34fe6f9edd
  //rY:00937912008a833c002f2b8c00933789fe7596fa00ccfc83017c22d8ffb33141fe4e8786006d7d51
  //rZ:fcb1111afe3e4957fc4ba8e002b6e5c8fd2bf84aff2fbdd3fc53ad8900002b6401220b2e00b8d4f8
  //rT:fd08467eff57a6fdfcb0215800c889f4fcc5c6a2fe70caa9fd83573b01544e48fdb16f3e00c5e42c

  #10 $display("r_x is %h", r_x);
  $display("r_y is %h", r_y);
  $display("r_z is %h", r_z);
  $display("r_t is %h", r_t);
  #15 $finish;
end

always begin
 #5 clock = !clock;
end

ge_add ge_add(
p_x, 
p_y, 
p_z, 
p_t, 
q_yplusx,
q_yminusx,
q_t2d,
q_z,
r_x,
r_y,
r_z,
r_t,
input clk,
input rst,
input valid,
output done
);

endmodule
