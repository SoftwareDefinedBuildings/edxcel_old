/*
void fe_frombytes(fe h, const unsigned char *s) {
    int64_t h0 = load_4(s);
    int64_t h1 = load_3(s + 4) << 6;
    int64_t h2 = load_3(s + 7) << 5;
    int64_t h3 = load_3(s + 10) << 3;
    int64_t h4 = load_3(s + 13) << 2;
    int64_t h5 = load_4(s + 16);
    int64_t h6 = load_3(s + 20) << 7;
    int64_t h7 = load_3(s + 23) << 5;
    int64_t h8 = load_3(s + 26) << 4;
    int64_t h9 = (load_3(s + 29) & 8388607) << 2;
    int64_t carry0;
    int64_t carry1;
    int64_t carry2;
    int64_t carry3;
    int64_t carry4;
    int64_t carry5;
    int64_t carry6;
    int64_t carry7;
    int64_t carry8;
    int64_t carry9;

    carry9 = (h9 + (int64_t) (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;
    carry1 = (h1 + (int64_t) (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    carry3 = (h3 + (int64_t) (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    carry5 = (h5 + (int64_t) (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;
    carry7 = (h7 + (int64_t) (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;
    carry0 = (h0 + (int64_t) (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    carry2 = (h2 + (int64_t) (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    carry4 = (h4 + (int64_t) (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    carry6 = (h6 + (int64_t) (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;
    carry8 = (h8 + (int64_t) (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;

    h[0] = (int32_t) h0;
    h[1] = (int32_t) h1;
    h[2] = (int32_t) h2;
    h[3] = (int32_t) h3;
    h[4] = (int32_t) h4;
    h[5] = (int32_t) h5;
    h[6] = (int32_t) h6;
    h[7] = (int32_t) h7;
    h[8] = (int32_t) h8;
    h[9] = (int32_t) h9;
}
*/

function automatic [63:0] load_3;
input [23:0] in;
begin
    load_3 = {40'b0, in};
end
endfunction

function automatic [63:0] load_4;
input [32:0] in;
begin
    load_4 = {32'b0, in};
end
endfunction


function automatic [319:0] fe_frombytes;
input [255:0] s;
begin : fe_frombytes_blk
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

    h0 = load_4(s[0*8 +: 4*8]);
    h1 = load_3(s[4*8 +: 3*8]) << 6;
    h2 = load_3(s[7*8 +: 3*8]) << 5;
    h3 = load_3(s[10*8 +: 3*8]) << 3;
    h4 = load_3(s[13*8 +: 3*8]) << 2;
    h5 = load_4(s[16*8 +: 4*8]);
    h6 = load_3(s[20*8 +: 3*8]) << 7;
    h7 = load_3(s[23*8 +: 3*8]) << 5;
    h8 = load_3(s[26*8 +: 3*8]) << 4;
    h9 = (load_3(s[29*8 +: 3*8]) & 64'sd8388607) << 2;

    carry9 = (h9 + (64'sd1 << 24)) >>> 25;
    h0 = h0 + (carry9 * 64'sd19);
    h9 = h9 - (carry9 << 25);
    carry1 = (h1 + (64'sd1 << 24)) >>> 25;
    h2 = h2 + carry1;
    h1 = h1 - (carry1 << 25);
    carry3 = (h3 + (64'sd1 << 24)) >>> 25;
    h4 = h4 + carry3;
    h3 = h3 - (carry3 << 25);
    carry5 = (h5 + (64'sd1 << 24)) >>> 25;
    h6 = h6 + carry5;
    h5 = h5 - (carry5 << 25);
    carry7 = (h7 + (64'sd1 << 24)) >>> 25;
    h8 = h8 + carry7;
    h7 = h7 - (carry7 << 25);
    carry0 = (h0 + (64'sd1 << 25)) >>> 26;
    h1 = h1 + carry0;
    h0 = h0 - (carry0 << 26);
    carry2 = (h2 + (64'sd1 << 25)) >>> 26;
    h3 = h3 + carry2;
    h2 = h2 - (carry2 << 26);
    carry4 = (h4 + (64'sd1 << 25)) >>> 26;
    h5 = h5 + carry4;
    h4 = h4 - (carry4 << 26);
    carry6 = (h6 + (64'sd1 << 25)) >>> 26;
    h7 = h7 + carry6;
    h6 = h6 - (carry6 << 26);
    carry8 = (h8 + (64'sd1 << 25)) >>> 26;
    h9 = h9 + carry8;
    h8 = h8 - (carry8 << 26);

    fe_frombytes[0*32 +: 32] = h0;
    fe_frombytes[1*32 +: 32] = h1;
    fe_frombytes[2*32 +: 32] = h2;
    fe_frombytes[3*32 +: 32] = h3;
    fe_frombytes[4*32 +: 32] = h4;
    fe_frombytes[5*32 +: 32] = h5;
    fe_frombytes[6*32 +: 32] = h6;
    fe_frombytes[7*32 +: 32] = h7;
    fe_frombytes[8*32 +: 32] = h8;
    fe_frombytes[9*32 +: 32] = h9;
end
endfunction