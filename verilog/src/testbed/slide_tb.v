module slide_tb();

reg [0:32*8-1] a;
reg clk;
reg rst;
reg valid;
wire signed [0:256*8-1] r;
wire done;


initial begin
  clk = 0;
  rst = 1;
  #10 rst = 0;
  #10 rst = 1;
  #20 a = 320'h42e6b3da746f7982c72e3945ca2e987362ae2af25aa079470fd723b60d430c0a;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
      $display("r is %h", r);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

slide slide(
clk,
rst,
valid,
a,
r,
done
);

endmodule