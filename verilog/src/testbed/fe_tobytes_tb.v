module fe_tobytes_tb();


reg [319:0] in;
wire [255:0] out;
reg clk;
reg rst;
reg valid;
wire done;


initial begin
  clk = 0;
  rst = 1;
  #10 rst = 0;
  #10 rst = 1;
  #20 in = 320'hff348211fef50137006a7aa9014d6f3f00fe8356fe5600a000dfcc46019732a5ff5135d600c4b8ae;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
      //4d20842f50137353d54a9ade7efe83559580281bf988ccb9952544d758c4b89b
      $display("out is %h", out);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

fe_tobytes fe_tobytes(
.in(in),
.out(out),
.clk(clk),
.rst(rst),
.valid(valid),
.done(done)
);

endmodule