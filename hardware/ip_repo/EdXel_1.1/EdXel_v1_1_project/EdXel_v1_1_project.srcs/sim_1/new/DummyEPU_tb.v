`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2014 09:17:44 PM
// Design Name: 
// Module Name: DummyEPU_tb
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


module DummyEPU_tb(

    );
    reg clk, reset;
    reg [511:0] sig;
    reg [255:0] key;
    reg [255:0] m;
    reg valid;
    wire ready, result;
    DummyEPU EPU0 (
        .clk(clk),
        .resetn(reset),
        .signature(sig),
        .key(key),
        .message(m),
        .ready(ready),
        .result(result),
        .valid(valid)
    );
    
    initial
    begin
        $display("Starting");
        sig = 0;
        key = 0;
        m = 0;
        valid = 0;
        reset = 1;
        clk = 0;
        #10 reset = 0;
        #20 reset = 1;
            while(!ready);
            sig = 512'hDEAD;
            key = 256'hDE00;
            m = 256'h00AD;
        #10
            valid = 1;
        #10
            valid = 0;
        #50    
            //while(!ready);
            sig = 512'hDEAD;
            key = 256'hDE01;
            m = 256'h00AD;
        #10
            valid = 1;
        #10
            valid = 0;
            
    end
    
    initial begin
        $dumpfile("EPU.vcd");
        $dumpvars;
    end
    
    initial
    #300 $finish;
    
    always
        #5 clk = !clk;
        
endmodule
