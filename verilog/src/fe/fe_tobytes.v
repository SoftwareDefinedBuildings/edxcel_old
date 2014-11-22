module fe_tobytes(
   input wire [319:0] in ,
   output wire [255:0] out,
   input wire clk,
   input wire rst,
   input wire valid,
   output wire done
);

reg [7:0] state;

reg signed [31:0] h0; 
reg signed [31:0] h1; 
reg signed [31:0] h2; 
reg signed [31:0] h3; 
reg signed [31:0] h4; 
reg signed [31:0] h5; 
reg signed [31:0] h6; 
reg signed [31:0] h7; 
reg signed [31:0] h8; 
reg signed [31:0] h9; 
reg signed [31:0] q;
reg signed [31:0] carry0;
reg signed [31:0] carry1;
reg signed [31:0] carry2;
reg signed [31:0] carry3;
reg signed [31:0] carry4;
reg signed [31:0] carry5;
reg signed [31:0] carry6;
reg signed [31:0] carry7;
reg signed [31:0] carry8;
reg signed [31:0] carry9;
reg signed [31:0] tmp;

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
                        h0 <= in[0*32 +: 32];
                        h1 <= in[1*32 +: 32];
                        h2 <= in[2*32 +: 32];
                        h3 <= in[3*32 +: 32];
                        h4 <= in[4*32 +: 32];
                        h5 <= in[5*32 +: 32];
                        h6 <= in[6*32 +: 32];
                        h7 <= in[7*32 +: 32];
                        h8 <= in[8*32 +: 32];
                        h9 <= in[9*32 +: 32];
                    end
                    else
                    begin
                        state <= 0;
                    end
                   end
           8'd1 :  begin
                        q <= (((32'sd19 * h9) + (32'sd1 << 24))) >>> 25;
                    end
           8'd2 :  begin
                        q <= (h0 + q) >>> 26;
                    end
           8'd3 :  begin
                        q <= (h1 + q) >>> 25;
                    end
           8'd4 :  begin
                        q <= (h2 + q) >>> 26;
                    end
           8'd5 :  begin
                        q <= (h3 + q) >>> 25;
                    end
           8'd6 :  begin
                        q <= (h4 + q) >>> 26;
                    end
           8'd7 :  begin
                        q <= (h5 + q) >>> 25;
                    end
           8'd8 :  begin
                        q <= (h6 + q) >>> 26;
                    end
           8'd9 :  begin
                        q <= (h7 + q) >>> 25;
                    end
           8'd10 :  begin
                        q <= (h8 + q) >>> 26;
                    end
           8'd11 :  begin
                        q <= (h9 + q) >>> 25;
                    end
           8'd12 :  begin
                        h0 <= h0 + 19 * q;
                    end
           8'd13 :  begin
                        carry0 <= h0 >>> 26;
                    end
           8'd14 :  begin
                        h1 <= h1 + carry0;
                        h0 <= h0 - (carry0 << 26);
                    end
           8'd15 :  begin
                        carry1 <= h1 >>> 25;
                    end
           8'd16 :  begin
                        h2 <= h2 + carry1;
                        h1 <= h1 - (carry1 << 25);
                    end
           8'd17 :  begin
                        carry2 <= h2 >>> 26;
                    end
           8'd18 :  begin
                        h3 <= h3 + carry2;
                        h2 <= h2 - (carry2 << 26);
                    end
           8'd19 :  begin
                        carry3 <= h3 >>> 25;
                    end
           8'd20 :  begin
                        h4 <= h4 + carry3;
                        h3 <= h3 - (carry3 << 25);
                    end
           8'd21 :  begin
                        carry4 <= h4 >>> 26;
                    end
           8'd22 :  begin
                        h5 <= h5 + carry4;
                        h4 <= h4 - (carry4 << 26);
                    end
           8'd23 :  begin
                        carry5 <= h5 >>> 25;
                    end
           8'd24 :  begin
                        h6 <= h6 + carry5;
                        h5 <= h5 - (carry5 << 25);
                    end
           8'd25 :  begin
                        carry6 <= h6 >>> 26;
                    end
           8'd26 :  begin
                        h7 <= h7 + carry6;
                        h6 <= h6 - (carry6 << 26);
                    end
           8'd27 :  begin
                        carry7 <= h7 >>> 25;
                    end
           8'd28 :  begin
                        h8 <= h8 + carry7;
                        h7 <= h7 - (carry7 << 25);
                    end
           8'd29 :  begin
                        carry8 <= h8 >>> 26;
                    end
           8'd30 :  begin
                        h9 <= h9 + carry8;
                        h8 <= h8 - (carry8 << 26);
                    end
           8'd31 :  begin
                        carry9 <= h9 >>> 25;
                    end
           8'd32 :  begin
                        h9 <= h9 - (carry9 << 25); 
                        tmp <= (h0 >>> 0);
                    end
           8'd33 :  begin
                        rout[ 0*8+:8] <= tmp[7:0];
                        tmp <= (h0 >>> 8);
                    end
           8'd34 :  begin
                        rout[ 1*8+:8] <= tmp[7:0];
                        tmp <= (h0 >>> 16);
                    end
           8'd35 :  begin
                        rout[ 2*8+:8] <= tmp[7:0];
                        tmp <= ((h0 >>> 24) | (h1 << 2));
                    end
           8'd36 :  begin
                        rout[ 3*8+:8] <= tmp[7:0];
                        tmp <= (h1 >>> 6);
                    end
           8'd37 :  begin
                        rout[ 4*8+:8] <= tmp[7:0];
                        tmp <= (h1 >>> 14);
                    end
           8'd38 :  begin
                        rout[ 5*8+:8] <= tmp[7:0];
                        tmp <= ((h1 >>> 22) | (h2 << 3));
                    end
           8'd39 :  begin
                        rout[ 6*8+:8] <= tmp[7:0];
                        tmp <= (h2 >>> 5);
                    end
           8'd40 :  begin
                        rout[ 7*8+:8] <= tmp[7:0];
                        tmp <= (h2 >>> 13);
                    end
           8'd41 :  begin
                        rout[ 8*8+:8] <= tmp[7:0];
                        tmp <= ((h2 >>> 21) | (h3 << 5));
                    end
           8'd42 :  begin
                        rout[ 9*8+:8] <= tmp[7:0];
                        tmp <= (h3 >>> 3);
                    end
           8'd43 :  begin
                        rout[10*8+:8] <= tmp[7:0];
                        tmp <= (h3 >>> 11);
                    end
           8'd44 :  begin
                        rout[11*8+:8] <= tmp[7:0]; 
                        tmp <= ((h3 >>> 19) | (h4 << 6));
                    end
           8'd45 :  begin
                        rout[12*8+:8] <= tmp[7:0];
                        tmp <= (h4 >>> 2);
                    end
           8'd46 :  begin
                        rout[13*8+:8] <= tmp[7:0];
                        tmp <= (h4 >>> 10);
                    end
           8'd47 :  begin
                        rout[14*8+:8] <= tmp[7:0];
                        tmp <= (h4 >>> 18);
                    end
           8'd48 :  begin
                        rout[15*8+:8] <= tmp[7:0];
                        tmp <= (h5 >>> 0);
                    end
           8'd49 :  begin
                        rout[16*8+:8] <= tmp[7:0];
                        tmp <= (h5 >>> 8);
                    end
           8'd50 :  begin
                        rout[17*8+:8] <= tmp[7:0];
                        tmp <= (h5 >>> 16);
                    end
           8'd51 :  begin
                        rout[18*8+:8] <= tmp[7:0];
                        tmp <= ((h5 >>> 24) | (h6 << 1));
                    end
           8'd52 :  begin
                        rout[19*8+:8] <= tmp[7:0];
                        tmp <= (h6 >>> 7);
                    end
           8'd53 :  begin
                        rout[20*8+:8] <= tmp[7:0];
                        tmp <= (h6 >>> 15);
                    end
           8'd54 :  begin
                        rout[21*8+:8] <= tmp[7:0];
                        tmp <= ((h6 >>> 23) | (h7 << 3));
                    end
           8'd55 :  begin
                        rout[22*8+:8] <= tmp[7:0];
                        tmp <= (h7 >>> 5);
                    end
           8'd56 :  begin
                        rout[23*8+:8] <= tmp[7:0];
                        tmp <= (h7 >>> 13);
                    end
           8'd57 :  begin
                        rout[24*8+:8] <= tmp[7:0];
                        tmp <= ((h7 >>> 21) | (h8 << 4));
                    end
           8'd58 :  begin
                        rout[25*8+:8] <= tmp[7:0];
                        tmp <= (h8 >>> 4);
                    end
           8'd59 :  begin
                        rout[26*8+:8] <= tmp[7:0];
                        tmp <= (h8 >>> 12);
                    end
           8'd60 :  begin
                        rout[27*8+:8] <= tmp[7:0];
                        tmp <= ((h8 >>> 20) | (h9 << 6));
                    end
           8'd61 :  begin
                        rout[28*8+:8] <= tmp[7:0];
                        tmp <= (h9 >>> 2);
                    end
           8'd62 :  begin
                        rout[29*8+:8] <= tmp[7:0];
                        tmp <= (h9 >>> 10);
                    end
           8'd63 :  begin
                        rout[30*8+:8] <= tmp[7:0];
                        tmp <= (h9 >>> 18);
                    end
           8'd64 :  begin
                        rout[31*8+:8] <= tmp[7:0];
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