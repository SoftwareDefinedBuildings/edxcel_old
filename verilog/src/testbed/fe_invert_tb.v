module fe_invert_tb();


reg [319:0] z;
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
  #20 z = 320'h00053a81017f6f0affc217b7fe20238d008e7c68fe44054e0062a67b00a68f5600a2a82fffd1a58d;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
      // 00a7d731ff3e2b82ffb1b4c001737c3dff6b2a2801b99e9b00e91fa401bc825bff022266ff9caf02
      $display("out is %h", out);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

fe_invert fe_invert(
z,
out,
clk,
rst,
valid,
done
);

endmodule
