module ge_frombytes_negate_vartime_tb();

`include "../fe/fe_common.v"

reg [255:0] s;
wire [319:0] h_x;
wire [319:0] h_y;
wire [319:0] h_z;
wire [319:0] h_t;
wire error;
reg clk;
reg rst;
reg valid;
wire done;

wire [319:0] mul_in1;
wire [319:0] mul_in2;
wire mul_valid;
wire [319:0] mul_res;
wire mul_done;

fe_mulx ML(
   .op_a(mul_in1),
   .op_b(mul_in2),
   .valid(mul_valid),
   .res(mul_res),
   .clk(clk),
   .rst(rst),
   .done(mul_done)
   );
   
//wire [319:0] mul_in1_gfnv;
//wire [319:0] mul_in2_gfnv;
//wire mul_valid_gfnv;

wire [319:0] add_in1;
wire [319:0] add_in2;
reg [319:0] add_res;

wire [319:0] sub_in1;
wire [319:0] sub_in2;
reg [319:0] sub_res;

ge_frombytes_negate_vartime ge_frombytes_negate_vartime(
   .s(s),
   .h_x(h_x),
   .h_y(h_y),
   .h_z(h_z),
   .h_t(h_t),
   .error(error),
   .clk(clk),
   .rst(rst),
   .valid(valid),
   .done(done),
   
       //Resources
   .mul_op_a(mul_in1),
   .mul_op_b(mul_in2),
   .mul_valid(mul_valid),
   .mul_res(mul_res),
   .mul_done(mul_done),
       
   .add_op_a(add_in1),
   .add_op_b(add_in2),
   .add_res(add_res),
       
   .sub_op_a(sub_in1),
   .sub_op_b(sub_in2),
   .sub_res(sub_res)
   );


always @ (*)
begin
    add_res = fe_add(add_in1, add_in2);
end 


always @ (*)
begin
    sub_res = fe_sub(sub_in1, sub_in2);
end 


initial begin
  clk = 1;
  rst = 1;
  valid = 0;
  #10 rst = 0;
  #10 rst = 1;
  #20 s = 320'h80c9efc6b58a452272c5fe77e761b14a8be521f95679b7290da1e65d2596488a;
  
  valid = 1;
  #10 valid = 0;
  while (done == 1'b0) begin
    #10;
  end
  #30;
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
//  A.X: ffc02f5c0132c657ff4ec1dafffbc9e3ff8168d600a406d2ff869bcdfe751d26007873e5fe2666d5
//  A.Y: 000327bf006b58a400a44e59feff3bf4ff61b14bfe2f9488ffcab3cefee521b4007997490196488a
//  A.Z: 00000000000000000000000000000000000000000000000000000000000000000000000000000001
//  A.T: ff14b7700089ecef0018075300f26d5effe67e010038eab6ff520d3aff4bd386ff6a910300d5e7c2
      $display("h.X is %h", h_x);
      $display("h.Y is %h", h_y);
      $display("h.Z is %h", h_z);
      $display("h.T is %h", h_t);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end





   
   


endmodule
