module ge_add_tb();


reg [319:0] p_x;
reg [319:0] p_y; 
reg [319:0] p_z; 
reg [319:0] p_t; 
reg [319:0] q_yplusx;
reg [319:0] q_yminusx;
reg [319:0] q_z;
reg [319:0] q_t2d;
wire [319:0] r_x;
wire [319:0] r_y;
wire [319:0] r_z;
wire [319:0] r_t;
reg clk;
reg rst;
reg valid;
wire done;


initial begin
  clk = 0;
  rst = 1;
  #10 rst = 0;
  #10 rst = 1;
  #20 p_x = 320'h00a2384efff6a71aff8cd6df011d7b40ff95f7560133cb410050d046fe377ada007f52ebfee357b0;
  p_y = 320'h00577563010c44b8009dfcf2fe3ff23fffb5525dffa199b10097196500624c9200e087dbfea097ea;
  p_z = 320'h005fae49ffb4de9b00551e6bfe75c131ff68221ffe7c6fbb00dfdbeffe3ef28eff657c15fe6e55e6;
  p_t = 320'h00cfa961fe14ad41008772f0fe6ac8caff8be8a801e0d67a00ad90effe1fde24ff56ca33ffdab706;
  q_yplusx = 320'hffc3571b019e1efbfff31033fefb05d7fee31a21fed39b5aff514f9bfd5a3eda00f20b2effbcaf5f;
  q_yminusx = 320'h0042f863ff38924d01558c7fff037211ffe04875fd8b8db6004418010070048e00012364036fe1b5;
  q_z = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000001;
  q_t2d = 320'h0021897d00bd5490ff931565feded0e400fcfe75feb76989004b9cb400af59a6004e2f36fe07d26d;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
//rX:       fe6f9eddfece1c34fe88385300515d300006b28701cc4bb0014169a9027e424c0092303a02519258
//rY:       006d7d51fe4e8786ffb33141017c22d800ccfc83fe7596fa00933789002f2b8c008a833c00937912
//rZ:       00b8d4f801220b2e00002b64fc53ad89ff2fbdd3fd2bf84a02b6e5c8fc4ba8e0fe3e4957fcb1111a
//rT:       00c5e42cfdb16f3e01544e48fd83573bfe70caa9fcc5c6a200c889f4fcb02158ff57a6fdfd08467e

  if (done === 1'b1) begin
      $display("r_x is %h", r_x);
      $display("r_y is %h", r_y);
      $display("r_z is %h", r_z);
      $display("r_t is %h", r_t);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

ge_add ge_add(
p_x, 
p_y, 
p_z, 
p_t, 
q_yplusx,
q_yminusx,
q_z,
q_t2d,
r_x,
r_y,
r_z,
r_t,
clk,
rst,
valid,
done
);

endmodule
