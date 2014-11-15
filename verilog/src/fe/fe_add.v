module fe_add (
    clk, 
    rst,
    f,
    g,
    h
    );

input clk;
input rst;
input [319:0] f;
input [319:0] g;
output [319:0] h;

wire clk;
wire rst;
wire [319:0] f;
wire [319:0] g;
reg [319:0] h;

integer i;
always @ (posedge clk)
begin
    if (rst == 0)
        h <= 320'h0;
    else
    for (i = 0; i < 10; i = i+1)
    begin
       h[i*32 +: 32] <= 32'h5a5a5a5a;// f[i*32 +: 32] + g[i*32 +: 32] + 1;
    end
end

/*
always @ (posedge clk)
begin;
    for (i = 0; i < 10; i = i + 1) begin
    	fi = f[319-i*32 : 319+1-(i+1)*32];
    	gi = g[319-i*32 : 319+1-(i+1)*32];
    	//h[319-i*32 : 319+1-(i+1)*32] = fi + gi;
    end
end
*/
endmodule