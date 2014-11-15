module fe_add_tb();

reg clk;
reg rst;
reg [319:0] f;
reg [319:0] g;
wire [319:0] h;

// Initialize all variables
initial begin        
  clk = 1;       // initial value of clock
  rst = 0;       // initial value of reset
  #5 rst = 1;    // Assert the reset
  #10 rst = 0;   // De-assert the reset
  #15 f = 320'b0;
  g = 320'b1;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #5 clk = ~clk; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
fe_add fe_add (
clk,
rst,
f,
g,
h
);

endmodule