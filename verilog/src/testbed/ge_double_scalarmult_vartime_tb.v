`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2014 01:41:12 PM
// Design Name: 
// Module Name: ge_double_scalarmult_vartime_tb
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


module ge_double_scalarmult_vartime_tb(

    );
 
`include "../fe/fe_common.v"
 
reg rst;
reg clk;
       
wire [319:0] mul_op_a;
wire [319:0] mul_op_b;
wire mul_valid;
wire [319:0] mul_res;
wire mul_done;
fe_mulx ML(
    .op_a(mul_op_a),
    .op_b(mul_op_b),
    .valid(mul_valid),
    .res(mul_res),
    .clk(clk),
    .rst(rst),
    .done(mul_done)
    );   

wire [319:0] add_op_a;
wire [319:0] add_op_b;
reg [319:0] add_res;
always @ (*)
begin
    add_res = fe_add(add_op_a, add_op_b);
end 


wire [319:0] sub_op_a;
wire [319:0] sub_op_b;
reg [319:0] sub_res;
always @ (*)
begin
    sub_res = fe_sub(sub_op_a, sub_op_b);
end 
    
reg [255:0] a;
reg [319:0] A_X;
reg [319:0] A_Y;    
reg [319:0] A_Z;    
reg [319:0] A_T;
reg [255:0] b;
reg gdsv_valid;  


ge_double_scalarmult_vartime GDSV(
    
        //Parameters
        .a(a),
        .b(b),
        .A_X(A_X),
        .A_Y(A_Y),
        .A_Z(A_Z),
        .A_T(A_T),
        .valid(gdsv_valid),
        
        //Resources
        .mul_op_a(mul_op_a),
        .mul_op_b(mul_op_b),
        .mul_valid(mul_valid),
        .mul_res(mul_res),
        .mul_done(mul_done),
        
        .add_op_a(add_op_a),
        .add_op_b(add_op_b),
        .add_res(add_res),
        
        .sub_op_a(sub_op_a),
        .sub_op_b(sub_op_b),
        .sub_res(sub_res),
            
        //misc
        .clk(clk),
        .rst(rst)
        );  


integer i;        
initial
begin
    clk = 1;
    rst = 0;
    A_X = 320'hffc02f5c0132c657ff4ec1dafffbc9e3ff8168d600a406d2ff869bcdfe751d26007873e5fe2666d5;
    A_Y = 320'h000327bf006b58a400a44e59feff3bf4ff61b14bfe2f9488ffcab3cefee521b4007997490196488a;
    A_Z = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000001;
    A_T = 320'hff14b7700089ecef0018075300f26d5effe67e010038eab6ff520d3aff4bd386ff6a910300d5e7c2;
    a = 256'h0a0c430db623d70f4779a05af22aae6273982eca45392ec782796f74dab3e642;
    b = 256'h060b1fb93961303c02783284e4431827cf3bacf9feeb9730f038f26960d55138; //LSB on right

    gdsv_valid = 0;
    #10;
    rst = 1;
    #30;
    //a = 256'h42e6b3da746f7982c72e3945ca2e987362ae2af25aa079470fd723b60d430c0a;
    //b = 256'h3851d56069f238f03097ebfef9ac3bcf271843e4843278023c306139b91f0b06;
    gdsv_valid = 1;
    //R.X:          ff8c1eb0ff4b0322ff7b9797ffff83a700d59f7dfe6ea7b9004421d4feff541aff8a5d3f010bc5a4
    //R.Y:          ff7805a5000add29ff1409e3014f2a79000c9f0a0079546e008fb76c0006fb61ff54444301658970
    //R.Z:          00053a81017f6f0affc217b7fe20238d008e7c68fe44054e0062a67b00a68f5600a2a82fffd1a58d
    #10;
    #150000;
    $finish;
end            
        
 always
    #5 clk = !clk;
           
endmodule
