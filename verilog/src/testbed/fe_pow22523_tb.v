module fe_pow22523_tb();


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
  #20 z = 320'hff31ab2cfe935ee600563961019c1bd2006d0db7febc31a500bdd6daffd7a22400951b5bff7ccb67;
  
  valid = 1;
  #10 valid = 0;
end

always @ (done) begin
  if (done === 1'b1) begin
      // 0049fd2ffe92c0caff7a034e003fbc9000d7170cfecb467cff5d81fb004677270053346e01027c28
      $display("out is %h", out);
      $finish;
  end
end

always begin
 #5 clk = !clk;
end

fe_pow22523 fe_pow22523(
z,
out,
clk,
rst,
valid,
done
);

endmodule
