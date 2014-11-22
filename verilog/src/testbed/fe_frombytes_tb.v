module fe_frombytes_tb();


reg [255:0] in;
wire [319:0] out;
reg clk;
reg rst;
reg valid;
wire done;


initial begin
  clk = 0;
  rst = 1;
  #10 rst = 0;
  #10 rst = 1;
  #20 in = 255'h5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
      //fe5a5a6d 00969697 ff4b4b4b 00d2d2d3 01696969 005a5a5a 012d2d2d ff4b4b4b 01a5a5a6 ff696969
      $display("out is %h", out);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

fe_frombytes fe_frombytes(
.in(in),
.out(out),
.clk(clk),
.rst(rst),
.valid(valid),
.done(done)
);

endmodule