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
    input wire [255:0] a,
    input wire [255:0] b,
    input wire [319:0] A_X,
    input wire [319:0] A_Y,
    input wire [319:0] A_Z,
    input wire [319:0] A_T,
    input wire valid,
    
    //Resources
    output wire [319:0] mul_op_a,
    output wire [319:0] mul_op_b,
    output wire mul_valid,
    input wire [319:0] mul_res,
    input wire mul_done,
    
    output wire [319:0] add_op_a,
    output wire [319:0] add_op_b,
    input wire [319:0]  add_res,
    
    output wire [319:0] sub_op_a,
    output wire [319:0] sub_op_b,
    input wire [319:0]  sub_res,
    
    //output
    output wire [255:0] ge_bytes,
    output wire done,
        
    //misc
    input wire clk,
    input wire rst
    
    );
    
 `include "../fe/fe_common.v"   
 
wire [319:0] douta;
wire [319:0] doutb;
reg wea;
reg web;
reg [6:0] addra;
reg [6:0] addrb;
reg [319:0] dina;
reg [319:0] dinb;


reg rdone;
reg rge_isneg;
reg [255:0] rge_bytes;
reg [255:0] rrge_bytes;

assign ge_bytes = rge_bytes;
assign done = rdone;
   
blk_mem_gen_0 feram (
      .clka(clk),    // input wire clka
      .ena(1'b1),      // input wire ena
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [6 : 0] addra
      .dina(dina),    // input wire [319 : 0] dina
      .douta(douta),  // output wire [319 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(1'b1),      // input wire enb
      .web(web),      // input wire [0 : 0] web
      .addrb(addrb),  // input wire [6 : 0] addrb
      .dinb(dinb),    // input wire [319 : 0] dinb
      .doutb(doutb)  // output wire [319 : 0] doutb
    );

wire [319:0] fe_out;
reg fei_valid;
wire fei_done;
wire [319:0] fei_mul_op_a;
wire [319:0] fei_mul_op_b;
wire fei_mul_valid;
fe_invert FEI (
   .z(douta),
   .out(fe_out),
   .clk(clk),
   .rst(rst),
   .valid(fei_valid),
   .done(fei_done),

    //Resources
   .pmul_in1(fei_mul_op_a),
   .pmul_in2(fei_mul_op_b),
   .pmul_valid(fei_mul_valid),
   .mul_res(mul_res),
   .mul_done(mul_done)
);

reg mul_en;
reg fei_en;
assign mul_valid = mul_en | fei_mul_valid;
assign mul_op_a = fei_en ? fei_mul_op_a : douta;
assign mul_op_b = fei_en ? fei_mul_op_b : doutb;

assign add_op_a = douta;
assign add_op_b = doutb;
assign sub_op_a = douta;
assign sub_op_b = doutb;

reg [10:0] state;
 
`define MM_d              0
`define MM_sqrtml         1
`define MM_d2             2
`define MM_n2             3
`define MM_Bi_base        4
`define MM_t_X            40
`define MM_t_Y            41
`define MM_t_Z            42
`define MM_t_T            43
`define MM_u_X            44
`define MM_u_Y            45
`define MM_u_Z            46
`define MM_u_T            47
`define MM_A2_X           48
`define MM_A2_Y           49
`define MM_A2_Z           50
`define MM_A2_T           51
`define MM_q_X            52
`define MM_q_Y            53
`define MM_q_Z            54
`define MM_Ai_base        55

`define MM_A_X            87
`define MM_A_Y            88
`define MM_A_Z            89
`define MM_A_T            90
`define MM_t0             91
`define MM_tmp            92
`define MM_r_X            93
`define MM_r_Y            94
`define MM_r_Z            95

`define Ai_YplusX       0
`define Ai_YminusX      1
`define Ai_Z            2
`define Ai_T2d          3
`define MM_Ai_sz        4

`define FE_0 320'h0
`define FE_1 320'h1

`define MM_Ai_YplusX(x)  (55 + ((x)*4) + 0)
`define MM_Ai_YminusX(x) (55 + ((x)*4) + 1)
`define MM_Ai_Z(x)       (55 + ((x)*4) + 2)
`define MM_Ai_T2d(x)     (55 + ((x)*4) + 3)
`define MM_Bi_YplusX(x)  (4 + ((x)*3) + 0)
`define MM_Bi_YminusX(x) (4 + ((x)*3) + 1)
`define MM_Bi_XY2d(x)    (4 + ((x)*3) + 2)

reg [319:0] foo;
reg signed [8:0] loopi;

reg [319:0] rtmp_X;   
reg [319:0] rtmp_Y;   
reg  [255:0] rtmpXbytes;
reg  [255:0] rtmpYbytes;

reg [319:0] tobytes_in;
wire [255:0] tobytes_res;
reg tobytes_valid;
wire tobytes_done;
fe_tobytes TOBYTES(
.in(tobytes_in),
.out(tobytes_res),
.clk(clk),
.rst(rst),
.valid(tobytes_valid),
.done(tobytes_done)
   );

always @ (posedge clk)
begin
    if (rst == 0)
    begin
        state <= 10'd0;
    end else 
    begin
        state <= state + 1;
        mul_en <= 0;
        dina <= 0;
        dinb <= 0;
        wea <= 0;
        web <= 0;
        addra <= 0;
        addrb <= 0;
        loopi <= loopi;
        rdone <= 1'b0;
        fei_en <= 1'b0;
        fei_valid <= 1'b0;
        tobytes_valid <= 0;
        case (state)
        10'd0   :   begin
                        if (valid == 1'b0)
                        begin
                            state <= 10'd0;  
                        end
                    end
        10'd1   :   begin //Load Ax and Ay into ram
                        dina <= A_X;
                        addra <= `MM_A_X;
                        wea <= 1;
                        dinb <= A_Y;
                        addrb <= `MM_A_Y;
                        web <= 1;
                    end
        10'd2   :   begin
                        //Load Az and At into ram
                        dina <= A_Z;
                        addra <= `MM_A_Z;
                        wea <= 1;
                        dinb <= A_T;
                        addrb <= `MM_A_T;
                        web <= 1;
                    end
                    //begin //ge_p3_to_cached(&Ai[0]], A);
        10'd3   :   begin  //fe_add(Ai[0].YplusX, A_Y, A_X); fe_sub(Ai[0].YminusX, A_Y, A_X);
                        addra <= `MM_A_Y;
                        addrb <= `MM_A_X;
                    end
        10'd4   :   begin 
                        //fe_copy(Ai[0].Z, A_Z);
                        addra <= `MM_A_Z;
                    end
        10'd5   :   begin
                        //Store cy3 
                        addra <= `MM_Ai_base + `Ai_YplusX;
                        wea <= 1;
                        dina <= add_res;
                        addrb <= `MM_Ai_base + `Ai_YminusX;
                        web <= 1;
                        dinb <= sub_res;
                    end
        10'd6   :   begin 
                        dina <= douta;
                        addra <= `MM_Ai_base + `Ai_Z;
                        wea <= 1;
                    end
        10'd7   :   begin
                        addra <= `MM_A_T;
                        addrb <= `MM_d2;
                    end
        10'd8   :   begin
                        mul_en <= 1;
                        addra <= `MM_A_T;
                        addrb <= `MM_d2;
                    end
        10'd9   :   begin
                        if (mul_done)
                        begin
                            addra <= `MM_Ai_base + `Ai_T2d;
                            wea <= 1'b1;
                            dina <= mul_res;
                            addrb <= `MM_A_X; //fe_copy(q_X, A_X);
                        end else
                        begin
                            addra <= `MM_A_T;
                            addrb <= `MM_d2;
                            state <= 9;
                        end;                       
                    end
                    //end ge p3 to cached
        10'd10  :   begin
                        addra <= `MM_A_Y;   //fe_copy(q_Y, A_Y);
                        addrb <= `MM_A_Z;   //fe_copy(q_Z, A_Z);
                    end
        10'd11  :   begin
                        //Store from 9
                        addra <= `MM_q_X;
                        dina <= doutb;
                        wea <= 1'b1; 
                    end
        10'd12  :   begin
                        addra <= `MM_q_Y;
                        addrb <= `MM_q_Z;
                        dina <= douta;
                        dinb <= doutb;
                        wea <= 1'b1;
                        web <= 1'b1;
                    end
                    
                    //Begin ge_p2_dbl(t, q)
        10'd13  :   begin
                        //fe_mul(t_X, q_X, q_X);
                        addra <= `MM_q_X;
                        addrb <= `MM_q_X;
                    end
        10'd14  :   begin
                        addra <= `MM_q_X;
                        addrb <= `MM_q_X;
                        mul_en <= 1; 
                    end
        10'd15  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_q_X;
                           addrb <= `MM_q_X;
                           state <= 15;
                        end
                    end
        10'd16  :   begin
                        addra <= `MM_q_Y;   //fe_mul(t_Z, q_Y, q_Y);
                        addrb <= `MM_q_Y; 
                    end
        10'd17  :   begin
                        addra <= `MM_q_Y;
                        addrb <= `MM_q_Y; 
                        mul_en <= 1;
                    end
        10'd18  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_q_Y;
                           addrb <= `MM_q_Y;
                           state <= 18;
                        end
                    end
        10'd19  :   begin
                        addra <= `MM_n2; //fe_mul(tmp, n2, q_Z);
                        addrb <= `MM_q_Z; 
                    end
        10'd20  :   begin
                        addra <= `MM_n2;  
                        addrb <= `MM_q_Z;
                        mul_en <= 1;
                    end
        10'd21  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_tmp;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_n2;
                           addrb <= `MM_q_Z;
                           state <= 21;
                        end  
                    end
        10'd22  :   begin
                        addra <= `MM_q_Z; //fe_mul(t_T, q_Z, tmp);
                        addrb <= `MM_tmp; 
                    end
        10'd23  :   begin
                        addra <= `MM_q_Z;
                        addrb <= `MM_tmp;
                        mul_en <= 1;  
                    end
        10'd24  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_q_Z;
                           addrb <= `MM_tmp;
                           state <= 24;
                        end 
                    end
        10'd25  :   begin
                        addra <= `MM_q_X;
                        addrb <= `MM_q_Y; 
                    end
        10'd26  :   begin
                        //stall
                    end
        10'd27  :   begin
                        addra <= `MM_t_Y;
                        dina <= add_res;
                        wea <= 1;
                    end
        10'd28  :   begin
                        addra <= `MM_t_Y; //fe_mul(t0, t_Y, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd29  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_t_Y;
                        mul_en <= 1; 
                    end
        10'd30  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t0;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_t_Y;
                           state <= 30;
                        end 
                    end
        10'd31  :   begin
                        addra <= `MM_t_Z; //fe_add(t_Y, t_Z, t_X); fe_sub(t_Z, t_Z, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd32  :   begin
                        //stall
                    end
        10'd33  :   begin
                        addra <= `MM_t_Y;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Z;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd34  :   begin           
                        addra <= `MM_t0; //fe_sub(t_X, t0, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd35  :   begin
                        addra <= `MM_t_T; //fe_sub(t_T, t_T, t_Z);
                        addrb <= `MM_t_Z; 
                    end
        10'd36  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                    end
        10'd37  :   begin
                        addra <= `MM_t_T;
                        wea <= 1'b1;
                        dina <= sub_res;
                    end
                    //End ge_p2_dbl
                    
                    //Begin p1p1_to_p3
        10'd38  :   begin 
                        addra <= `MM_t_X; //fe_mul(A2_X, t_X, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd39  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_t_T;
                        mul_en <= 1'b1;
                    end
        10'd40  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_A2_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_t_T;
                           state <= 40;
                        end
                    end
        10'd41  :   begin
                        addra <= `MM_t_Y; //fe_mul(A2_Y, t_Y, t_Z);
                        addrb <= `MM_t_Z;
                    end
        10'd42  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_t_Z;
                        mul_en <= 1; 
                    end
        10'd43  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_A2_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_t_Z;
                           state <= 43;
                        end 
                    end
        10'd44  :   begin
                        addra <= `MM_t_Z; //fe_mul(A2_Z, t_Z, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd45  :   begin
                        addra <= `MM_t_Z;
                        addrb <= `MM_t_T;
                        mul_en <= 1;
                    end
        10'd46  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_A2_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Z;
                           addrb <= `MM_t_T;
                           state <= 46;
                        end
                    end
        10'd47  :   begin
                        addra <= `MM_t_X; //fe_mul(A2_T, t_X, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd48  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_t_Y;
                        mul_en <= 1;
                    end
        10'd49  :   begin                        
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_A2_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_t_Y;
                           state <= 49;
                        end
                    end
                    //End p1p1_to_p3
                    //Begin GE ADD
        10'd50  :   begin
                        addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                        addrb <= `MM_A2_X;
                    end
        10'd51  :   begin
                        //stall
                    end
        10'd52  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd53  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(0);
                    end
        10'd54  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(0);
                        mul_en <= 1;
                    end
        10'd55  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(0);
                           state <= 55;
                        end
                    end
        10'd56  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(0);
                    end
        10'd57  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(0);;
                        mul_en <= 1;
                    end
        10'd58  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(0);
                           state <= 58;
                        end 
                    end
        10'd59  :   begin
                        addra <= `MM_Ai_T2d(0); //fe_mul(t_T, Ai[0].T2d, A2_T);
                        addrb <= `MM_A2_T;
                    end
        10'd60  :   begin
                        addra <= `MM_Ai_T2d(0);
                        addrb <= `MM_A2_T;
                        mul_en <= 1;
                    end
        10'd61  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(0);
                           addrb <= `MM_A2_T;
                           state <= 61;
                        end    
                    end
        10'd62  :   begin
                        addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(0);
                    end
        10'd63  :   begin
                        addra <= `MM_A2_Z;
                        addrb <= `MM_Ai_Z(0);
                        mul_en <= 1;
                    end
        10'd64  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_A2_Z;
                           addrb <= `MM_Ai_Z(0);
                           state <= 64;
                        end    
                    end
        10'd65  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd66  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd67  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd68  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd69  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd70  :   begin
                        //stall
                    end
        10'd71  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD        
                         
        //Begin p1p1_to_p3
        10'd72  :   begin 
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd73  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd74  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 74;
                    end
                end
        10'd75  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd76  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd77  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 77;
                    end 
                end
        10'd78  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd79  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd80  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 80;
                    end
                end
        10'd81  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd82  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd83  :   begin                        
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 83;
                    end
                end
                //End p1p1_to_p3(u, t)
        
                //begin //ge_p3_to_cached(&Ai[1]], u); :1070
        10'd84   :   begin  
                       addra <= `MM_u_Y;
                       addrb <= `MM_u_X;
                   end
        10'd85   :   begin
                       addra <= `MM_u_Z;
                   end
        10'd86   :   begin
                       //Store cy3
                       addra <= `MM_Ai_YplusX(1);
                       wea <= 1;
                       dina <= add_res;
                       addrb <= `MM_Ai_YminusX(1);
                       web <= 1;
                       dinb <= sub_res;
                   end
        10'd87   :   begin
                       dina <= douta;
                       addra <= `MM_Ai_Z(1);
                       wea <= 1;
                   end
        10'd88   :   begin
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd89   :   begin
                       mul_en <= 1;
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd90   :   begin
                       if (mul_done)
                       begin
                           addra <= `MM_Ai_T2d(1);
                           wea <= 1'b1;
                           dina <= mul_res;
                       end else
                       begin
                           addra <= `MM_u_T;
                           addrb <= `MM_d2;
                           state <= 90;
                       end;
                   end
                   //end ge p3 to cached


                  //Begin GE ADD tag3
        10'd91  :   begin
                        addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                        addrb <= `MM_A2_X;
                    end
        10'd92  :   begin
                        //stall
                    end
        10'd93  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd94  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(1);
                    end
        10'd95  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(1);
                        mul_en <= 1;
                    end
        10'd96  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(1);
                           state <= 96;
                        end
                    end
        10'd97  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(1);
                    end
        10'd98  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(1);
                        mul_en <= 1;
                    end
        10'd99  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(1);
                           state <= 99;
                        end 
                    end
        10'd100 :   begin
                        addra <= `MM_Ai_T2d(1); //fe_mul(t_T, Ai[0].T2d, A2_T);
                        addrb <= `MM_A2_T;
                    end
        10'd101 :   begin
                        addra <= `MM_Ai_T2d(1);
                        addrb <= `MM_A2_T;
                        mul_en <= 1;
                    end
        10'd102 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(1);
                           addrb <= `MM_A2_T;
                           state <= 102;
                        end    
                    end
        10'd103 :   begin
                        addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(1);
                    end
        10'd104  :   begin
                        addra <= `MM_A2_Z;
                        addrb <= `MM_Ai_Z(1);
                        mul_en <= 1;
                    end
        10'd105 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_A2_Z;
                           addrb <= `MM_Ai_Z(1);
                           state <= 105;
                        end    
                    end
        10'd106  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd107  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd108  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd109  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd110  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd111  :   begin
                        //stall
                    end
        10'd112  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD  

                //Begin p1p1_to_p3
        10'd113  :   begin 
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd114  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd115  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 115;
                    end
                end
        10'd116  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd117  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd118  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 118;
                    end 
                end
        10'd119  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd120  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd121  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 121;
                    end
                end
        10'd122  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd123  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd124  :   begin                        
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 124;
                    end
                end
                //End p1p1_to_p3(u, t)

//==============================

      
                //begin //ge_p3_to_cached(&Ai[2]], u); :1070
        10'd125   :   begin  
                       addra <= `MM_u_Y;
                       addrb <= `MM_u_X;
                   end
        10'd126   :   begin
                       addra <= `MM_u_Z;
                   end
        10'd127   :   begin
                       //Store cy3
                       addra <= `MM_Ai_YplusX(2);
                       wea <= 1;
                       dina <= add_res;
                       addrb <= `MM_Ai_YminusX(2);
                       web <= 1;
                       dinb <= sub_res;
                   end
        10'd128   :   begin
                       dina <= douta;
                       addra <= `MM_Ai_Z(2);
                       wea <= 1;
                   end
        10'd129   :   begin
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd130   :   begin
                       mul_en <= 1;
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd131   :   begin
                       if (mul_done)
                       begin
                           addra <= `MM_Ai_T2d(2);
                           wea <= 1'b1;
                           dina <= mul_res;
                       end else
                       begin
                           addra <= `MM_u_T;
                           addrb <= `MM_d2;
                           state <= 131;
                       end;
                   end
                   //end ge p3 to cached


                  //Begin GE ADD tag3
        10'd132  :   begin
                        addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                        addrb <= `MM_A2_X;
                    end
        10'd133  :   begin
                        //stall
                    end
        10'd134  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd135  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(2);
                    end
        10'd136  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(2);
                        mul_en <= 1;
                    end
        10'd137  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(2);
                           state <= 137;
                        end
                    end
        10'd138  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(2);
                    end
        10'd139  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(2);
                        mul_en <= 1;
                    end
        10'd140  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(2);
                           state <= 140;
                        end 
                    end
        10'd141 :   begin
                        addra <= `MM_Ai_T2d(2); //fe_mul(t_T, Ai[0].T2d, A2_T);
                        addrb <= `MM_A2_T;
                    end
        10'd142 :   begin
                        addra <= `MM_Ai_T2d(2);
                        addrb <= `MM_A2_T;
                        mul_en <= 1;
                    end
        10'd143 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(2);
                           addrb <= `MM_A2_T;
                           state <= 143;
                        end    
                    end
        10'd144 :   begin
                        addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(2);
                    end
        10'd145  :   begin
                        addra <= `MM_A2_Z;
                        addrb <= `MM_Ai_Z(2);
                        mul_en <= 1;
                    end
        10'd146 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_A2_Z;
                           addrb <= `MM_Ai_Z(2);
                           state <= 146;
                        end    
                    end
        10'd147  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd148  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd149  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd150  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd151  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd152  :   begin
                        //stall
                    end
        10'd153  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD  

                //Begin p1p1_to_p3
        10'd154 :   begin 
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd155  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd156  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 156;
                    end
                end
        10'd157  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd158  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd159  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 159;
                    end 
                end
        10'd160  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd161  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd162  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 162;
                    end
                end
        10'd163  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd164  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd165  :   begin                        
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 165;
                    end
                end
                //End p1p1_to_p3(u, t)

//====================


      
                //begin //ge_p3_to_cached(&Ai[3]], u); :1070
        10'd166   :   begin  
                       addra <= `MM_u_Y;
                       addrb <= `MM_u_X;
                   end
        10'd167   :   begin
                       addra <= `MM_u_Z;
                   end
        10'd168   :   begin
                       //Store cy3
                       addra <= `MM_Ai_YplusX(3);
                       wea <= 1;
                       dina <= add_res;
                       addrb <= `MM_Ai_YminusX(3);
                       web <= 1;
                       dinb <= sub_res;
                   end
        10'd169   :   begin
                       dina <= douta;
                       addra <= `MM_Ai_Z(3);
                       wea <= 1;
                   end
        10'd170   :   begin
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd171   :   begin
                       mul_en <= 1;
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd172   :   begin
                       if (mul_done)
                       begin
                           addra <= `MM_Ai_T2d(3);
                           wea <= 1'b1;
                           dina <= mul_res;
                       end else
                       begin
                           addra <= `MM_u_T;
                           addrb <= `MM_d2;
                           state <= 172;
                       end;
                   end
                   //end ge p3 to cached


                  //Begin GE ADD tag3
        10'd173  :   begin
                        addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                        addrb <= `MM_A2_X;
                    end
        10'd174  :   begin
                        //stall
                    end
        10'd175  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd176  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(3);
                    end
        10'd177  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(3);
                        mul_en <= 1;
                    end
        10'd178  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(3);
                           state <= 178;
                        end
                    end
        10'd179  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(3);
                    end
        10'd180  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(3);
                        mul_en <= 1;
                    end
        10'd181  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(3);
                           state <= 181;
                        end 
                    end
        10'd182 :   begin
                        addra <= `MM_Ai_T2d(3); //fe_mul(t_T, Ai[0].T2d, A2_T);
                        addrb <= `MM_A2_T;
                    end
        10'd183 :   begin
                        addra <= `MM_Ai_T2d(3);
                        addrb <= `MM_A2_T;
                        mul_en <= 1;
                    end
        10'd184 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(3);
                           addrb <= `MM_A2_T;
                           state <= 184;
                        end    
                    end
        10'd185 :   begin
                        addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(3);
                    end
        10'd186  :   begin
                        addra <= `MM_A2_Z;
                        addrb <= `MM_Ai_Z(3);
                        mul_en <= 1;
                    end
        10'd187 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_A2_Z;
                           addrb <= `MM_Ai_Z(3);
                           state <= 187;
                        end    
                    end
        10'd188  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd189  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd190  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd191  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd192  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd193  :   begin
                        //stall
                    end
        10'd194  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD  

                //Begin p1p1_to_p3
        10'd195 :   begin 
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd196  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd197  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 197;
                    end
                end
        10'd198  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd199  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd200  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 200;
                    end 
                end
        10'd201  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd202  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd203  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 203;
                    end
                end
        10'd204  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd205  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd206  :   begin                        
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 206;
                    end
                end
                //End p1p1_to_p3(u, t)
                
                
                  
                              //begin //ge_p3_to_cached(&Ai[2]], u); :1070
                      10'd207   :   begin  
                                     addra <= `MM_u_Y;
                                     addrb <= `MM_u_X;
                                 end
                      10'd208   :   begin
                                     addra <= `MM_u_Z;
                                 end
                      10'd209   :   begin
                                     //Store cy3
                                     addra <= `MM_Ai_YplusX(4);
                                     wea <= 1;
                                     dina <= add_res;
                                     addrb <= `MM_Ai_YminusX(4);
                                     web <= 1;
                                     dinb <= sub_res;
                                 end
                      10'd210   :   begin
                                     dina <= douta;
                                     addra <= `MM_Ai_Z(4);
                                     wea <= 1;
                                 end
                      10'd211   :   begin
                                     addra <= `MM_u_T;
                                     addrb <= `MM_d2;
                                 end
                      10'd212   :   begin
                                     mul_en <= 1;
                                     addra <= `MM_u_T;
                                     addrb <= `MM_d2;
                                 end
                      10'd213   :   begin
                                     if (mul_done)
                                     begin
                                         addra <= `MM_Ai_T2d(4);
                                         wea <= 1'b1;
                                         dina <= mul_res;
                                     end else
                                     begin
                                         addra <= `MM_u_T;
                                         addrb <= `MM_d2;
                                         state <= 213;
                                     end;
                                 end
                                 //end ge p3 to cached
              
              
                                //Begin GE ADD tag3
                      10'd214  :   begin
                                      addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                                      addrb <= `MM_A2_X;
                                  end
                      10'd215  :   begin
                                      //stall
                                  end
                      10'd216  :   begin
                                      addra <= `MM_t_X;
                                      wea <= 1'b1;
                                      dina <= add_res;
                                      addrb <= `MM_t_Y;
                                      web <= 1'b1;
                                      dinb <= sub_res; 
                                  end
                      10'd217  :   begin
                                      addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                                      addrb <= `MM_Ai_YplusX(4);
                                  end
                      10'd218  :   begin
                                      addra <= `MM_t_X;
                                      addrb <= `MM_Ai_YplusX(4);
                                      mul_en <= 1;
                                  end
                      10'd219  :   begin
                                      if (mul_done)
                                      begin
                                         wea <= 1'b1;
                                         addra <= `MM_t_Z;
                                         dina <= mul_res;
                                      end else
                                      begin
                                         addra <= `MM_t_X;
                                         addrb <= `MM_Ai_YplusX(4);
                                         state <= 219;
                                      end
                                  end
                      10'd220  :   begin
                                      addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                                      addrb <= `MM_Ai_YminusX(4);
                                  end
                      10'd221  :   begin
                                      addra <= `MM_t_Y;
                                      addrb <= `MM_Ai_YminusX(4);
                                      mul_en <= 1;
                                  end
                      10'd222  :   begin
                                      if (mul_done)
                                      begin
                                         wea <= 1'b1;
                                         addra <= `MM_t_Y;
                                         dina <= mul_res;
                                      end else
                                      begin
                                         addra <= `MM_t_Y;
                                         addrb <= `MM_Ai_YminusX(4);
                                         state <= 222;
                                      end 
                                  end
                      10'd223 :   begin
                                      addra <= `MM_Ai_T2d(4); //fe_mul(t_T, Ai[0].T2d, A2_T);
                                      addrb <= `MM_A2_T;
                                  end
                      10'd224 :   begin
                                      addra <= `MM_Ai_T2d(4);
                                      addrb <= `MM_A2_T;
                                      mul_en <= 1;
                                  end
                      10'd225 :   begin
                                      if (mul_done)
                                      begin
                                         wea <= 1'b1;
                                         addra <= `MM_t_T;
                                         dina <= mul_res;
                                      end else
                                      begin
                                         addra <= `MM_Ai_T2d(4);
                                         addrb <= `MM_A2_T;
                                         state <= 225;
                                      end    
                                  end
                      10'd226 :   begin
                                      addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                                      addrb <= `MM_Ai_Z(4);
                                  end
                      10'd227  :   begin
                                      addra <= `MM_A2_Z;
                                      addrb <= `MM_Ai_Z(4);
                                      mul_en <= 1;
                                  end
                      10'd228 :   begin
                                      if (mul_done)
                                      begin
                                         wea <= 1'b1;
                                         addra <= `MM_t_X;
                                         dina <= mul_res;
                                      end else
                                      begin
                                         addra <= `MM_A2_Z;
                                         addrb <= `MM_Ai_Z(4);
                                         state <= 228;
                                      end    
                                  end
                      10'd229  :   begin
                                      addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                                      addrb <= `MM_t_X;
                                  end
                      10'd230  :   begin
                                      addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                                      addrb <= `MM_t_Y;
                                  end
                      10'd231  :   begin
                                      addra <= `MM_t0;
                                      wea <= 1'b1;
                                      dina <= add_res;
                                  end                  
                      10'd232  :   begin
                                      addra <= `MM_t_X;
                                      wea <= 1'b1;
                                      dina <= sub_res;
                                      addrb <= `MM_t_Y;
                                      web <= 1'b1;
                                      dinb <= add_res;
                                  end
                      10'd233  :   begin
                                      addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                                      addrb <= `MM_t_T;
                                  end
                      10'd234  :   begin
                                      //stall
                                  end
                      10'd235  :   begin
                                      addra <= `MM_t_Z;
                                      wea <= 1'b1;
                                      dina <= add_res;
                                      addrb <= `MM_t_T;
                                      web <= 1'b1;
                                      dinb <= sub_res;
                                  end
                                  //end GE ADD  
              
                              //Begin p1p1_to_p3
                      10'd236 :   begin 
                                  addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                                  addrb <= `MM_t_T;
                              end
                      10'd237  :   begin
                                  addra <= `MM_t_X;
                                  addrb <= `MM_t_T;
                                  mul_en <= 1'b1;
                              end
                      10'd238  :   begin
                                  if (mul_done)
                                  begin
                                     wea <= 1'b1;
                                     addra <= `MM_u_X;
                                     dina <= mul_res;
                                  end else
                                  begin
                                     addra <= `MM_t_X;
                                     addrb <= `MM_t_T;
                                     state <= 238;
                                  end
                              end
                      10'd239  :   begin
                                  addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                                  addrb <= `MM_t_Z;
                              end
                      10'd240  :   begin
                                  addra <= `MM_t_Y;
                                  addrb <= `MM_t_Z;
                                  mul_en <= 1; 
                              end
                      10'd241  :   begin
                                  if (mul_done)
                                  begin
                                     wea <= 1'b1;
                                     addra <= `MM_u_Y;
                                     dina <= mul_res;
                                  end else
                                  begin
                                     addra <= `MM_t_Y;
                                     addrb <= `MM_t_Z;
                                     state <= 241;
                                  end 
                              end
                      10'd242  :   begin
                                  addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                                  addrb <= `MM_t_T;
                              end
                      10'd243  :   begin
                                  addra <= `MM_t_Z;
                                  addrb <= `MM_t_T;
                                  mul_en <= 1;
                              end
                      10'd244  :   begin
                                  if (mul_done)
                                  begin
                                     wea <= 1'b1;
                                     addra <= `MM_u_Z;
                                     dina <= mul_res;
                                  end else
                                  begin
                                     addra <= `MM_t_Z;
                                     addrb <= `MM_t_T;
                                     state <= 244;
                                  end
                              end
                      10'd245  :   begin
                                  addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                                  addrb <= `MM_t_Y;
                              end
                      10'd246  :   begin
                                  addra <= `MM_t_X;
                                  addrb <= `MM_t_Y;
                                  mul_en <= 1;
                              end
                      10'd247  :   begin                        
                                  if (mul_done)
                                  begin
                                     wea <= 1'b1;
                                     addra <= `MM_u_T;
                                     dina <= mul_res;
                                  end else
                                  begin
                                     addra <= `MM_t_X;
                                     addrb <= `MM_t_Y;
                                     state <= 247;
                                  end
                              end
                              //End p1p1_to_p3(u, t)
              
              //====================
              
              
                    
              //begin //ge_p3_to_cached(&Ai[3]], u); :1070
      10'd248   :   begin  
                     addra <= `MM_u_Y;
                     addrb <= `MM_u_X;
                 end
      10'd249   :   begin
                     addra <= `MM_u_Z;
                 end
      10'd250   :   begin
                     //Store cy3
                     addra <= `MM_Ai_YplusX(5);
                     wea <= 1;
                     dina <= add_res;
                     addrb <= `MM_Ai_YminusX(5);
                     web <= 1;
                     dinb <= sub_res;
                 end
      10'd251   :   begin
                     dina <= douta;
                     addra <= `MM_Ai_Z(5);
                     wea <= 1;
                 end
      10'd252   :   begin
                     addra <= `MM_u_T;
                     addrb <= `MM_d2;
                 end
      10'd253   :   begin
                     mul_en <= 1;
                     addra <= `MM_u_T;
                     addrb <= `MM_d2;
                 end
      10'd254   :   begin
                     if (mul_done)
                     begin
                         addra <= `MM_Ai_T2d(5);
                         wea <= 1'b1;
                         dina <= mul_res;
                     end else
                     begin
                         addra <= `MM_u_T;
                         addrb <= `MM_d2;
                         state <= 254;
                     end;
                 end
                 //end ge p3 to cached


                //Begin GE ADD tag3
      10'd255  :   begin
                      addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                      addrb <= `MM_A2_X;
                  end
      10'd256  :   begin
                      //stall
                  end
      10'd257  :   begin
                      addra <= `MM_t_X;
                      wea <= 1'b1;
                      dina <= add_res;
                      addrb <= `MM_t_Y;
                      web <= 1'b1;
                      dinb <= sub_res; 
                  end
      10'd258  :   begin
                      addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                      addrb <= `MM_Ai_YplusX(5);
                  end
      10'd259  :   begin
                      addra <= `MM_t_X;
                      addrb <= `MM_Ai_YplusX(5);
                      mul_en <= 1;
                  end
      10'd260  :   begin
                      if (mul_done)
                      begin
                         wea <= 1'b1;
                         addra <= `MM_t_Z;
                         dina <= mul_res;
                      end else
                      begin
                         addra <= `MM_t_X;
                         addrb <= `MM_Ai_YplusX(5);
                         state <= 260;
                      end
                  end
      10'd261  :   begin
                      addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                      addrb <= `MM_Ai_YminusX(5);
                  end
      10'd262  :   begin
                      addra <= `MM_t_Y;
                      addrb <= `MM_Ai_YminusX(5);
                      mul_en <= 1;
                  end
      10'd263  :   begin
                      if (mul_done)
                      begin
                         wea <= 1'b1;
                         addra <= `MM_t_Y;
                         dina <= mul_res;
                      end else
                      begin
                         addra <= `MM_t_Y;
                         addrb <= `MM_Ai_YminusX(5);
                         state <= 263;
                      end 
                  end
      10'd264 :   begin
                      addra <= `MM_Ai_T2d(5); //fe_mul(t_T, Ai[0].T2d, A2_T);
                      addrb <= `MM_A2_T;
                  end
      10'd265 :   begin
                      addra <= `MM_Ai_T2d(5);
                      addrb <= `MM_A2_T;
                      mul_en <= 1;
                  end
      10'd266 :   begin
                      if (mul_done)
                      begin
                         wea <= 1'b1;
                         addra <= `MM_t_T;
                         dina <= mul_res;
                      end else
                      begin
                         addra <= `MM_Ai_T2d(5);
                         addrb <= `MM_A2_T;
                         state <= 266;
                      end    
                  end
      10'd267 :   begin
                      addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                      addrb <= `MM_Ai_Z(5);
                  end
      10'd268  :   begin
                      addra <= `MM_A2_Z;
                      addrb <= `MM_Ai_Z(5);
                      mul_en <= 1;
                  end
      10'd269 :   begin
                      if (mul_done)
                      begin
                         wea <= 1'b1;
                         addra <= `MM_t_X;
                         dina <= mul_res;
                      end else
                      begin
                         addra <= `MM_A2_Z;
                         addrb <= `MM_Ai_Z(5);
                         state <= 269;
                      end    
                  end
      10'd270  :   begin
                      addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                      addrb <= `MM_t_X;
                  end
      10'd271  :   begin
                      addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                      addrb <= `MM_t_Y;
                  end
      10'd272  :   begin
                      addra <= `MM_t0;
                      wea <= 1'b1;
                      dina <= add_res;
                  end                  
      10'd273  :   begin
                      addra <= `MM_t_X;
                      wea <= 1'b1;
                      dina <= sub_res;
                      addrb <= `MM_t_Y;
                      web <= 1'b1;
                      dinb <= add_res;
                  end
      10'd274  :   begin
                      addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                      addrb <= `MM_t_T;
                  end
      10'd275  :   begin
                      //stall
                  end
      10'd276  :   begin
                      addra <= `MM_t_Z;
                      wea <= 1'b1;
                      dina <= add_res;
                      addrb <= `MM_t_T;
                      web <= 1'b1;
                      dinb <= sub_res;
                  end
                  //end GE ADD  

              //Begin p1p1_to_p3
      10'd277 :   begin 
                  addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                  addrb <= `MM_t_T;
              end
      10'd278  :   begin
                  addra <= `MM_t_X;
                  addrb <= `MM_t_T;
                  mul_en <= 1'b1;
              end
      10'd279  :   begin
                  if (mul_done)
                  begin
                     wea <= 1'b1;
                     addra <= `MM_u_X;
                     dina <= mul_res;
                  end else
                  begin
                     addra <= `MM_t_X;
                     addrb <= `MM_t_T;
                     state <= 279;
                  end
              end
      10'd280  :   begin
                  addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                  addrb <= `MM_t_Z;
              end
      10'd281  :   begin
                  addra <= `MM_t_Y;
                  addrb <= `MM_t_Z;
                  mul_en <= 1; 
              end
      10'd282  :   begin
                  if (mul_done)
                  begin
                     wea <= 1'b1;
                     addra <= `MM_u_Y;
                     dina <= mul_res;
                  end else
                  begin
                     addra <= `MM_t_Y;
                     addrb <= `MM_t_Z;
                     state <= 282;
                  end 
              end
      10'd283  :   begin
                  addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                  addrb <= `MM_t_T;
              end
      10'd284  :   begin
                  addra <= `MM_t_Z;
                  addrb <= `MM_t_T;
                  mul_en <= 1;
              end
      10'd285  :   begin
                  if (mul_done)
                  begin
                     wea <= 1'b1;
                     addra <= `MM_u_Z;
                     dina <= mul_res;
                  end else
                  begin
                     addra <= `MM_t_Z;
                     addrb <= `MM_t_T;
                     state <= 285;
                  end
              end
      10'd286  :   begin
                  addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                  addrb <= `MM_t_Y;
              end
      10'd287  :   begin
                  addra <= `MM_t_X;
                  addrb <= `MM_t_Y;
                  mul_en <= 1;
              end
      10'd288  :   begin                        
                  if (mul_done)
                  begin
                     wea <= 1'b1;
                     addra <= `MM_u_T;
                     dina <= mul_res;
                  end else
                  begin
                     addra <= `MM_t_X;
                     addrb <= `MM_t_Y;
                     state <= 288;
                  end
              end
              //End p1p1_to_p3(u, t)

                //begin //ge_p3_to_cached(&Ai[6]], u); :1070
        10'd289   :   begin
                       addra <= `MM_u_Y;
                       addrb <= `MM_u_X;
                   end
        10'd290   :   begin
                       addra <= `MM_u_Z;
                   end
        10'd291   :   begin
                       //Store cy3
                       addra <= `MM_Ai_YplusX(6);
                       wea <= 1;
                       dina <= add_res;
                       addrb <= `MM_Ai_YminusX(6);
                       web <= 1;
                       dinb <= sub_res;
                   end
        10'd292   :   begin
                       dina <= douta;
                       addra <= `MM_Ai_Z(6);
                       wea <= 1;
                   end
        10'd293   :   begin
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd294   :   begin
                       mul_en <= 1;
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd295   :   begin
                       if (mul_done)
                       begin
                           addra <= `MM_Ai_T2d(6);
                           wea <= 1'b1;
                           dina <= mul_res;
                       end else
                       begin
                           addra <= `MM_u_T;
                           addrb <= `MM_d2;
                           state <= 295;
                       end;
                   end
                   //end ge p3 to cached


                  //Begin GE ADD tag3
        10'd296  :   begin
                        addra <= `MM_A2_Y; //fe_add(t_X, A2_Y, A2_X); fe_sub(t_Y, A2_Y, A2_X);
                        addrb <= `MM_A2_X;
                    end
        10'd297  :   begin
                        //stall
                    end
        10'd298  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd299  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(6);
                    end
        10'd300  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(6);
                        mul_en <= 1;
                    end
        10'd301  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(6);
                           state <= 301;
                        end
                    end
        10'd302  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(6);
                    end
        10'd303  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(6);
                        mul_en <= 1;
                    end
        10'd304  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(6);
                           state <= 304;
                        end 
                    end
        10'd305 :   begin
                        addra <= `MM_Ai_T2d(6); //fe_mul(t_T, Ai[0].T2d, A2_T);
                        addrb <= `MM_A2_T;
                    end
        10'd306 :   begin
                        addra <= `MM_Ai_T2d(6);
                        addrb <= `MM_A2_T;
                        mul_en <= 1;
                    end
        10'd307 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(6);
                           addrb <= `MM_A2_T;
                           state <= 307;
                        end    
                    end
        10'd308 :   begin
                        addra <= `MM_A2_Z; //fe_mul(t_X, A2_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(6);
                    end
        10'd309  :   begin
                        addra <= `MM_A2_Z;
                        addrb <= `MM_Ai_Z(6);
                        mul_en <= 1;
                    end
        10'd310 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_A2_Z;
                           addrb <= `MM_Ai_Z(6);
                           state <= 310;
                        end    
                    end
        10'd311  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd312  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd313  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd314  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd315  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd316  :   begin
                        //stall
                    end
        10'd317  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD  

                //Begin p1p1_to_p3
        10'd318 :   begin
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd319  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd320  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 320;
                    end
                end
        10'd321  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd322  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd323  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 323;
                    end 
                end
        10'd324  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd325  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd326  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 326;
                    end
                end
        10'd327  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd328  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd329  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 329;
                    end
                end
                //End p1p1_to_p3(u, t)

//====================


      
                //begin //ge_p3_to_cached(&Ai[3]], u); :1070
        10'd330   :   begin
                       addra <= `MM_u_Y;
                       addrb <= `MM_u_X;
                   end
        10'd331   :   begin
                       addra <= `MM_u_Z;
                   end
        10'd332   :   begin
                       //Store cy3
                       addra <= `MM_Ai_YplusX(7);
                       wea <= 1;
                       dina <= add_res;
                       addrb <= `MM_Ai_YminusX(7);
                       web <= 1;
                       dinb <= sub_res;
                   end
        10'd333   :   begin
                       dina <= douta;
                       addra <= `MM_Ai_Z(7);
                       wea <= 1;
                   end
        10'd334   :   begin
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd335   :   begin
                       mul_en <= 1;
                       addra <= `MM_u_T;
                       addrb <= `MM_d2;
                   end
        10'd336   :   begin
                       if (mul_done)
                       begin
                           addra <= `MM_Ai_T2d(7);
                           wea <= 1'b1;
                           dina <= mul_res;
                       end else
                       begin
                           addra <= `MM_u_T;
                           addrb <= `MM_d2;
                           state <= 336;
                       end;
                   end
                   //end ge p3 to cached

        10'd337 :   begin //fe_0(r_X) fe1(r_Y)
                        addra <= `MM_r_X;
                        addrb <= `MM_r_Y;
                        dina <= `FE_0;
                        dinb <= `FE_1;
                        wea <= 1'b1;
                        web <= 1'b1;
                    end
        10'd338 :   begin //fe_1(r_Z)
                        addra <= `MM_r_Z;
                        dina <= `FE_1;
                        wea <= 1'b1;
                        loopi <= 8'hFF;
                    end
      
 //Begin loop of death  
 
 
                  
        //Begin ge_p2_dbl(t, r)
         10'd339  :   begin
                         //fe_mul(t_X, r_X, r_X);
                         addra <= `MM_r_X;
                         addrb <= `MM_r_X;
                     end
         10'd340  :   begin
                         addra <= `MM_r_X;
                         addrb <= `MM_r_X;
                         mul_en <= 1; 
                     end
         10'd341  :   begin
                         if (mul_done)
                         begin
                            $display("loop %d r_X %h", loopi, douta);
                            wea <= 1'b1;
                            addra <= `MM_t_X;
                            dina <= mul_res;
                         end else
                         begin
                            addra <= `MM_r_X;
                            addrb <= `MM_r_X;
                            state <= 341;
                         end
                     end
         10'd342  :   begin
                         addra <= `MM_r_Y;   //fe_mul(t_Z, r_Y, r_Y);
                         addrb <= `MM_r_Y; 
                     end
         10'd343  :   begin
                         addra <= `MM_r_Y;
                         addrb <= `MM_r_Y; 
                         mul_en <= 1;
                     end
         10'd344  :   begin
                         if (mul_done)
                         begin
                            $display("loop %d r_Y %h", loopi, douta);
                            wea <= 1'b1;
                            addra <= `MM_t_Z;
                            dina <= mul_res;
                         end else
                         begin
                            addra <= `MM_r_Y;
                            addrb <= `MM_r_Y;
                            state <= 344;
                         end
                     end
         10'd345  :   begin
                         addra <= `MM_n2; //fe_mul(tmp, n2, r_Z);
                         addrb <= `MM_r_Z; 
                     end
         10'd346  :   begin
                         addra <= `MM_n2;  
                         addrb <= `MM_r_Z;
                         mul_en <= 1;
                     end
         10'd347  :   begin
                         if (mul_done)
                         begin
                            $display("loop %d r_Z %h", loopi, doutb);
                            wea <= 1'b1;
                            addra <= `MM_tmp;
                            dina <= mul_res;
                         end else
                         begin
                            addra <= `MM_n2;
                            addrb <= `MM_r_Z;
                            state <= 347;
                         end  
                     end
         10'd348  :   begin
                         addra <= `MM_r_Z; //fe_mul(t_T, r_Z, tmp);
                         addrb <= `MM_tmp; 
                     end
         10'd349  :   begin
                         addra <= `MM_r_Z;
                         addrb <= `MM_tmp;
                         mul_en <= 1;  
                     end
         10'd350  :   begin
                         if (mul_done)
                         begin
                            wea <= 1'b1;
                            addra <= `MM_t_T;
                            dina <= mul_res;
                         end else
                         begin
                            addra <= `MM_r_Z;
                            addrb <= `MM_tmp;
                            state <= 350;
                         end 
                     end
         10'd351  :   begin
                         addra <= `MM_r_X;
                         addrb <= `MM_r_Y; 
                     end
         10'd352  :   begin
                         //stall
                     end
         10'd353  :   begin
                         addra <= `MM_t_Y;
                         dina <= add_res;
                         wea <= 1;
                     end
         10'd354  :   begin
                         addra <= `MM_t_Y; //fe_mul(t0, t_Y, t_Y);
                         addrb <= `MM_t_Y;
                     end
         10'd355  :   begin
                         addra <= `MM_t_Y;
                         addrb <= `MM_t_Y;
                         mul_en <= 1; 
                     end
         10'd356  :   begin
                         if (mul_done)
                         begin
                            wea <= 1'b1;
                            addra <= `MM_t0;
                            dina <= mul_res;
                         end else
                         begin
                            addra <= `MM_t_Y;
                            addrb <= `MM_t_Y;
                            state <= 356;
                         end 
                     end
         10'd357  :   begin
                         addra <= `MM_t_Z; //fe_add(t_Y, t_Z, t_X); fe_sub(t_Z, t_Z, t_X);
                         addrb <= `MM_t_X;
                     end
         10'd358  :   begin
                         //stall
                     end
         10'd359  :   begin
                         addra <= `MM_t_Y;
                         wea <= 1'b1;
                         dina <= add_res;
                         addrb <= `MM_t_Z;
                         web <= 1'b1;
                         dinb <= sub_res; 
                     end
         10'd360  :   begin           
                         addra <= `MM_t0; //fe_sub(t_X, t0, t_Y);
                         addrb <= `MM_t_Y;
                     end
         10'd361  :   begin
                         addra <= `MM_t_T; //fe_sub(t_T, t_T, t_Z);
                         addrb <= `MM_t_Z; 
                     end
         10'd362  :   begin
                         addra <= `MM_t_X;
                         wea <= 1'b1;
                         dina <= sub_res;
                     end
         10'd363  :   begin
                         addra <= `MM_t_T;
                         wea <= 1'b1;
                         dina <= sub_res;
                     end
                     //End ge_p2_dbl
   //////begin aslide if                 
        10'd364 :   begin
                        if (a[loopi] == 1'b0)
                        begin
                            state <= 10'd399;
                        end else begin
                            $display("ASLIDE");
                        end
                    end
                    
//Begin p1p1_to_p3
        10'd365 :   begin
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                end
        10'd366  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd367  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 367;
                    end
                end
        10'd368  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd369  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd370  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 370;
                    end 
                end
        10'd371  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd372  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd373  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_Z;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 373;
                    end
                end
        10'd374  :   begin
                    addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                    addrb <= `MM_t_Y;
                end
        10'd375  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_Y;
                    mul_en <= 1;
                end
        10'd376  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_u_T;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_Y;
                       state <= 376;
                    end
                end
                //End p1p1_to_p3(u, t)
               
        //Begin GE ADD ge_add(&t, &u, &Ai[idx]);
        10'd377  :   begin
                        addra <= `MM_u_Y; //fe_add(t_X, u_Y, u_X); fe_sub(t_Y, u_Y, u_X);
                        addrb <= `MM_u_X;
                    end
        10'd378  :   begin
                        //stall
                    end
        10'd379  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res; 
                    end
        10'd380  :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Ai[0].YplusX);
                        addrb <= `MM_Ai_YplusX(0);
                    end
        10'd381  :   begin
                        addra <= `MM_t_X;
                        addrb <= `MM_Ai_YplusX(0);
                        mul_en <= 1;
                    end
        10'd382  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X;
                           addrb <= `MM_Ai_YplusX(0);
                           state <= 382;
                        end
                    end
        10'd383  :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Ai[0].YminusX);
                        addrb <= `MM_Ai_YminusX(0);
                    end
        10'd384  :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Ai_YminusX(0);
                        mul_en <= 1;
                    end
        10'd385  :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Ai_YminusX(0);
                           state <= 385;
                        end 
                    end
        10'd386 :   begin
                        addra <= `MM_Ai_T2d(0); //fe_mul(t_T, Ai[0].T2d, u_T);
                        addrb <= `MM_u_T;
                    end
        10'd387 :   begin
                        addra <= `MM_Ai_T2d(0);
                        addrb <= `MM_u_T;
                        mul_en <= 1;
                    end
        10'd388 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Ai_T2d(0);
                           addrb <= `MM_u_T;
                           state <= 388;
                        end    
                    end
        10'd389 :   begin
                        addra <= `MM_u_Z; //fe_mul(t_X, u_Z, Ai[0].Z);
                        addrb <= `MM_Ai_Z(0);
                    end
        10'd390  :   begin
                        addra <= `MM_u_Z;
                        addrb <= `MM_Ai_Z(0);
                        mul_en <= 1;
                    end
        10'd391 :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_X;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_u_Z;
                           addrb <= `MM_Ai_Z(0);
                           state <= 391;
                        end    
                    end
        10'd392  :   begin
                        addra <= `MM_t_X; //fe_add(t0, t_X, t_X);
                        addrb <= `MM_t_X;
                    end
        10'd393  :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd394  :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end                  
        10'd395  :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                        
                    end
        10'd396  :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd397  :   begin
                        //stall
                    end
        10'd398  :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //end GE ADD   
                    //end if aslide block
  //check line------------------------                  
                //begin if bslide block
        10'd399  :   begin
                        if (b[loopi] == 1'b0)
                        begin
                            state <= 10'd431;
                        end else begin
                            $display("BSLIDE %d",loopi);
                        end
                     end
                     
            //Begin p1p1_to_p3
         10'd400 :   begin
                     addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                     addrb <= `MM_t_T;
                 end
         10'd401  :   begin
                     addra <= `MM_t_X;
                     addrb <= `MM_t_T;
                     mul_en <= 1'b1;
                 end
         10'd402  :   begin
                     if (mul_done)
                     begin
                        wea <= 1'b1;
                        addra <= `MM_u_X;
                        dina <= mul_res;
                     end else
                     begin
                        addra <= `MM_t_X;
                        addrb <= `MM_t_T;
                        state <= 402;
                     end
                 end
         10'd403  :   begin
                     addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                     addrb <= `MM_t_Z;
                 end
         10'd404  :   begin
                     addra <= `MM_t_Y;
                     addrb <= `MM_t_Z;
                     mul_en <= 1; 
                 end
         10'd405  :   begin
                     if (mul_done)
                     begin
                        wea <= 1'b1;
                        addra <= `MM_u_Y;
                        dina <= mul_res;
                     end else
                     begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_t_Z;
                        state <= 405;
                     end 
                 end
         10'd406  :   begin
                     addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                     addrb <= `MM_t_T;
                 end
         10'd407  :   begin
                     addra <= `MM_t_Z;
                     addrb <= `MM_t_T;
                     mul_en <= 1;
                 end
         10'd408  :   begin
                     if (mul_done)
                     begin
                        wea <= 1'b1;
                        addra <= `MM_u_Z;
                        dina <= mul_res;
                     end else
                     begin
                        addra <= `MM_t_Z;
                        addrb <= `MM_t_T;
                        state <= 408;
                     end
                 end
         10'd409  :   begin
                     addra <= `MM_t_X; //fe_mul(u_T, t_X, t_Y);
                     addrb <= `MM_t_Y;
                 end
         10'd410  :   begin
                     addra <= `MM_t_X;
                     addrb <= `MM_t_Y;
                     mul_en <= 1;
                 end
         10'd411  :   begin
                     if (mul_done)
                     begin
                        wea <= 1'b1;
                        addra <= `MM_u_T;
                        dina <= mul_res;
                     end else
                     begin
                        addra <= `MM_t_X;
                        addrb <= `MM_t_Y;
                        state <= 411;
                     end
                 end
                 //End p1p1_to_p3(u, t)  
        
                //begin ge_madd
        10'd412 :   begin
                        addra <= `MM_u_Y; //fe_add(t_X, u_Y, u_X); fe_sub(t_Y, u_Y, u_X);
                        addrb <= `MM_u_X;
                    end
        10'd413 :   begin
                        //stall
                    end
        10'd414 :   begin
                        addra <= `MM_t_X;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    
        10'd415   :   begin
                        addra <= `MM_t_X; //fe_mul(t_Z, t_X, Bi[idx].yplusx);
                        addrb <= `MM_Bi_YplusX(0);
                    end
        10'd416   :   begin
                        addra <= `MM_t_X; 
                        addrb <= `MM_Bi_YplusX(0);;
                        mul_en <= 1;
                    end
        10'd417   :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Z; 
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_X; 
                           addrb <= `MM_Bi_YplusX(0);
                           state <= 417;
                        end    
                    end
        10'd418 :   begin
                        addra <= `MM_t_Y; //fe_mul(t_Y, t_Y, Bi[idx].yminusx);
                        addrb <= `MM_Bi_YminusX(0);
                    end
        10'd419 :   begin
                        addra <= `MM_t_Y;
                        addrb <= `MM_Bi_YminusX(0);
                        mul_en <= 1;
                    end
        10'd420   :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_Y;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_t_Y;
                           addrb <= `MM_Bi_YminusX(0);
                           state <= 10'd420;
                        end    
                    end
        10'd421   :   begin
                        addra <= `MM_Bi_XY2d(0); //fe_mul(t_T, Bi[idx].xy2d, u_T);
                        addrb <= `MM_u_T;
                    end
        10'd422   :   begin
                        addra <= `MM_Bi_XY2d(0);
                        addrb <= `MM_u_T;
                        mul_en <= 1;
                    end
        10'd423   :   begin
                        if (mul_done)
                        begin
                           wea <= 1'b1;
                           addra <= `MM_t_T;
                           dina <= mul_res;
                        end else
                        begin
                           addra <= `MM_Bi_XY2d(0);
                           addrb <= `MM_u_T;
                           state <= 423;
                        end    
                    end
        10'd424 :   begin
                        addra <= `MM_u_Z; //fe_add(t0, u_Z, u_Z);
                        addrb <= `MM_u_Z;
                    end
        10'd425 :   begin
                        addra <= `MM_t_Z; //fe_sub(t_X, t_Z, t_Y); fe_add(t_Y, t_Z, t_Y);
                        addrb <= `MM_t_Y;
                    end
        10'd426 :   begin
                        addra <= `MM_t0;
                        wea <= 1'b1;
                        dina <= add_res;
                    end
        10'd427 :   begin
                        addra <= `MM_t_X; 
                        wea <= 1'b1;
                        dina <= sub_res;
                        addrb <= `MM_t_Y;
                        web <= 1'b1;
                        dinb <= add_res;
                    end
        10'd428 :   begin
                        addra <= `MM_t0; //fe_add(t_Z, t0, t_T); fe_sub(t_T, t0, t_T);
                        addrb <= `MM_t_T;
                    end
        10'd429 :   begin
                        //stall
                    end
        10'd430 :   begin
                        addra <= `MM_t_Z;
                        wea <= 1'b1;
                        dina <= add_res;
                        addrb <= `MM_t_T;
                        web <= 1'b1;
                        dinb <= sub_res;
                    end
                    //Done ge_madd
                    
                    //END BSLIDE
        10'd431 : begin
                        //Begin p1p1_to_p2
                    addra <= `MM_t_X; //fe_mul(u_X, t_X, t_T);
                    addrb <= `MM_t_T;
                  end  
                    //Begin p1p1_to_p2
        10'd432  :   begin
                    addra <= `MM_t_X;
                    addrb <= `MM_t_T;
                    mul_en <= 1'b1;
                end
        10'd433  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_r_X;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_X;
                       addrb <= `MM_t_T;
                       state <= 433;
                    end
                end
        10'd434  :   begin
                    addra <= `MM_t_Y; //fe_mul(u_Y, t_Y, t_Z);
                    addrb <= `MM_t_Z;
                end
        10'd435  :   begin
                    addra <= `MM_t_Y;
                    addrb <= `MM_t_Z;
                    mul_en <= 1; 
                end
        10'd436  :   begin
                    if (mul_done)
                    begin
                       wea <= 1'b1;
                       addra <= `MM_r_Y;
                       dina <= mul_res;
                    end else
                    begin
                       addra <= `MM_t_Y;
                       addrb <= `MM_t_Z;
                       state <= 436;
                    end 
                end
        10'd437  :   begin
                    addra <= `MM_t_Z; //fe_mul(u_Z, t_Z, t_T);
                    addrb <= `MM_t_T;
                end
        10'd438  :   begin
                    addra <= `MM_t_Z;
                    addrb <= `MM_t_T;
                    mul_en <= 1;
                end
        10'd439  :   begin
                    if (mul_done)
                    begin
                       web <= 1'b1;
                       addrb <= `MM_r_Z;
                       dinb <= mul_res;

                    end else
                    begin
                       addra <= `MM_t_Z;
                       addrb <= `MM_t_T;
                       state <= 439;
                    end
                end
                //End p1p1_to_p2(r, t)
                 
                //loop header
        10'd440:   begin
                    if (loopi > 0)
                    begin
                        loopi <= loopi - 1;
                        state <= 10'd339;
                        $display("loop %d",loopi);
                    end else begin
                           //begin fe invert
                           addra <= `MM_r_Z;
                           fei_en <= 1'b1; //assign multiplier to FEI
                    end
                end
                
                       //end loop of death
                        
    //end loop
    //===============BEGIN TOBYTES                                

       
                    
                    //BEGIN
        10'd441 : begin
                        //fe_invert(t0, r_Z)
                        addra <= `MM_r_Z;
                        fei_en <= 1'b1; //assign multiplier to FEI
                    end
                    //END
        10'd442 :   begin
                        addra <= `MM_r_Z;
                        fei_valid <= 1'b1;
                        fei_en <= 1'b1; //assign multiplier to FEI
                        //stall
                    end
        10'd443 :   begin
                        if (fei_done)
                        begin
                            addra <= `MM_t0;
                            dina <= fe_out;
                            $display("fei output %h",fe_out);
                            wea <= 1'b1;
                        end else
                        begin
                            addra <= `MM_r_Z;
                            state <= 443;
                            fei_en <= 1'b1; //assign multiplier to FEI
                        end
                    end
        10'd444 :   begin
                        addra <= `MM_r_X; //fe_mul(t_X, r_X, t0);
                        addrb <= `MM_t0;
                    end
        10'd445 :   begin
                        addra <= `MM_r_X; //fe_mul(t_X, r_X, t0);
                        addrb <= `MM_t0;
                        mul_en <= 1'b1;
                    end
        10'd446 :   begin
                        if (mul_done)
                        begin
                           rtmp_X <= mul_res;
                           addra <= `MM_r_Y; //fe_mul(t_Y, r_Y, t0);
                           addrb <= `MM_t0;
                        end else
                        begin
                           addra <= `MM_r_X;
                           addrb <= `MM_t0;
                           state <= 446;
                        end
                    end
        10'd447 :   begin
                        addra <= `MM_r_Y;
                        addrb <= `MM_t0;
                        mul_en <= 1'b1;
                    end
        10'd448 :   begin
                        if (mul_done)
                        begin
                           rtmp_Y <= mul_res;
                        end else
                        begin
                           addra <= `MM_r_Y;
                           addrb <= `MM_t0;
                           state <= 448;
                        end
                    end
                    //fe_tobytes is a long combinatorial chain. stall while it propogates
        10'd449 :   begin
                        tobytes_in <= rtmp_X;
                        tobytes_valid <= 1;
                    end
        10'd450 :   begin
                        if (tobytes_done)
                        begin
                            rtmpXbytes <= tobytes_res;
                            tobytes_in <= rtmp_Y;
                            tobytes_valid <= 1;
                        end
                        else
                        begin
                            state <= 450;
                        end
                     end     
        10'd451 :   begin
                        if (tobytes_done)
                        begin
                            rtmpYbytes <= tobytes_res;
                        end
                        else
                        begin
                            state <= 451;
                        end
                    end
        10'd452 :   begin
                        rrge_bytes[254:0] <= rtmpYbytes[254:0];
                        rrge_bytes[255] <= rtmpYbytes[255] ^ rtmpXbytes[0];
                    end
        10'd453 :   begin
                        rge_bytes <= rrge_bytes;
                        rdone <= 1'b1;
                        state <= 10'd0;
                    end
        default: state <= 0;
        /*10'd499 :   begin
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        10'd496 :   begin
                        $display("3: %h", douta);
                        $display("4: %h", doutb);
                    end
        10'd497 :   begin
                        $display("5: %h", douta);
                        $display("6: %h", doutb);
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        10'd498 :   begin
                    end
        10'd499 :   begin
                    end
        */
        endcase
    end
end  
endmodule








































