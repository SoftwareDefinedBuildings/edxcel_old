`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2014 10:04:41 PM
// Design Name: 
// Module Name: ge_double_scalarmult_vartime
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


module ge_double_scalarmult_vartime(

    //Parameters
    input [255:0] a,
    input [319:0] A_x,
    input [319:0] A_y,
    input [319:0] A_z,
    input [319:0] A_t,
    input [255:0] b,
    
    //Resources
    output [319:0] mult_op_a,
    output [319:0] mult_op_b,
    output mult_valid,
    input [319:0] mult_res,
    input mult_done
    
    
    );
    
    
endmodule
