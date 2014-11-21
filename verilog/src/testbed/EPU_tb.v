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

`include "../fe/fe_common.v"
 
 
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
    .sig(sign),
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
    resetn = 1;
    axiclk = 1;
    modclk = 1;
    valid = 0;
    #100
    resetn = 0;
    #200;
    resetn = 1;
    #400
    //Good signature
    sign =  512'h0e722c657a46123fd9e362f592424e7922262adddec344dfcef6414133fc022b1715bd6c30b45f864fa49da3e3abf950cf2a61795c2e9e830b6a009effdffff2;
              //d37bd8a17a2cbd39b7171c20a048dae43fe426e86a9c87e74ca8473d968b0ca0
    key =   256'h973ddda3cda397385e46a3bc714e2f1572e3ea6eb09667e3604520ce9638bf06;
    rhash = 256'h070ff3673edd6d54f00317d8c7c68b4f8dfbcf400a61fae3c24bcbfda1fb914a;//03788934404d87830e38a9fdaa4e4261a2faf2a0d614c051d1dbb464561313e6;
    
        
   // a = 256'h070ff3673edd6d54f00317d8c7c68b4f8dfbcf400a61fae3c24bcbfda1fb914a;
   // b = 256'h0e722c657a46123fd9e362f592424e7922262adddec344dfcef6414133fc022b;
    #20; //axi clock
    valid = 1;
    #20;
    valid = 0;
    
    while (ready == 1'b0)
    begin
        #20;
    end 
    #40
    #20; //axi clock
    valid = 1;
    #20;
    valid = 0;
    
    
    
end
    
always
    #10 axiclk = !axiclk;
    
always
    #5 modclk = !modclk;
    
endmodule
