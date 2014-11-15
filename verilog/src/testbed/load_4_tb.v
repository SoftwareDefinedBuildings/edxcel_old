module load_4_tb();

reg clk;
reg rst;
reg [7:0] s0;
reg [7:0] s1;
reg [7:0] s2;
reg [7:0] s3;
wire [63:0] result;

// Initialize all variables
initial begin        
  clk = 1;       // initial value of clock
  rst = 0;       // initial value of reset
  #5 rst = 1;    // Assert the reset
  #10 rst = 0;   // De-assert the reset
  #15 s0 = 8'b11110000;
  s1 = 8'b00101110;
  s2 = 8'b00100111;
  s3 = 8'b11000000;
  #100 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #5 clk = ~clk; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
load_4 load_4 (
clk,
rst,
s0,
s1,
s2,
s3,
result
);

endmodule