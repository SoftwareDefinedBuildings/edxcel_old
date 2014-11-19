`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2014 06:39:35 PM
// Design Name: 
// Module Name: EPU_tb
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


module EPU_tb(

    );

reg [511:0] sign;
reg [255:0] key;
reg [255:0] rhash;
reg valid;
wire ready;
wire result;
reg resetn;
reg axiclk;
reg modclk;

 EPU epu(
    .sign(sign),
    .key(key),
    .rhash(rhash),
    .ready(ready),
    .valid(valid),
    .result(result),
    .resetn(resetn),
    .axiclk(axiclk),
    .modclk(modclk)
    );    
    

initial
begin
    resetn = 0;
    axiclk = 1;
    modclk = 1;
    valid = 0;
    #20
    resetn = 1;
    //Good signature
    sign = 512'h03e302d508532afeefa20360c8393e94aac9a0e12968ae80823d3ca54f9c89ff7db8b9c5a25d2cbc2dbe296513d5b7178409c49e22f9f0c3443da385325ea213;
    key = 256'he8325d4a6aba7d0a29a15ab0f70bc332fbce07aeb4d1c5ec4e54cee26a4e6380;
    rhash = 256'h03788934404d87830e38a9fdaa4e4261a2faf2a0d614c051d1dbb464561313e6;
    #20; //axi clock
    valid = 1;
    #20;
    valid = 0;
    
    while (ready == 1'b0)
    begin
        #10;
    end 
    
    
end
    
always
    #10 axiclk = !axiclk;
    
always
    #5 modclk = !modclk;
    
endmodule
