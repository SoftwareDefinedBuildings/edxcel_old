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

//==== ALU resources ====
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
