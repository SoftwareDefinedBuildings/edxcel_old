 module ge_frombytes_negate_vartime(
    input wire [255:0] s,
    output wire [319:0] h_x,
    output wire [319:0] h_y,
    output wire [319:0] h_z,
    output wire [319:0] h_t,
    output wire error,
    input wire clk,
    input wire rst,
    input wire valid,
    output wire done,

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
    input wire [319:0]  sub_res
);

`include "../fe/fe_common.v"

reg [319:0] pow_in;
reg pow_valid;
wire [319:0] pow_res;
wire pow_done;
wire [319:0] pow_mul_op_a;
wire [319:0] pow_mul_op_b;
wire pow_mul_valid;
fe_pow22523 POW(
   .z(pow_in),
   .out(pow_res),
   .clk(clk),
   .rst(rst),
   .valid(pow_valid),
   .done(pow_done),

    //Resources
   .pmul_in1(pow_mul_op_a),
   .pmul_in2(pow_mul_op_b),
   .pmul_valid(pow_mul_valid),
   .mul_res(mul_res),
   .mul_done(mul_done)
   );

reg [319:0] self_mul_in1;
reg [319:0] self_mul_in2;
reg self_mul_valid;

reg pow_en;
assign mul_valid = self_mul_valid | pow_mul_valid;
assign mul_op_a = pow_en ? pow_mul_op_a : self_mul_in1;
assign mul_op_b = pow_en ? pow_mul_op_b : self_mul_in2;

 
reg [5:0] state;

reg [319:0] u;
reg [319:0] v;
reg [319:0] v3;
reg [319:0] vxx;
reg [319:0] check;

reg [319:0] rh_x;
reg [319:0] rh_y;
reg [319:0] rh_z;
reg [319:0] rh_t;
assign h_x = rh_x;
assign h_y = rh_y;
assign h_z = rh_z;
assign h_t = rh_t;

reg rerror;
assign error = rerror;

reg rdone;
assign done = rdone;


reg [255:0] frombytes_in;
wire [319:0] frombytes_res;
reg frombytes_valid;
wire frombytes_done;
fe_frombytes FROMBYTES(
.in(frombytes_in),
.out(frombytes_res),
.clk(clk),
.rst(rst),
.valid(frombytes_valid),
.done(frombytes_done)
   );
   

reg [255:0] tobytes_in;
wire [319:0] tobytes_res;
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


reg [319:0] add_in1;
reg [319:0] add_in2;
reg [319:0] sub_in1;
reg [319:0] sub_in2;
assign add_op_a = add_in1;
assign add_op_b = add_in2;
assign sub_op_a = sub_in1;
assign sub_op_b = sub_in2;

reg [319:0] neg_in;
reg [319:0] neg_res;
always @ (*)
begin
    neg_res = fe_neg(neg_in);
end

reg if1;
reg if2;

always @ (posedge clk)
begin
   if (rst == 1'b0)
   begin
       state <= 0;
   end
   else 
   begin
       rdone <= 0;
       state <= state + 1;
       frombytes_valid <= 0;
       tobytes_valid <= 0;
       self_mul_valid <= 0;
       pow_valid <= 0;
       pow_en <= 0;
       case (state)
           6'd0 :  begin
                       if (valid == 1'b1)
                       begin
                           // fe_frombytes(h->Y, s);
                           frombytes_in <= s;
                           frombytes_valid <= 1;
                           // fe_1(h->Z);
                           rh_z <= 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000001;
                       end
                       else
                       begin
                           state <= 0;
                       end
                   end
           6'd1 :  begin
                        if (frombytes_done)
                        begin
                            rh_y <= frombytes_res;
                            // fe_mul(u, h->Y, h->Y);
                            self_mul_in1 <= frombytes_res;
                            self_mul_in2 <= frombytes_res;
                            self_mul_valid <= 1;
                        end
                        else
                        begin
                            state <= 1;
                        end
                   end
           6'd2 :  begin
                       if (mul_done)
                       begin
                           u <= mul_res;
                           // fe_mul(v, u, d);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= 320'hff480db4fee2b700ffce7199ffa03cbcff79e8980001c029006a0a0fff156ebd00d37285ff5978b6;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 2;
                       end
                   end
           6'd3 :  begin
                       if (mul_done)
                       begin
                           v <= mul_res;
                           // fe_sub(u, u, h->Z);
                           sub_in1 <= u;
                           sub_in2 <= rh_z;
                           // fe_add(v, v, h->Z);
                           add_in1 <= mul_res;
                           add_in2 <= rh_z;
                       end
                       else
                       begin
                           state <= 3;
                       end
                   end
           6'd4 :  begin
                         u <= sub_res;
                         v <= add_res;
                         // fe_mul(v3, v, v);
                         self_mul_in1 <= add_res;
                         self_mul_in2 <= add_res;
                         self_mul_valid <= 1;
                   end
           6'd5 :  begin
                       if (mul_done)
                       begin
                           v3 <= mul_res;
                           // fe_mul(v3, v3, v);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= v;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 5;
                       end
                   end
           6'd6 :  begin
                       if (mul_done)
                       begin
                           v3 <= mul_res;
                           // fe_mul(h->X, v3, v3);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= mul_res;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 6;
                       end
                   end
           6'd7 :  begin
                       if (mul_done)
                       begin
                           rh_x <= mul_res;
                           // fe_mul(h->X, h->X, v);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= v;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 7;
                       end
                   end
           6'd8 :  begin
                       if (mul_done)
                       begin
                           rh_x <= mul_res;
                           // fe_mul(h->X, h->X, u);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= u;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 8;
                       end
                   end
           6'd9 :  begin
                       if (mul_done)
                       begin
                           rh_x <= mul_res;
                           // fe_pow22523(h->X, h->X);
                           pow_in <= mul_res;
                           pow_valid <= 1;
                           pow_en <= 1;
                       end
                       else
                       begin
                           state <= 9;
                       end
                   end
           6'd10 :  begin
                       if (pow_done)
                       begin
                           rh_x <= pow_res;
                           // fe_mul(h->X, h->X, v3);
                           self_mul_in1 <= pow_res;
                           self_mul_in2 <= v3;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 10;
                           pow_en <= 1;
                       end
                   end
           6'd11 :  begin
                       if (mul_done)
                       begin
                           rh_x <= mul_res;
                           // fe_mul(h->X, h->X, u);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= u;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 11;
                       end
                   end
           6'd12 :  begin
                       if (mul_done)
                       begin
                           rh_x <= mul_res;
                           // fe_mul(vxx, h->X, h->X);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= mul_res;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 12;
                       end
                   end
           6'd13 :  begin
                       if (mul_done)
                       begin
                           vxx <= mul_res;
                           // fe_mul(vxx, vxx, v);
                           self_mul_in1 <= mul_res;
                           self_mul_in2 <= v;
                           self_mul_valid <= 1;
                       end
                       else
                       begin
                           state <= 13;
                       end
                   end
           6'd14 :  begin
                       if (mul_done)
                       begin
                           vxx <= mul_res;
                           // fe_sub(check, vxx, u); 
                           sub_in1 <= mul_res;
                           sub_in2 <= u;
                       end
                       else
                       begin
                           state <= 14;
                       end
                   end
           6'd15 :  begin
                         check <= sub_res;
                         if (sub_res != 320'b0)
                         begin
                            if1 <= 1'b1;
                            // fe_add(check, vxx, u);
                            add_in1 <= vxx;
                            add_in2 <= u;
                         end
                   end
           6'd16 :  begin
                         if (if1 == 1'b1)
                         begin
                             // fe_add(check, vxx, u);
                             add_in1 <= vxx;
                             add_in2 <= u;
                         end
                   end
           6'd17 :  begin
                         if (if1 == 1'b1)
                         begin
                             check <= add_res;
                             if (add_res != 320'b0)
                             begin
                                 if1 <= 0;
                                 rerror <= 1;
                                 rdone <= 1;
                                 state <= 0;
                             end
                             else
                             begin
                                 // fe_mul(h->X, h->X, sqrtm1);
                                 self_mul_in1 <= rh_x;
                                 self_mul_in2 <= 320'h00ae0c920004fc1effe1656afe804c9ffffbd7a700bd0c600035697f008f189eff86c9d3fe0ea0b0;
                                 self_mul_valid <= 1;
                             end
                         end
                   end
           6'd18 :  begin
                         if (if1 == 1'b1)
                         begin
                             if (mul_done)
                             begin
                                 rh_x <= mul_res;
                                 if1 <= 0;
                             end
                             else
                             begin
                                 state <= 18;
                             end
                         end
                   end
           6'd19 :  begin
                       tobytes_in <= rh_x;
                       tobytes_valid <= 1;
                   end
           6'd20 :  begin
                       if (tobytes_done)
                       begin
                           if ((tobytes_res[0*8 +: 8] & 1) == (s[31*8 +: 8] >> 7))
                           begin
                               if2 <= 1;
                               neg_in <= rh_x;
                           end
                       end
                       else
                       begin
                           state <= 20;
                       end
                   end
           6'd21 :  begin
                       if (if2 == 1)
                       begin
                           if2 <= 0;
                           rh_x <= neg_res;
                       end
                   end
           6'd22 :  begin
                         // fe_mul(h->T, h->X, h->Y);
                         self_mul_in1 <= rh_x;
                         self_mul_in2 <= rh_y;
                         self_mul_valid <= 1;
                   end
           6'd23 :  begin
                       if (mul_done)
                       begin
                           rh_t <= mul_res;
                           rerror <= 0;
                           rdone <= 1;
                           state <= 0;
                       end
                       else
                       begin
                           state <= 23;
                       end
                   end
             default: state <= 0;
       endcase
   end

end

endmodule