module ge_frombytes_negate_vartime_tb();


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


initial begin
  clk = 0;
  rst = 1;
  #10 rst = 0;
  #10 rst = 1;
  #20 s = 320'h80c9efc6b58a452272c5fe77e761b14a8be521f95679b7290da1e65d2596488a;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
//      A.X: ffc02f5c0132c657ff4ec1dafffbc9e3ff8168d600a406d2ff869bcdfe751d26007873e5fe2666d5
//      A.Y: 000327bf006b58a400a44e59feff3bf4ff61b14bfe2f9488ffcab3cefee521b4007997490196488a
//      A.Z: 00000000000000000000000000000000000000000000000000000000000000000000000000000001
//      A.T: ff14b7700089ecef0018075300f26d5effe67e010038eab6ff520d3aff4bd386ff6a910300d5e7c2
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

ge_frombytes_negate_vartime ge_frombytes_negate_vartime(
s,
h_x,
h_y,
h_z,
h_t,
error,
clk,
rst,
valid,
done
);

endmodule
