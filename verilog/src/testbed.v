`include "checkvalid.v"
module testbed();
// Declare inputs as regs and outputs as wires
reg clk, rst;
reg valid;
reg [512:0] sk;
reg [256:0] msg;
reg [256:0] pk;
wire ready;
wire result;

// Initialize all variables
initial begin
  clk = 1;       // initial value of clock
  reset = 0;       // initial value of reset
  #5 reset = 1;    // Assert the reset
  #10 reset = 0;   // De-assert the reset
  #5 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #5 clk = ~clk; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
checkvalid checkvalid (
.clk(clk), 
.rst(rst),
.valid(valid),
.sk(sk),
.msg(msg),
.pk(pk),
.ready(ready),
.result(result)
);

endmodule