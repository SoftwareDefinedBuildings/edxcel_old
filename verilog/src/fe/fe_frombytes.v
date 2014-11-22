module fe_frombytes(
   input wire [255:0] in ,
   output wire [319:0] out,
   input wire clk,
   input wire rst,
   input wire valid,
   output wire done
);

`include "../fe/fe_common.v"

reg [7:0] state;

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

reg [319:0] rout;
assign out = rout;

reg rdone;
assign done = rdone;

always @ (posedge clk)
begin
   if (rst == 1'b0)
   begin
       rdone <= 0;
       state <= 0;
       rout <= 0;
   end
   else 
   begin
       rdone <= 0;
       state <= state + 1;
       case (state)
           8'd0 :  begin
                   if (valid == 1'b1)
                    begin
                        h0 <= load_4(in[0*8 +: 4*8]);
                        h1 <= load_3(in[4*8 +: 3*8]) << 6;
                        h2 <= load_3(in[7*8 +: 3*8]) << 5;
                        h3 <= load_3(in[10*8 +: 3*8]) << 3;
                        h4 <= load_3(in[13*8 +: 3*8]) << 2;
                        h5 <= load_4(in[16*8 +: 4*8]);
                        h6 <= load_3(in[20*8 +: 3*8]) << 7;
                        h7 <= load_3(in[23*8 +: 3*8]) << 5;
                        h8 <= load_3(in[26*8 +: 3*8]) << 4;
                        h9 <= (load_3(in[29*8 +: 3*8]) & 64'sd8388607) << 2;
                    end
                    else
                    begin
                        state <= 0;
                    end
                   end
           8'd1 :  begin
                    carry9 <= (h9 + (64'sd1 << 24)) >>> 25;
                   end
           8'd2 :  begin
                    h0 <= h0 + (carry9 * 64'sd19);
                    h9 <= h9 - (carry9 << 25);
                   end
           8'd3 :  begin
                    carry1 <= (h1 + (64'sd1 << 24)) >>> 25;
                   end
           8'd4 :  begin
                    h2 <= h2 + carry1;
                    h1 <= h1 - (carry1 << 25);
                   end
           8'd5 :  begin
                    carry3 <= (h3 + (64'sd1 << 24)) >>> 25;
                   end
           8'd6 :  begin
                    h4 <= h4 + carry3;
                    h3 <= h3 - (carry3 << 25);
                   end
           8'd7 :  begin
                    carry5 <= (h5 + (64'sd1 << 24)) >>> 25;
                   end
           8'd8 :  begin
                    h6 <= h6 + carry5;
                    h5 <= h5 - (carry5 << 25);
                   end
           8'd9 :  begin
                    carry7 <= (h7 + (64'sd1 << 24)) >>> 25;
                   end
           8'd10 :  begin
                    h8 <= h8 + carry7;
                    h7 <= h7 - (carry7 << 25);
                   end
           8'd11 :  begin
                    carry0 <= (h0 + (64'sd1 << 25)) >>> 26;
                   end
           8'd12 :  begin
                    h1 <= h1 + carry0;
                    h0 <= h0 - (carry0 << 26);
                   end
           8'd13 :  begin
                    carry2 <= (h2 + (64'sd1 << 25)) >>> 26;
                   end
           8'd14 :  begin
                    h3 <= h3 + carry2;
                    h2 <= h2 - (carry2 << 26);
                   end
           8'd15 :  begin
                    carry4 <= (h4 + (64'sd1 << 25)) >>> 26;
                   end
           8'd16 :  begin
                    h5 <= h5 + carry4;
                    h4 <= h4 - (carry4 << 26);
                   end
           8'd17 :  begin
                    carry6 <= (h6 + (64'sd1 << 25)) >>> 26;
                   end
           8'd18 :  begin
                    h7 <= h7 + carry6;
                    h6 <= h6 - (carry6 << 26);
                   end
           8'd19 :  begin
                    carry8 <= (h8 + (64'sd1 << 25)) >>> 26;
                   end
           8'd20 :  begin
                    h9 <= h9 + carry8;
                    h8 <= h8 - (carry8 << 26);
                   end
           8'd21 :  begin
                    rout[0*32 +: 32] <= h0;
                    rout[1*32 +: 32] <= h1;
                    rout[2*32 +: 32] <= h2;
                    rout[3*32 +: 32] <= h3;
                    rout[4*32 +: 32] <= h4;
                    rout[5*32 +: 32] <= h5;
                    rout[6*32 +: 32] <= h6;
                    rout[7*32 +: 32] <= h7;
                    rout[8*32 +: 32] <= h8;
                    rout[9*32 +: 32] <= h9;
                    rdone <= 1;
                    state <= 0;
                    end
           default:  begin
                        state <= 0;
                    end
       endcase
     end
 end
 
 endmodule