`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2014 09:50:10 PM
// Design Name: 
// Module Name: EPU
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


module EPU(
    input [511:0] sig,
    input [255:0] key,
    input [255:0] rhash,
    output ready,
    input valid,
    output result,
    input resetn,
    input axiclk,
    input modclk
    );

wire posrst;
assign posrst = !resetn;

reg rresult;
assign result = rresult;

reg modside_rresult;
reg modside_rresult_valid;

wire input_fifo_dout;
wire input_fifo_dout_val;
fifo_generator_0 inputfifo (
  .rst(posrst),        // input wire rst
  .wr_clk(axiclk),  // input wire wr_clk
  .rd_clk(modclk),  // input wire rd_clk
  .din(valid),        // input wire [0 : 0] din
  .wr_en(valid),    // input wire wr_en
  .rd_en(1'b1),    // input wire rd_en
  .dout(input_fifo_dout),      // output wire [0 : 0] dout
  .valid(input_fifo_dout_val)    // output wire valid
);

wire output_fifo_dout;
wire output_fifo_dout_val;
fifo_generator_0 outputfifo (
  .rst(posrst),        // input wire rst
  .wr_clk(modclk),  // input wire wr_clk
  .rd_clk(axiclk),  // input wire rd_clk
  .din(modside_rresult),        // input wire [0 : 0] din
  .wr_en(modside_rresult_valid),    // input wire wr_en
  .rd_en(1'b1),    // input wire rd_en
  .dout(output_fifo_dout),      // output wire [0 : 0] dout
  .valid(output_fifo_dout_val)    // output wire valid
);

//==== ALU arbitration



//==== ALU resources ====
//Multiplier
reg [319:0] mul_op_a;
reg [319:0] mul_op_b;
wire mul_valid;
wire [319:0] mul_res;
wire mul_done;
fe_mulx ML(
    .op_a(mul_op_a),
    .op_b(mul_op_b),
    .valid(mul_valid),
    .res(mul_res),
    .clk(modclk),
    .rst(resetn),
    .done(mul_done)
    );   
//Mul arbitration
wire [319:0] mul_op_a_gdsv;
wire [319:0] mul_op_b_gdsv;
wire mul_valid_gdsv;
wire [319:0] mul_op_a_gfnv;
wire [319:0] mul_op_b_gfnv;
wire mul_valid_gfnv;
assign mul_valid = mul_valid_gdsv | mul_valid_gfnv;
always @ (*)
begin
    if (mul_valid_gdsv)
        mul_op_a = mul_op_a_gdsv;
    else if (mul_valid_gfnv)
        mul_op_a = mul_op_a_gdsv;
end
always @ (*)
begin
    if (mul_valid_gdsv)
        mul_op_b = mul_op_b_gdsv;
    else if (mul_valid_gfnv)
        mul_op_b = mul_op_b_gdsv;
end

//Adder
reg [319:0] add_op_a;
reg [319:0] add_op_b;
reg [319:0] add_res;
always @ (*)
begin
    add_res = fe_add(add_op_a, add_op_b);
end
//Add arbitration
reg addsub_gdsv_valid;
reg addsub_gfnv_valid;
wire [319:0] add_op_a_gdsv;
wire [319:0] add_op_b_gdsv;
wire [319:0] add_op_a_gfnv;
wire [319:0] add_op_b_gfnv;
always @ (*)
begin
    if (addsub_gdsv_valid)
        add_op_a = add_op_a_gdsv;
    if (addsub_gfnv_valid)
        add_op_a = add_op_a_gfnv; 
end
always @ (*)
begin
    if (addsub_gdsv_valid)
        add_op_b = add_op_b_gdsv;
    if (addsub_gfnv_valid)
        add_op_b = add_op_b_gfnv; 
end

//Subtractor
reg [319:0] sub_op_a;
reg [319:0] sub_op_b;
reg [319:0] sub_res;
always @ (*)
begin
    sub_res = fe_sub(sub_op_a, sub_op_b);
end
//Subtract arbitration
wire [319:0] sub_op_a_gdsv;
wire [319:0] sub_op_b_gdsv;
wire [319:0] sub_op_a_gfnv;
wire [319:0] sub_op_b_gfnv;
always @ (*)
begin
    if (addsub_gdsv_valid)
        sub_op_a = sub_op_a_gdsv;
    if (addsub_gfnv_valid)
        sub_op_a = sub_op_a_gfnv; 
end
always @ (*)
begin
    if (addsub_gdsv_valid)
        sub_op_b = sub_op_b_gdsv;
    if (addsub_gfnv_valid)
        sub_op_b = sub_op_b_gfnv; 
end

//Real modules
reg [319:0] A_X;
reg [319:0] A_Y;
reg [319:0] A_Z;
reg [319:0] A_T;
reg gsdv_valid;

ge_double_scalarmult_vartime GDSV(  
    //Parameters
    .a(rhash),
    .b(sig[511:256]),
    .A_X(A_X),
    .A_Y(A_Y),
    .A_Z(A_Z),
    .A_T(A_T),
    .valid(gdsv_valid),
    
    //Resources
    .mul_op_a(mul_op_a_gsdv),
    .mul_op_b(mul_op_b_gsdv),
    .mul_valid(mul_valid_gsdv),
    .mul_res(mul_res),
    .mul_done(mul_done),
    
    .add_op_a(add_op_a_gsdv),
    .add_op_b(add_op_b_gsdv),
    .add_res(add_res),
    
    .sub_op_a(sub_op_a_gsdv),
    .sub_op_b(sub_op_b_gsdv),
    .sub_res(sub_res),
        
    //misc
    .clk(modclk),
    .rst(modrst)
    ); 
    
    
//=======================
/*
//do this in global switch
always @ (posedge modclk)
begin
    if (modside_rresult_valid == 1b'1)
        modside_rresult_valid <= 1'b0;
end
*/
         
         
reg [4:0] state;         
always @ (posedge modclk)
begin
    if (resetn == 1'b0)
    begin
        //reset
        state <= 5'b0;
    end else begin
        case (state)
        5'b0  : begin
                    if (input_fifo_dout_val == 1'b1)
                    begin
                        //trigger computation
                    end
                end
        default:
            state <= 0;
        endcase;
    end
end      
endmodule
