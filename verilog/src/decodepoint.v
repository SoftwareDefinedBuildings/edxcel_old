module decodepoint (
    input clk, 
    input rst,
    input [256:0] s,
    output [256:0] P,
    output on_curve
    );

wire clk;
wire rst;
wire [256:0] s;
reg [256:0] P;
reg on_curve;

assign on_curve: 

// function is_on_curve
function is_on_curve;
input a, b, c, d;
begin
  is_on_curve = ((a+b) + (c-d));
end
endfunction

//TODO


endmodule