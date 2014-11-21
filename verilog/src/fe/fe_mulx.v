`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2014 07:51:19 PM
// Design Name: 
// Module Name: fe_mulx
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


module fe_mulx(
    input wire [319:0] op_a,
    input wire [319:0] op_b,
    input wire valid,
    output wire [319:0] res,
    input wire clk,
    input wire rst,
    output wire done
    );

// *19 multipliers, 1 pipeline stage
reg  signed [31:0] mul19_a_in;
wire signed [31:0] mul19_a_out;    
mult19 mul_19_a (
      .CLK(clk),  // input wire CLK
      .A(mul19_a_in),      // input wire [31 : 0] A
      .P(mul19_a_out)      // output wire [36 : 0] P
    );
reg  signed [31:0] mul19_b_in;
wire signed [31:0] mul19_b_out; 
mult19 mul_19_b (
          .CLK(clk),  // input wire CLK
          .A(mul19_b_in),      // input wire [31 : 0] A
          .P(mul19_b_out)      // output wire [36 : 0] P
        );
            
// 32*64 multipliers, 4 pipeline stages
reg signed [31:0] mul_a_in32;
reg signed [63:0] mul_a_in64;
wire signed [63:0] mul_a_out;
mult32x64 mul_a (
  .CLK(clk),  // input wire CLK
  .A(mul_a_in32),      // input wire [31 : 0] A
  .B(mul_a_in64),      // input wire [63 : 0] B
  .P(mul_a_out)      // output wire [95 : 0] P
);

reg signed [31:0] mul_b_in32;
reg signed [63:0] mul_b_in64;
wire signed [63:0] mul_b_out;
mult32x64 mul_b (
  .CLK(clk),  // input wire CLK
  .A(mul_b_in32),      // input wire [31 : 0] A
  .B(mul_b_in64),      // input wire [63 : 0] B
  .P(mul_b_out)      // output wire [95 : 0] P
);   

reg signed [31:0] mul_c_in32;
reg signed [63:0] mul_c_in64;
wire signed [63:0] mul_c_out;
mult32x64 mul_c (
  .CLK(clk),  // input wire CLK
  .A(mul_c_in32),      // input wire [31 : 0] A
  .B(mul_c_in64),      // input wire [63 : 0] B
  .P(mul_c_out)      // output wire [95 : 0] P
);    

reg signed [31:0] mul_d_in32;
reg signed [63:0] mul_d_in64;
wire signed [63:0] mul_d_out;
mult32x64 mul_d (
  .CLK(clk),  // input wire CLK
  .A(mul_d_in32),      // input wire [31 : 0] A
  .B(mul_d_in64),      // input wire [63 : 0] B
  .P(mul_d_out)      // output wire [95 : 0] P
);     

// 64+64 adders, 2 pipeline stages
reg signed [63:0] add_a_in1;
reg signed [63:0] add_a_in2;
wire signed [63:0] add_a_out;
add64 add_a (
  .A(add_a_in1),      // input wire [63 : 0] A
  .B(add_a_in2),      // input wire [63 : 0] B
  .CLK(clk),  // input wire CLK
  .S(add_a_out)      // output wire [63 : 0] S
);   
reg signed [63:0] add_b_in1;
reg signed [63:0] add_b_in2;
wire signed [63:0] add_b_out;
add64 add_b (
  .A(add_b_in1),      // input wire [63 : 0] A
  .B(add_b_in2),      // input wire [63 : 0] B
  .CLK(clk),  // input wire CLK
  .S(add_b_out)      // output wire [63 : 0] S
);        
reg signed [63:0] add_c_in1;
reg signed [63:0] add_c_in2;
wire signed [63:0] add_c_out;
add64 add_c (
  .A(add_c_in1),      // input wire [63 : 0] A
  .B(add_c_in2),      // input wire [63 : 0] B
  .CLK(clk),  // input wire CLK
  .S(add_c_out)      // output wire [63 : 0] S
);        
reg signed [63:0] add_d_in1;
reg signed [63:0] add_d_in2;
wire signed [63:0] add_d_out;
add64 add_d (
  .A(add_d_in1),      // input wire [63 : 0] A
  .B(add_d_in2),      // input wire [63 : 0] B
  .CLK(clk),  // input wire CLK
  .S(add_d_out)      // output wire [63 : 0] S
);            

reg [33:0] cycle;

reg signed [31:0] g1_19;
reg signed [31:0] g2_19;
reg signed [31:0] g3_19;
reg signed [31:0] g4_19;
reg signed [31:0] g5_19;
reg signed [31:0] g6_19;
reg signed [31:0] g7_19;
reg signed [31:0] g8_19;
reg signed [31:0] g9_19;

reg signed [63:0] f0g0   ;    
reg signed [63:0] f0g1   ;    
reg signed [63:0] f0g2   ;    
reg signed [63:0] f0g3   ;    
reg signed [63:0] f0g4   ;    
reg signed [63:0] f0g5   ;    
reg signed [63:0] f0g6   ;    
reg signed [63:0] f0g7   ;    
reg signed [63:0] f0g8   ;    
reg signed [63:0] f0g9   ;    
reg signed [63:0] f1g0   ;    
reg signed [63:0] f1g1_2 ; 
reg signed [63:0] f1g2   ;    
reg signed [63:0] f1g3_2 ;  
reg signed [63:0] f1g4   ;    
reg signed [63:0] f1g5_2 ;  
reg signed [63:0] f1g6   ;    
reg signed [63:0] f1g7_2 ; 
reg signed [63:0] f1g8   ;    
reg signed [63:0] f1g9_38; 
reg signed [63:0] f2g0   ;    
reg signed [63:0] f2g1   ;    
reg signed [63:0] f2g2   ;    
reg signed [63:0] f2g3   ;    
reg signed [63:0] f2g4   ;    
reg signed [63:0] f2g5   ;    
reg signed [63:0] f2g6   ;    
reg signed [63:0] f2g7   ;    
reg signed [63:0] f2g8_19; 
reg signed [63:0] f2g9_19; 
reg signed [63:0] f3g0   ;    
reg signed [63:0] f3g1_2;  
reg signed [63:0] f3g2   ;    
reg signed [63:0] f3g3_2 ;  
reg signed [63:0] f3g4   ;    
reg signed [63:0] f3g5_2 ;  
reg signed [63:0] f3g6   ;    
reg signed [63:0] f3g7_38; 
reg signed [63:0] f3g8_19; 
reg signed [63:0] f3g9_38; 
reg signed [63:0] f4g0   ; 
reg signed [63:0] f4g1   ; 
reg signed [63:0] f4g2   ; 
reg signed [63:0] f4g3   ; 
reg signed [63:0] f4g4   ; 
reg signed [63:0] f4g5   ; 
reg signed [63:0] f4g6_19; 
reg signed [63:0] f4g7_19; 
reg signed [63:0] f4g8_19; 
reg signed [63:0] f4g9_19; 
reg signed [63:0] f5g0   ; 
reg signed [63:0] f5g1_2 ; 
reg signed [63:0] f5g2   ; 
reg signed [63:0] f5g3_2 ; 
reg signed [63:0] f5g4   ; 
reg signed [63:0] f5g5_38; 
reg signed [63:0] f5g6_19; 
reg signed [63:0] f5g7_38; 
reg signed [63:0] f5g8_19; 
reg signed [63:0] f5g9_38; 
reg signed [63:0] f6g0   ; 
reg signed [63:0] f6g1   ; 
reg signed [63:0] f6g2   ; 
reg signed [63:0] f6g3   ; 
reg signed [63:0] f6g4_19; 
reg signed [63:0] f6g5_19; 
reg signed [63:0] f6g6_19; 
reg signed [63:0] f6g7_19; 
reg signed [63:0] f6g8_19; 
reg signed [63:0] f6g9_19; 
reg signed [63:0] f7g0   ; 
reg signed [63:0] f7g1_2 ; 
reg signed [63:0] f7g2   ; 
reg signed [63:0] f7g3_38; 
reg signed [63:0] f7g4_19; 
reg signed [63:0] f7g5_38; 
reg signed [63:0] f7g6_19; 
reg signed [63:0] f7g7_38; 
reg signed [63:0] f7g8_19; 
reg signed [63:0] f7g9_38; 
reg signed [63:0] f8g0   ; 
reg signed [63:0] f8g1   ; 
reg signed [63:0] f8g2_19; 
reg signed [63:0] f8g3_19; 
reg signed [63:0] f8g4_19; 
reg signed [63:0] f8g5_19; 
reg signed [63:0] f8g6_19; 
reg signed [63:0] f8g7_19; 
reg signed [63:0] f8g8_19; 
reg signed [63:0] f8g9_19; 
reg signed [63:0] f9g0   ; 
reg signed [63:0] f9g1_38; 
reg signed [63:0] f9g2_19; 
reg signed [63:0] f9g3_38; 
reg signed [63:0] f9g4_19; 
reg signed [63:0] f9g5_38; 
reg signed [63:0] f9g6_19; 
reg signed [63:0] f9g7_38; 
reg signed [63:0] f9g8_19; 
reg signed [63:0] f9g9_38; 

reg signed [63:0] h0;
reg signed [63:0] h1;
reg signed [63:0] h2;
reg signed [63:0] h3;
reg signed [63:0] h4;
reg signed [63:0] h5;
reg signed [63:0] h6;
reg signed [63:0] h7;
reg signed [63:0] h8;
reg signed [63:0] h9;

reg [319:0] rres;
reg rdone;

assign done = rdone;
assign res = rres;

always @ (posedge clk)
begin
    if (rst == 1'b0)
        cycle <= 0;
    else
        begin
    
    //TODO replace with zeroes
    mul19_a_in <= 0;
    mul19_b_in <= 0;
    mul_a_in32 <= 0;
    mul_a_in64 <= 0;
    mul_b_in32 <= 0;
    mul_b_in64 <= 0;
    mul_c_in32 <= 0;
    mul_c_in64 <= 0;
    mul_d_in32 <= 0;
    mul_d_in64 <= 0;
    h0 <= h0;
    cycle <= cycle << 1;
    rdone <= 0;
    rres <= 0;
    case (cycle)
    33'h00000000  : begin //Idle state
                    if (valid == 1'b1)
                    begin
                                   mul19_a_in <= $signed(op_b[9*32+:32]);
                                   mul19_b_in <= $signed(op_b[2*32+:32]);
                                   mul_a_in32 <= $signed(op_a[0*32+:32]);
                                   mul_a_in64 <= $signed(op_b[0*32+:32]);
                                   mul_b_in32 <= $signed(op_a[0*32+:32]);
                                   mul_b_in64 <= $signed(op_b[1*32+:32]);
                                   mul_c_in32 <= $signed(op_a[0*32+:32]);
                                   mul_c_in64 <= $signed(op_b[2*32+:32]);
                                   mul_d_in32 <= $signed(op_a[0*32+:32]);
                                   mul_d_in64 <= $signed(op_b[3*32+:32]);
                                   h0 <= 0;
                                   h1 <= 0;
                                   h2 <= 0;
                                   h3 <= 0;
                                   h4 <= 0;
                                   h5 <= 0;
                                   h6 <= 0;
                                   h7 <= 0;
                                   h8 <= 0;
                                   h9 <= 0;
                                   cycle <= 1;
                                   
                    end else
                        cycle <= 0;
                end
                
    33'h00000001  : begin //========= CYCLE 1 ============
                    mul19_a_in <= $signed(op_b[3*32+:32]);
                    mul19_b_in <= $signed(op_b[4*32+:32]);
                    mul_a_in32 <= $signed(op_a[0*32+:32]);
                    mul_a_in64 <= $signed(op_b[4*32+:32]);
                    mul_b_in32 <= $signed(op_a[0*32+:32]);
                    mul_b_in64 <= $signed(op_b[5*32+:32]);
                    mul_c_in32 <= $signed(op_a[0*32+:32]);
                    mul_c_in64 <= $signed(op_b[6*32+:32]);
                    mul_d_in32 <= $signed(op_a[0*32+:32]);
                    mul_d_in64 <= $signed(op_b[7*32+:32]);
                end
    33'h00000002  : begin //========= CYCLE 2 ============
                    g9_19 <= mul19_a_out;
                    g2_19 <= mul19_b_out;
                    
                    mul19_a_in <= $signed(op_b[5*32+:32]);
                    mul19_b_in <= $signed(op_b[6*32+:32]);
                    mul_a_in32 <= $signed(op_a[0*32+:32]);
                    mul_a_in64 <= $signed(op_b[8*32+:32]);
                    mul_b_in32 <= $signed(op_a[0*32+:32]);
                    mul_b_in64 <= $signed(op_b[9*32+:32]);
                    mul_c_in32 <= $signed(op_a[1*32+:32]);
                    mul_c_in64 <= $signed(op_b[0*32+:32]);
                    mul_d_in32 <= $signed(op_a[1*32+:32] << 1); //f1_2
                    mul_d_in64 <= $signed(op_b[1*32+:32]);
                end
    33'h000000004   : begin //========= CYCLE 3 ============
                    g3_19 <= mul19_a_out;
                    g4_19 <= mul19_b_out;
                    
                    mul19_a_in <= $signed(op_b[7*32+:32]);
                    mul19_b_in <= $signed(op_b[8*32+:32]);
                    mul_a_in32 <= $signed(op_a[1*32+:32]);
                    mul_a_in64 <= $signed(op_b[2*32+:32]);
                    mul_b_in32 <= $signed(op_a[1*32+:32] << 1);
                    mul_b_in64 <= $signed(op_b[3*32+:32]);
                    mul_c_in32 <= $signed(op_a[1*32+:32]);
                    mul_c_in64 <= $signed(op_b[4*32+:32]);
                    mul_d_in32 <= $signed(op_a[1*32+:32] << 1);
                    mul_d_in64 <= $signed(op_b[5*32+:32]);
                end   
    33'h00000008  : begin //========= CYCLE 4 ============
                    g5_19 <= mul19_a_out;
                    g6_19 <= mul19_b_out;
                    mul19_a_in <= $signed(op_b[1*32+:32]);
                    mul19_b_in <= 32'b0;
                    mul_a_in32 <= $signed(op_a[1*32+:32]);
                    mul_a_in64 <= $signed(op_b[6*32+:32]);
                    mul_b_in32 <= $signed(op_a[1*32+:32] << 1);
                    mul_b_in64 <= $signed(op_b[7*32+:32]);
                    mul_c_in32 <= $signed(op_a[1*32+:32]);
                    mul_c_in64 <= $signed(op_b[8*32+:32]);
                    mul_d_in32 <= $signed(op_a[1*32+:32] << 1);
                    mul_d_in64 <= g9_19;
                end    
    33'h00000010  : begin //========= CYCLE 5 ============
                    g7_19 <= mul19_a_out;
                    g8_19 <= mul19_b_out;
                    f0g0 <= mul_a_out;
                    f0g1 <= mul_b_out;
                    f0g2 <= mul_c_out;
                    f0g3 <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[2*32+:32]);
                    mul_a_in64 <= $signed(op_b[1*32+:32]);
                    mul_b_in32 <= $signed(op_a[2*32+:32]);
                    mul_b_in64 <= $signed(op_b[2*32+:32]);
                    mul_c_in32 <= $signed(op_a[2*32+:32]);
                    mul_c_in64 <= $signed(op_b[3*32+:32]);
                    mul_d_in32 <= $signed(op_a[2*32+:32]);
                    mul_d_in64 <= $signed(op_b[4*32+:32]);
                    add_a_in1 <= mul_a_out; add_a_in2 <= h0;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h1;
                    add_c_in1 <= mul_c_out; add_c_in2 <= h2;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h3;
                end
    33'h00000020  : begin //========= CYCLE 6 ============
                    g1_19 <= mul19_a_out;
                    f0g4 <= mul_a_out;
                    f0g5 <= mul_b_out;
                    f0g6 <= mul_c_out;
                    f0g7 <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[2*32+:32]);
                    mul_a_in64 <= $signed(op_b[5*32+:32]);
                    mul_b_in32 <= $signed(op_a[2*32+:32]);
                    mul_b_in64 <= $signed(op_b[6*32+:32]);
                    mul_c_in32 <= $signed(op_a[2*32+:32]);
                    mul_c_in64 <= $signed(op_b[7*32+:32]);
                    mul_d_in32 <= $signed(op_a[2*32+:32]);
                    mul_d_in64 <= g8_19;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h4;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h5;
                    add_c_in1 <= mul_c_out; add_c_in2 <= h6;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h7;
                end
    33'h00000040 : begin //========= CYCLE 7 ============
                    f0g8 <= mul_a_out;
                    f0g9 <= mul_b_out;
                    f1g0 <= mul_c_out;
                    f1g1_2 <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[2*32+:32]);
                    mul_a_in64 <= $signed(op_b[0*32+:32]);
                    mul_b_in32 <= $signed(op_a[3*32+:32]);
                    mul_b_in64 <= $signed(op_b[0*32+:32]);
                    mul_c_in32 <= $signed(op_a[2*32+:32]);
                    mul_c_in64 <= g9_19;
                    mul_d_in32 <= $signed(op_a[3*32+:32] << 1);
                    mul_d_in64 <= $signed(op_b[1*32+:32]);
                    h0 <= add_a_out;
                    h1 <= add_b_out;
                    h2 <= add_c_out;
                    h3 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h8;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h9;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h1;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h2;
                end
    33'h00000080 : begin //========= CYCLE 8 ============
                    f1g2   <= mul_a_out;
                    f1g3_2 <= mul_b_out;
                    f1g4   <= mul_c_out;
                    f1g5_2 <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[3*32+:32]);
                    mul_a_in64 <= $signed(op_b[2*32+:32]);
                    mul_b_in32 <= $signed(op_a[3*32+:32] << 1);
                    mul_b_in64 <= $signed(op_b[3*32+:32]);
                    mul_c_in32 <= $signed(op_a[3*32+:32]);
                    mul_c_in64 <= $signed(op_b[4*32+:32]);
                    mul_d_in32 <= $signed(op_a[3*32+:32] << 1);
                    mul_d_in64 <= $signed(op_b[5*32+:32]);
                    h4 <= add_a_out;
                    h5 <= add_b_out;
                    h6 <= add_c_out;
                    h7 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h3;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h4;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h5;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h6;
                end
    33'h000000100  : begin //========= CYCLE 9 ============
                    f1g6    <= mul_a_out;
                    f1g7_2  <= mul_b_out;
                    f1g8    <= mul_c_out;
                    f1g9_38 <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[3*32+:32]);
                    mul_a_in64 <= $signed(op_b[6*32+:32]);
                    mul_b_in32 <= $signed(op_a[3*32+:32] << 1);
                    mul_b_in64 <= g7_19;
                    mul_c_in32 <= $signed(op_a[3*32+:32]);
                    mul_c_in64 <= g8_19;
                    mul_d_in32 <= $signed(op_a[3*32+:32] << 1);
                    mul_d_in64 <= g9_19;
                    h8 <= add_a_out;
                    h9 <= add_b_out;
                    h1 <= add_c_out;
                    h2 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h7;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h8;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h9;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h0;
                end
    33'h000000200  : begin //========= CYCLE 10 ============
                    f2g1  <= mul_a_out;
                    f2g2  <= mul_b_out;
                    f2g3  <= mul_c_out;
                    f2g4  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[4*32+:32]);
                    mul_a_in64 <= $signed(op_b[0*32+:32]);
                    mul_b_in32 <= $signed(op_a[4*32+:32]);
                    mul_b_in64 <= $signed(op_b[1*32+:32]);
                    mul_c_in32 <= $signed(op_a[4*32+:32]);
                    mul_c_in64 <= $signed(op_b[2*32+:32]);
                    mul_d_in32 <= $signed(op_a[4*32+:32]);
                    mul_d_in64 <= $signed(op_b[3*32+:32]);
                    h3 <= add_a_out;
                    h4 <= add_b_out;
                    h5 <= add_c_out;
                    h6 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= add_a_out;//h3;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_b_out;//h4;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_c_out;//h5;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_d_out;//h6;

                end
    33'h000000400  : begin //========= CYCLE 11 ============
                    f2g5  <= mul_a_out;
                    f2g6  <= mul_b_out;
                    f2g7  <= mul_c_out;
                    f2g8_19  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[4*32+:32]);
                    mul_a_in64 <= $signed(op_b[4*32+:32]);
                    mul_b_in32 <= $signed(op_a[4*32+:32]);
                    mul_b_in64 <= $signed(op_b[5*32+:32]);
                    mul_c_in32 <= $signed(op_a[4*32+:32]);
                    mul_c_in64 <= g6_19;
                    mul_d_in32 <= $signed(op_a[4*32+:32]);
                    mul_d_in64 <= g7_19;
                    h7 <= add_a_out;
                    h8 <= add_b_out;
                    h9 <= add_c_out;
                    h0 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= add_a_out;//h7;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_b_out;//h8;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_c_out;//h9;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_d_out;//h0;

                end
    33'h000000800  : begin //========= CYCLE 12 ============
                    f2g0    <= mul_a_out;
                    f3g0    <= mul_b_out;
                    f2g9_19 <= mul_c_out;
                    f3g1_2  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[4*32+:32]);
                    mul_a_in64 <= g8_19;
                    mul_b_in32 <= $signed(op_a[4*32+:32]);
                    mul_b_in64 <= g9_19;
                    mul_c_in32 <= $signed(op_a[5*32+:32]);
                    mul_c_in64 <= $signed(op_b[0*32+:32]);
                    mul_d_in32 <= $signed(op_a[5*32+:32] << 1);
                    mul_d_in64 <= $signed(op_b[1*32+:32]);
                    h3 <= add_a_out;
                    h4 <= add_b_out;
                    h5 <= add_c_out;
                    h6 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h2;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h3;
                    add_c_in1 <= mul_c_out; add_c_in2 <= h1;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_b_out;//h4;

                end
    33'h000001000  : begin //========= CYCLE 13 ============
                    f3g2    <= mul_a_out;
                    f3g3_2  <= mul_b_out;
                    f3g4    <= mul_c_out;
                    f3g5_2  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[5*32+:32]);
                    mul_a_in64 <= $signed(op_b[2*32+:32]);
                    mul_b_in32 <= $signed(op_a[5*32+:32]<< 1);
                    mul_b_in64 <= $signed(op_b[3*32+:32]);
                    mul_c_in32 <= $signed(op_a[5*32+:32]);
                    mul_c_in64 <= $signed(op_b[4*32+:32]);
                    mul_d_in32 <= $signed(op_a[5*32+:32] << 1);
                    mul_d_in64 <= g5_19;
                    h7 <= add_a_out;
                    h8 <= add_b_out;
                    h9 <= add_c_out;
                    h0 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h5;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h6;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_a_out;//h7;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_b_out;//h8;
                end
    33'h000002000  : begin //========= CYCLE 14 ============
                    f3g6     <= mul_a_out;
                    f3g7_38  <= mul_b_out;
                    f3g8_19  <= mul_c_out;
                    f3g9_38  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[5*32+:32]);
                    mul_a_in64 <= g6_19;
                    mul_b_in32 <= $signed(op_a[5*32+:32]<< 1);
                    mul_b_in64 <= g7_19;
                    mul_c_in32 <= $signed(op_a[5*32+:32]);
                    mul_c_in64 <= g8_19;
                    mul_d_in32 <= $signed(op_a[5*32+:32] << 1);
                    mul_d_in64 <= g9_19;
                    h2 <= add_a_out;
                    h3 <= add_b_out;
                    h1 <= add_c_out;
                    h4 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h9;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h0;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_c_out;//h1;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_a_out;//h2;
                end
    33'h000004000  : begin //========= CYCLE 15 ============
                    f4g0     <= mul_a_out;
                    f4g1     <= mul_b_out;
                    f4g2     <= mul_c_out;
                    f4g3     <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[6*32+:32]);
                    mul_a_in64 <= $signed(op_b[0*32+:32]);
                    mul_b_in32 <= $signed(op_a[6*32+:32]);
                    mul_b_in64 <= $signed(op_b[1*32+:32]);
                    mul_c_in32 <= $signed(op_a[6*32+:32]);
                    mul_c_in64 <= $signed(op_b[2*32+:32]);
                    mul_d_in32 <= $signed(op_a[6*32+:32]);
                    mul_d_in64 <= $signed(op_b[3*32+:32]);
                    h5 <= add_a_out;
                    h6 <= add_b_out;
                    h7 <= add_c_out;
                    h8 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h4;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h5;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h6;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h7;
                end
    33'h000008000  : begin //========= CYCLE 16 ============
                    f4g4     <= mul_a_out;
                    f4g5     <= mul_b_out;
                    f4g6_19  <= mul_c_out;
                    f4g7_19  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[6*32+:32]);
                    mul_a_in64 <= g4_19;
                    mul_b_in32 <= $signed(op_a[6*32+:32]);
                    mul_b_in64 <= g5_19;
                    mul_c_in32 <= $signed(op_a[6*32+:32]);
                    mul_c_in64 <= g6_19;
                    mul_d_in32 <= $signed(op_a[6*32+:32]);
                    mul_d_in64 <= g7_19;
                    h9 <= add_a_out;
                    h0 <= add_b_out;
                    h1 <= add_c_out;
                    h2 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h8;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h9;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h0;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h1;
                end
    33'h000010000   : begin //========= CYCLE 17 ============
                    f4g8_19  <= mul_a_out;
                    f4g9_19  <= mul_b_out;
                    f5g0     <= mul_c_out;
                    f5g1_2   <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[6*32+:32]);
                    mul_a_in64 <= g8_19;
                    mul_b_in32 <= $signed(op_a[6*32+:32]);
                    mul_b_in64 <= g9_19;
                    mul_c_in32 <= $signed(op_a[7*32+:32]);
                    mul_c_in64 <= $signed(op_b[0*32+:32]);
                    mul_d_in32 <= $signed(op_a[7*32+:32] << 1);
                    mul_d_in64 <= $signed(op_b[1*32+:32]);
                    h4 <= add_a_out;
                    h5 <= add_b_out;
                    h6 <= add_c_out;
                    h7 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h2;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h3;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h5;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h6;
                end
    33'h000020000  : begin //========= CYCLE 18 ============
                    f5g2     <= mul_a_out;
                    f5g3_2   <= mul_b_out;
                    f5g4     <= mul_c_out;
                    f5g5_38  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[7*32+:32]);
                    mul_a_in64 <= $signed(op_b[2*32+:32]);
                    mul_b_in32 <= $signed(op_a[7*32+:32] << 1);
                    mul_b_in64 <= g3_19;
                    mul_c_in32 <= $signed(op_a[7*32+:32]);
                    mul_c_in64 <= g4_19;
                    mul_d_in32 <= $signed(op_a[7*32+:32] << 1);
                    mul_d_in64 <= g5_19;
                    h8 <= add_a_out;
                    h9 <= add_b_out;
                    h0 <= add_c_out;
                    h1 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h7;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h8;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h9;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h0;
                end                
    33'h000040000  : begin //========= CYCLE 19 ============
                    f5g6_19   <= mul_a_out;
                    f5g7_38   <= mul_b_out;
                    f5g8_19   <= mul_c_out;
                    f5g9_38   <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[7*32+:32]);
                    mul_a_in64 <= g6_19;
                    mul_b_in32 <= $signed(op_a[7*32+:32] << 1);
                    mul_b_in64 <= g7_19;
                    mul_c_in32 <= $signed(op_a[7*32+:32]);
                    mul_c_in64 <= g8_19;
                    mul_d_in32 <= $signed(op_a[7*32+:32] << 1);
                    mul_d_in64 <= g9_19;
                    h2 <= add_a_out;
                    h3 <= add_b_out;
                    h5 <= add_c_out;
                    h6 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h1;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h2;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h3;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h4;
                end
    33'h000080000   : begin //========= CYCLE 20 ============
                    f6g0     <= mul_a_out;
                    f6g1     <= mul_b_out;
                    f6g2     <= mul_c_out;
                    f6g3     <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[8*32+:32]);
                    mul_a_in64 <= $signed(op_b[0*32+:32]);
                    mul_b_in32 <= $signed(op_a[8*32+:32]);
                    mul_b_in64 <= $signed(op_b[1*32+:32]);
                    mul_c_in32 <= $signed(op_a[8*32+:32]);
                    mul_c_in64 <= g2_19;
                    mul_d_in32 <= $signed(op_a[8*32+:32]);
                    mul_d_in64 <= g3_19;
                    h7 <= add_a_out;
                    h8 <= add_b_out;
                    h9 <= add_c_out;
                    h0 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h6;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h7;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h8;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h9;
                end
    33'h000100000  : begin //========= CYCLE 21 ============
                    f6g4_19  <= mul_a_out;
                    f6g5_19  <= mul_b_out;
                    f6g6_19  <= mul_c_out;
                    f6g7_19  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[8*32+:32]);
                    mul_a_in64 <= g4_19;
                    mul_b_in32 <= $signed(op_a[8*32+:32]);
                    mul_b_in64 <= g5_19;
                    mul_c_in32 <= $signed(op_a[8*32+:32]);
                    mul_c_in64 <= g6_19;
                    mul_d_in32 <= $signed(op_a[8*32+:32]);
                    mul_d_in64 <= g7_19;
                    h1 <= add_a_out;
                    h2 <= add_b_out;
                    h3 <= add_c_out;
                    h4 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h0;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h1;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h2;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h3;
                end
    33'h000200000  : begin //========= CYCLE 22 ============
                    f6g8_19  <= mul_a_out;
                    f6g9_19  <= mul_b_out;
                    f7g0     <= mul_c_out;
                    f7g1_2   <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[8*32+:32]);
                    mul_a_in64 <= g8_19;
                    mul_b_in32 <= $signed(op_a[8*32+:32]);
                    mul_b_in64 <= g9_19;
                    mul_c_in32 <= $signed(op_a[9*32+:32]);
                    mul_c_in64 <= $signed(op_b[0*32+:32]);
                    mul_d_in32 <= $signed(op_a[9*32+:32] << 1);
                    mul_d_in64 <= g1_19;
                    h6 <= add_a_out;
                    h7 <= add_b_out;
                    h8 <= add_c_out;
                    h9 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h4;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h5;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h7;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h8;
                end
    33'h000400000  : begin //========= CYCLE 23 ============
                    f7g2     <= mul_a_out;
                    f7g3_38  <= mul_b_out;
                    f7g4_19  <= mul_c_out;
                    f7g5_38  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[9*32+:32]);
                    mul_a_in64 <= g2_19;
                    mul_b_in32 <= $signed(op_a[9*32+:32] << 1);
                    mul_b_in64 <= g3_19;
                    mul_c_in32 <= $signed(op_a[9*32+:32]);
                    mul_c_in64 <= g4_19;
                    mul_d_in32 <= $signed(op_a[9*32+:32] << 1);
                    mul_d_in64 <= g5_19;
                    h0 <= add_a_out;
                    h1 <= add_b_out;
                    h2 <= add_c_out;
                    h3 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h9;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h0;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h1;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h2;
                end
    33'h000800000 : begin //========= CYCLE 24 ============
                    f7g6_19  <= mul_a_out;
                    f7g7_38  <= mul_b_out;
                    f7g8_19  <= mul_c_out;
                    f7g9_38  <= mul_d_out;
                    mul_a_in32 <= $signed(op_a[9*32+:32]);
                    mul_a_in64 <= g6_19;
                    mul_b_in32 <= $signed(op_a[9*32+:32] << 1);
                    mul_b_in64 <= g7_19;
                    mul_c_in32 <= $signed(op_a[9*32+:32]);
                    mul_c_in64 <= g8_19;
                    mul_d_in32 <= $signed(op_a[9*32+:32] << 1);
                    mul_d_in64 <= g9_19;
                    h4 <= add_a_out;
                    h5 <= add_b_out;
                    h7 <= add_c_out;
                    h8 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h3;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h4;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h5;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h6;
                end
    33'h001000000 : begin //========= CYCLE 25 ============
                    f8g0     <= mul_a_out;
                    f8g1     <= mul_b_out;
                    f8g2_19  <= mul_c_out;
                    f8g3_19  <= mul_d_out;
                    h9 <= add_a_out;
                    h0 <= add_b_out;
                    h1 <= add_c_out;
                    h2 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h8;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h9;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h0;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h1;
                end
                
    33'h002000000: begin //========= CYCLE 26 ============
                    f8g4_19  <= mul_a_out;
                    f8g5_19  <= mul_b_out;
                    f8g6_19  <= mul_c_out;
                    f8g7_19  <= mul_d_out;
                    h3 <= add_a_out;
                    h4 <= add_b_out;
                    h5 <= add_c_out;
                    h6 <= add_d_out;     
                    add_a_in1 <= mul_a_out; add_a_in2 <= h2;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h3;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//4;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h5;
                end
                    
    33'h004000000 : begin //========= CYCLE 27 ============
                    f8g8_19  <= mul_a_out;
                    f8g9_19  <= mul_b_out;
                    f9g0     <= mul_c_out;
                    f9g1_38  <= mul_d_out;
                    h8 <= add_a_out;
                    h9 <= add_b_out;
                    h0 <= add_c_out;
                    h1 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h6;
                    add_b_in1 <= mul_b_out; add_b_in2 <= h7;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h9;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h0;
                end
                    
    33'h008000000 : begin //========= CYCLE 28 ============
                    f9g2_19  <= mul_a_out;
                    f9g3_38  <= mul_b_out;
                    f9g4_19  <= mul_c_out;
                    f9g5_38  <= mul_d_out;
                    h2 <= add_a_out;
                    h3 <= add_b_out;
                    h4 <= add_c_out;
                    h5 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h1;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h2;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h3;
                    add_d_in1 <= mul_d_out; add_d_in2 <= add_c_out;//h4;
                end
                    
    33'h010000000 : begin //========= CYCLE 29 ============
                    f9g6_19  <= mul_a_out;
                    f9g7_38  <= mul_b_out;
                    f9g8_19  <= mul_c_out;
                    f9g9_38  <= mul_d_out;
                    h6 <= add_a_out;
                    h7 <= add_b_out;
                    h9 <= add_c_out;
                    h0 <= add_d_out;
                    add_a_in1 <= mul_a_out; add_a_in2 <= h5;
                    add_b_in1 <= mul_b_out; add_b_in2 <= add_a_out;//h6;
                    add_c_in1 <= mul_c_out; add_c_in2 <= add_b_out;//h7;
                    add_d_in1 <= mul_d_out; add_d_in2 <= h8;
                end
                
    33'h020000000 : begin //========= CYCLE 30 ============
                    h1 <= add_a_out;
                    h2 <= add_b_out;
                    h3 <= add_c_out;
                    h4 <= add_d_out;
                end
                
    33'h040000000  : begin //========= CYCLE 31 ============
                    h5 <= add_a_out;
                    h6 <= add_b_out;
                    h7 <= add_c_out;
                    h8 <= add_d_out;
                end
    33'h080000000 : begin : carryblk //========= CYCLE 32 ============
        
                    reg signed [63:0] carry0;
                    reg signed [63:0] carry1;
                    reg signed [63:0] carry2;
                    reg signed [63:0] carry3;
                    reg signed [63:0] carry4;
                    reg signed [63:0] carry5;
                    reg signed [63:0] carry6;
                    reg signed [63:0] carry7;
                    reg signed [63:0] carry8;
                    reg signed [63:0] carry9;
                    
                    carry0 = (h0 +  (64'sd1 << 25)) >>> 26;
                    h1 = h1 + carry0;
                    h0 = h0 - (carry0 << 26);
                    carry4 = (h4 + (64'sd1 << 25)) >>> 26;
                    h5 = h5 + carry4;
                    h4 = h4 - (carry4 << 26);
                    carry1 = (h1 + (64'sd1 << 24)) >>> 25;
                    h2 = h2 + carry1;
                    h1 = h1 - (carry1 << 25);
                    carry5 = (h5 + (64'sd1 << 24)) >>> 25;
                    h6 = h6 + carry5;
                    h5 = h5 - (carry5 << 25);
                    carry2 = (h2 + (64'sd1 << 25)) >>> 26;
                    h3 = h3 + carry2;
                    h2 = h2 - (carry2 << 26);
                    carry6 = (h6 + (64'sd1 << 25)) >>> 26;
                    h7 = h7 + carry6;
                    h6 = h6 - (carry6 << 26);

                    carry3 = (h3 + (64'sd1 << 24)) >>> 25;
                    h4 = h4 + carry3;
                    h3 = h3 - (carry3 << 25);
                    carry7 = (h7 + (64'sd1 << 24)) >>> 25;
                    h8 = h8 + carry7;
                    h7 = h7 - (carry7 << 25);
                    carry4 = (h4 + (64'sd1 << 25)) >>> 26;
                    h5 = h5 + carry4;
                    h4 = h4 - (carry4 << 26);
                    carry8 = (h8 + (64'sd1 << 25)) >>> 26;
                    h9 = h9 + carry8;
                    h8 = h8 - (carry8 << 26);
                    carry9 = (h9 + (64'sd1 << 24)) >>> 25;
                    h0 = h0 + carry9 * 19; //TODO reuse 1 stage adder further up
                    h9 = h9 - (carry9 << 25);
                    carry0 = (h0 + (64'sd1 << 25)) >>> 26;
                    h1 = h1 + carry0;
                    h0 = h0 - (carry0 << 26);
                    
                    rres[0*32 +: 32] <= h0;
                    rres[1*32 +: 32] <= h1;
                    rres[2*32 +: 32] <= h2;
                    rres[3*32 +: 32] <= h3;
                    rres[4*32 +: 32] <= h4;
                    rres[5*32 +: 32] <= h5;
                    rres[6*32 +: 32] <= h6;
                    rres[7*32 +: 32] <= h7;
                    rres[8*32 +: 32] <= h8;
                    rres[9*32 +: 32] <= h9;
                    rdone <= 1;
                    cycle <= 0;
                end
                
            
        
            
    endcase
    
    end //if not reset

end    
endmodule