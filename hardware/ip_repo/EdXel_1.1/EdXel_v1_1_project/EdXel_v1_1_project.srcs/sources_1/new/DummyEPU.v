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

reg [511:0] iresult;    
reg rresult;
reg rready;

assign ready = rready;
assign result = rresult;

always @ (posedge clk)
if (resetn == 0) begin
    iresult <= 512'b0;
    rready <= 1'b1;
    rresult <= 1'b0;
end else if (valid == 1 && rready == 1) begin
    iresult <= signature;
    rready <= 0;
    rresult <= rresult;
end else if (rready == 0) begin
    rresult <= signature[7:0] == 8'h55;
    rready <= 1;
    iresult <= iresult;
end
    
endmodule
