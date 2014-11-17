`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2014 09:02:42 PM
// Design Name: 
// Module Name: DummyEPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Dummy EPU. if signature minus key equals message, it is valid, otherwise invalid

module DummyEPU(
    input [511:0] signature,
    input [255:0] key,
    input [255:0] message,
    output ready,
    input valid,
    output result,
    input resetn,
    input clk
    );
  
reg rresult;
reg rready;
assign ready = rready;
assign result = rresult;

wire [319:0] mula;
wire [319:0] mulb;
wire [319:0] mulresult;
reg mulvalid;
assign mula = stim;
assign mulb = 320'hff480db4fee2b700ffce7199ffa03cbcff79e8980001c029006a0a0fff156ebd00d37285ff5978b6;
wire muldone;

fe_mulx MULX(
    .op_a(mula),
    .op_b(mulb),
    .valid(mulvalid),
    .res(mulresult),
    .done(muldone),
    .rst(resetn),
    .clk(clk)
    );

    
reg [319:0] stim;

always @(*)
begin
    stim = {312'hff094481feac78b7ff2a6f1601e37d7bff2ec787fe653696ff7924bdfeaeb398fff6dbdd0101d4, key[7:0]};
end

always @ (posedge clk)
if (resetn == 0) begin
    rready <= 1'b1;
    rresult <= 1'b0;
    mulvalid <= 1'b0;
end else if (valid == 1 && rready == 1) begin
    rready <= 0;
    rresult <= 0;
    mulvalid <= 1'b1;
end else if (muldone == 1'b1) begin
    rresult <= mulresult == 320'h00ff5ebfed0160c3ca00507861002d4563001a575f01b971d5ffba2a9fff1efb61ff953889ffbad8;
    rready <= 1;
    mulvalid <= 1'b0;
end
    
endmodule
