module verify (
    input clk, 
    input rst,
    input valid,
    input [512:0] sig,
    input [256:0] msg,
    input [256:0] pk,
    output ready,
    output result
    );

wire clk;
wire rst;
wire valid;
wire [512:0] sig;
wire [256:0] msg;
wire [256:0] pk;
reg ready;
reg result;

//TODO


endmodule