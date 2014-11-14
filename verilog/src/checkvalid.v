module checkvalid (
    input clk, rst,
    input valid,
    input [512:0] sk,
    input [256:0] msg,
    input [256:0] pk,
    output ready,
    output result
    );

wire clk, rst;
wire valid;
wire [512:0] sk;
wire [256:0] msg;
wire [256:0] pk;
reg ready;
reg result;

//TODO


endmodule