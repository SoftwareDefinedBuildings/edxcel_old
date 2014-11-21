 module fe_invert(
   input wire [319:0] z,
   output wire [319:0] out,
   input wire clk,
   input wire rst,
   input wire valid,
   output wire done,
   
    //Resources
   output wire [319:0] pmul_in1,
   output wire [319:0] pmul_in2,
   output wire pmul_valid,
   input wire [319:0] mul_res,
   input wire mul_done
);

`include "../fe/fe_common.v"

//Resources
reg [319:0] mul_in1;
reg [319:0] mul_in2;
reg mul_valid;

assign pmul_in1 = mul_in1;
assign pmul_in2 = mul_in2;
assign pmul_valid = mul_valid;
 
integer cycle;

reg [319:0] rt_0;
reg [319:0] rt_1;
reg [319:0] rt_2;
reg [319:0] rt_3;

reg [319:0] rout;
assign out = rout;

reg rdone;
assign done = rdone;

always @ (posedge clk)
begin
   if (rst == 1'b0)
   begin
       cycle <= 0;
   end
   else 
   begin
       rdone <= 0;
       cycle <= cycle + 1;
       mul_valid <= 0;
       case (cycle)
           32'd0 :  begin
                       if (valid == 1'b1)
                       begin
                           // fe_mul(t0, z, z);
                           mul_in1 <= z;
                           mul_in2 <= z;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 0;
                       end
                   end
           32'd1 :  begin
                       if (mul_done)
                       begin
                           rt_0 <= mul_res;
                           // fe_mul(t1, t0, t0);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 1;
                       end
                   end
           32'd2 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 2;
                       end
                   end
           32'd3 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, z, t1);
                           mul_in1 <= z;
                           mul_in2 <= mul_res;
                           mul_valid <= 3;
                       end
                       else
                       begin
                           cycle <= 3;
                       end
                   end
           32'd4 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t0, t0, t1);
                           mul_in1 <= rt_0;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 4;
                       end
                   end
           32'd5 :  begin
                       if (mul_done)
                       begin
                           rt_0 <= mul_res;
                           // fe_mul(t2, t0, t0);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 5;
                       end
                   end
           32'd6 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t1, t1, t2);
                           mul_in1 <= rt_1;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 6;
                       end
                   end
           32'd7 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t2, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 7;
                       end
                   end
           32'd8 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 8;
                       end
                   end
           32'd9 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 9;
                       end
                   end
           32'd10 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 10;
                       end
                   end
           32'd11 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 11;
                       end
                   end
           32'd12 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t1, t2, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_1;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 12;
                       end
                   end
           32'd13 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t2, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 13;
                       end
                   end
           32'd14 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 14;
                       end
                   end
           32'd15 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 15;
                       end
                   end
           32'd16 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 16;
                       end
                   end
           32'd17 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 17;
                       end
                   end
           32'd18 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 18;
                       end
                   end
           32'd19 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 19;
                       end
                   end
           32'd20 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 20;
                       end
                   end
           32'd21 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 21;
                       end
                   end
           32'd22 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 22;
                       end
                   end
           32'd23 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_1;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 23;
                       end
                   end
           32'd24 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t3, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 24;
                       end
                   end
           32'd25 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 25;
                       end
                   end
           32'd26 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 26;
                       end
                   end
           32'd27 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 27;
                       end
                   end
           32'd28 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 28;
                       end
                   end
           32'd29 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 29;
                       end
                   end
           32'd30 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 30;
                       end
                   end
           32'd31 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 31;
                       end
                   end
           32'd32 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 32;
                       end
                   end
           32'd33 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 33;
                       end
                   end
           32'd34 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 34;
                       end
                   end
           32'd35 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 35;
                       end
                   end
           32'd36 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 36;
                       end
                   end
           32'd37 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 37;
                       end
                   end
           32'd38 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 38;
                       end
                   end
           32'd39 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 39;
                       end
                   end
           32'd40 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 40;
                       end
                   end
           32'd41 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 41;
                       end
                   end
           32'd42 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 42;
                       end
                   end
           32'd43 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 43;
                       end
                   end
           32'd44 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t2, t3, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_2;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 44;
                       end
                   end
           32'd45 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 45;
                       end
                   end
           32'd46 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 46;
                       end
                   end
           32'd47 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 47;
                       end
                   end
           32'd48 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 48;
                       end
                   end
           32'd49 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 49;
                       end
                   end
           32'd50 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 50;
                       end
                   end
           32'd51 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 51;
                       end
                   end
           32'd52 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 52;
                       end
                   end
           32'd53 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 53;
                       end
                   end
           32'd54 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 54;
                       end
                   end
           32'd55 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t1, t2, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_1;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 55;
                       end
                   end
           32'd56 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t2, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 56;
                       end
                   end
           32'd57 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 57;
                       end
                   end
           32'd58 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 58;
                       end
                   end
           32'd59 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 59;
                       end
                   end
           32'd60 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 60;
                       end
                   end
           32'd61 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 61;
                       end
                   end
           32'd62 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 62;
                       end
                   end
           32'd63 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 63;
                       end
                   end
           32'd64 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 64;
                       end
                   end
           32'd65 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 65;
                       end
                   end
           32'd66 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 66;
                       end
                   end
           32'd67 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 67;
                       end
                   end
           32'd68 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 68;
                       end
                   end
           32'd69 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 69;
                       end
                   end
           32'd70 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 70;
                       end
                   end
           32'd71 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 71;
                       end
                   end
           32'd72 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 72;
                       end
                   end
           32'd73 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 73;
                       end
                   end
           32'd74 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 74;
                       end
                   end
           32'd75 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 75;
                       end
                   end
           32'd76 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 76;
                       end
                   end
           32'd77 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 77;
                       end
                   end
           32'd78 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 78;
                       end
                   end
           32'd79 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 79;
                       end
                   end
           32'd80 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 80;
                       end
                   end
           32'd81 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 81;
                       end
                   end
           32'd82 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 82;
                       end
                   end
           32'd83 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 83;
                       end
                   end
           32'd84 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 84;
                       end
                   end
           32'd85 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 85;
                       end
                   end
           32'd86 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 86;
                       end
                   end
           32'd87 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 87;
                       end
                   end
           32'd88 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 88;
                       end
                   end
           32'd89 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 89;
                       end
                   end
           32'd90 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 90;
                       end
                   end
           32'd91 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 91;
                       end
                   end
           32'd92 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 92;
                       end
                   end
           32'd93 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 93;
                       end
                   end
           32'd94 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 94;
                       end
                   end
           32'd95 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 95;
                       end
                   end
           32'd96 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 96;
                       end
                   end
           32'd97 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 97;
                       end
                   end
           32'd98 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 98;
                       end
                   end
           32'd99 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 99;
                       end
                   end
           32'd100 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 100;
                       end
                   end
           32'd101 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 101;
                       end
                   end
           32'd102 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 102;
                       end
                   end
           32'd103 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 103;
                       end
                   end
           32'd104 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 104;
                       end
                   end
           32'd105 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 105;
                       end
                   end
           32'd106 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_1;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 106;
                       end
                   end
           32'd107 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t3, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 107;
                       end
                   end
           32'd108 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 108;
                       end
                   end
           32'd109 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 109;
                       end
                   end
           32'd110 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 110;
                       end
                   end
           32'd111 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 111;
                       end
                   end
           32'd112 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 112;
                       end
                   end
           32'd113 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 113;
                       end
                   end
           32'd114 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 114;
                       end
                   end
           32'd115 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 115;
                       end
                   end
           32'd116 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 116;
                       end
                   end
           32'd117 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 117;
                       end
                   end
           32'd118 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 118;
                       end
                   end
           32'd119 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 119;
                       end
                   end
           32'd120 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 120;
                       end
                   end
           32'd121 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 121;
                       end
                   end
           32'd122 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 122;
                       end
                   end
           32'd123 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 123;
                       end
                   end
           32'd124 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 124;
                       end
                   end
           32'd125 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 125;
                       end
                   end
           32'd126 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 126;
                       end
                   end
           32'd127 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 127;
                       end
                   end
           32'd128 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 128;
                       end
                   end
           32'd129 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 129;
                       end
                   end
           32'd130 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 130;
                       end
                   end
           32'd131 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 131;
                       end
                   end
           32'd132 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 132;
                       end
                   end
           32'd133 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 133;
                       end
                   end
           32'd134 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 134;
                       end
                   end
           32'd135 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 135;
                       end
                   end
           32'd136 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 136;
                       end
                   end
           32'd137 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 137;
                       end
                   end
           32'd138 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 138;
                       end
                   end
           32'd139 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 139;
                       end
                   end
           32'd140 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 140;
                       end
                   end
           32'd141 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 141;
                       end
                   end
           32'd142 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 142;
                       end
                   end
           32'd143 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 143;
                       end
                   end
           32'd144 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 144;
                       end
                   end
           32'd145 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 145;
                       end
                   end
           32'd146 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 146;
                       end
                   end
           32'd147 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 147;
                       end
                   end
           32'd148 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 148;
                       end
                   end
           32'd149 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 149;
                       end
                   end
           32'd150 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 150;
                       end
                   end
           32'd151 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 151;
                       end
                   end
           32'd152 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 152;
                       end
                   end
           32'd153 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 153;
                       end
                   end
           32'd154 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 154;
                       end
                   end
           32'd155 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 155;
                       end
                   end
           32'd156 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 156;
                       end
                   end
           32'd157 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 157;
                       end
                   end
           32'd158 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 158;
                       end
                   end
           32'd159 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 159;
                       end
                   end
           32'd160 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 160;
                       end
                   end
           32'd161 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 161;
                       end
                   end
           32'd162 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 162;
                       end
                   end
           32'd163 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 163;
                       end
                   end
           32'd164 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 164;
                       end
                   end
           32'd165 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 165;
                       end
                   end
           32'd166 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 166;
                       end
                   end
           32'd167 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 167;
                       end
                   end
           32'd168 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 168;
                       end
                   end
           32'd169 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 169;
                       end
                   end
           32'd170 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 170;
                       end
                   end
           32'd171 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 171;
                       end
                   end
           32'd172 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 172;
                       end
                   end
           32'd173 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 173;
                       end
                   end
           32'd174 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 174;
                       end
                   end
           32'd175 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 175;
                       end
                   end
           32'd176 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 176;
                       end
                   end
           32'd177 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 177;
                       end
                   end
           32'd178 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 178;
                       end
                   end
           32'd179 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 179;
                       end
                   end
           32'd180 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 180;
                       end
                   end
           32'd181 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 181;
                       end
                   end
           32'd182 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 182;
                       end
                   end
           32'd183 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 183;
                       end
                   end
           32'd184 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 184;
                       end
                   end
           32'd185 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 185;
                       end
                   end
           32'd186 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 186;
                       end
                   end
           32'd187 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 187;
                       end
                   end
           32'd188 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 188;
                       end
                   end
           32'd189 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 189;
                       end
                   end
           32'd190 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 190;
                       end
                   end
           32'd191 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 191;
                       end
                   end
           32'd192 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 192;
                       end
                   end
           32'd193 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 193;
                       end
                   end
           32'd194 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 194;
                       end
                   end
           32'd195 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 195;
                       end
                   end
           32'd196 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 196;
                       end
                   end
           32'd197 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 197;
                       end
                   end
           32'd198 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 198;
                       end
                   end
           32'd199 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 199;
                       end
                   end
           32'd200 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 200;
                       end
                   end
           32'd201 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 201;
                       end
                   end
           32'd202 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 202;
                       end
                   end
           32'd203 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 203;
                       end
                   end
           32'd204 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 204;
                       end
                   end
           32'd205 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 205;
                       end
                   end
           32'd206 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t3, t3, t3);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 206;
                       end
                   end
           32'd207 :  begin
                       if (mul_done)
                       begin
                           rt_3 <= mul_res;
                           // fe_mul(t2, t3, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_2;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 207;
                       end
                   end
           32'd208 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 208;
                       end
                   end
           32'd209 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 209;
                       end
                   end
           32'd210 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 210;
                       end
                   end
           32'd211 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 211;
                       end
                   end
           32'd212 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 212;
                       end
                   end
           32'd213 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 213;
                       end
                   end
           32'd214 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 214;
                       end
                   end
           32'd215 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 215;
                       end
                   end
           32'd216 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 216;
                       end
                   end
           32'd217 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 217;
                       end
                   end
           32'd218 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 218;
                       end
                   end
           32'd219 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 219;
                       end
                   end
           32'd220 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 220;
                       end
                   end
           32'd221 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 221;
                       end
                   end
           32'd222 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 222;
                       end
                   end
           32'd223 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 223;
                       end
                   end
           32'd224 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 224;
                       end
                   end
           32'd225 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 225;
                       end
                   end
           32'd226 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 226;
                       end
                   end
           32'd227 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 227;
                       end
                   end
           32'd228 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 228;
                       end
                   end
           32'd229 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 229;
                       end
                   end
           32'd230 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 230;
                       end
                   end
           32'd231 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 231;
                       end
                   end
           32'd232 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 232;
                       end
                   end
           32'd233 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 233;
                       end
                   end
           32'd234 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 234;
                       end
                   end
           32'd235 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 235;
                       end
                   end
           32'd236 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 236;
                       end
                   end
           32'd237 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 237;
                       end
                   end
           32'd238 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 238;
                       end
                   end
           32'd239 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 239;
                       end
                   end
           32'd240 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 240;
                       end
                   end
           32'd241 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 241;
                       end
                   end
           32'd242 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 242;
                       end
                   end
           32'd243 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 243;
                       end
                   end
           32'd244 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 244;
                       end
                   end
           32'd245 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 245;
                       end
                   end
           32'd246 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 246;
                       end
                   end
           32'd247 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 247;
                       end
                   end
           32'd248 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 248;
                       end
                   end
           32'd249 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 249;
                       end
                   end
           32'd250 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 250;
                       end
                   end
           32'd251 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 251;
                       end
                   end
           32'd252 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 252;
                       end
                   end
           32'd253 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 253;
                       end
                   end
           32'd254 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 254;
                       end
                   end
           32'd255 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 255;
                       end
                   end
           32'd256 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 256;
                       end
                   end
           32'd257 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t2, t2, t2);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 257;
                       end
                   end
           32'd258 :  begin
                       if (mul_done)
                       begin
                           rt_2 <= mul_res;
                           // fe_mul(t1, t2, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_1;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 258;
                       end
                   end
           32'd259 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 259;
                       end
                   end
           32'd260 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 260;
                       end
                   end
           32'd261 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 261;
                       end
                   end
           32'd262 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 262;
                       end
                   end
           32'd263 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(t1, t1, t1);
                           mul_in1 <= mul_res;
                           mul_in2 <= mul_res;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 263;
                       end
                   end
           32'd264 :  begin
                       if (mul_done)
                       begin
                           rt_1 <= mul_res;
                           // fe_mul(out, t1, t0);
                           mul_in1 <= mul_res;
                           mul_in2 <= rt_0;
                           mul_valid <= 1;
                       end
                       else
                       begin
                           cycle <= 264;
                       end
                   end
           32'd265 :  begin
                       if (mul_done)
                       begin
                           rout <= mul_res;
                           rdone <= 1;
                           cycle <= 0;
                       end
                       else
                       begin
                           cycle <= 265;
                       end
                   end
            default: cycle <= 0;
       endcase
   end

end

endmodule