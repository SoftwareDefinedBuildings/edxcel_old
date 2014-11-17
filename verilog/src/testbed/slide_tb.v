module slide_tb();

`include "../ge/slide.v"

reg [0:32*8-1] a;
reg signed [0:256*8-1] r;


// Initialize all variables
initial begin
  a = 256'h42e6b3da746f7982c72e3945ca2e987362ae2af25aa079470fd723b60d430c0a;
  #100 r = slide(a);
  #10000 $display("r is %h", r);
  #20000 $finish;      // Terminate simulation
end


endmodule