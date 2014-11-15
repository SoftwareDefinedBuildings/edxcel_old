module load_3 (
    input clk, 
    input rst,
    input [7:0] s0,
    input [7:0] s1,
    input [7:0] s2,
    output [64:0] result
    );

wire clk;
wire rst;
wire [7:0] s0;
wire [7:0] s1;
wire [7:0] s2;
reg [64:0] result;


assign result = s0;


endmodule