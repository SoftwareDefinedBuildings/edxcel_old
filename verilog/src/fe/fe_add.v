/*
void fe_add(fe h, const fe f, const fe g) {
    int32_t f0 = f[0];
    int32_t f1 = f[1];
    int32_t f2 = f[2];
    int32_t f3 = f[3];
    int32_t f4 = f[4];
    int32_t f5 = f[5];
    int32_t f6 = f[6];
    int32_t f7 = f[7];
    int32_t f8 = f[8];
    int32_t f9 = f[9];
    int32_t g0 = g[0];
    int32_t g1 = g[1];
    int32_t g2 = g[2];
    int32_t g3 = g[3];
    int32_t g4 = g[4];
    int32_t g5 = g[5];
    int32_t g6 = g[6];
    int32_t g7 = g[7];
    int32_t g8 = g[8];
    int32_t g9 = g[9];
    int32_t h0 = f0 + g0;
    int32_t h1 = f1 + g1;
    int32_t h2 = f2 + g2;
    int32_t h3 = f3 + g3;
    int32_t h4 = f4 + g4;
    int32_t h5 = f5 + g5;
    int32_t h6 = f6 + g6;
    int32_t h7 = f7 + g7;
    int32_t h8 = f8 + g8;
    int32_t h9 = f9 + g9;
    
    h[0] = h0;
    h[1] = h1;
    h[2] = h2;
    h[3] = h3;
    h[4] = h4;
    h[5] = h5;
    h[6] = h6;
    h[7] = h7;
    h[8] = h8;
    h[9] = h9;
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


function automatic [319:0] fe_add;
input [319:0] f;
input [319:0] g;
begin : fe_frombytes_blk
    reg signed [31:0] f0; 
    reg signed [31:0] f1; 
    reg signed [31:0] f2; 
    reg signed [31:0] f3; 
    reg signed [31:0] f4; 
    reg signed [31:0] f5; 
    reg signed [31:0] f6; 
    reg signed [31:0] f7; 
    reg signed [31:0] f8; 
    reg signed [31:0] f9;
    reg signed [31:0] g0; 
    reg signed [31:0] g1; 
    reg signed [31:0] g2; 
    reg signed [31:0] g3; 
    reg signed [31:0] g4; 
    reg signed [31:0] g5; 
    reg signed [31:0] g6; 
    reg signed [31:0] g7; 
    reg signed [31:0] g8; 
    reg signed [31:0] g9;
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

    f0 = f[0*32 +: 32];
    f1 = f[1*32 +: 32];
    f2 = f[2*32 +: 32];
    f3 = f[3*32 +: 32];
    f4 = f[4*32 +: 32];
    f5 = f[5*32 +: 32];
    f6 = f[6*32 +: 32];
    f7 = f[7*32 +: 32];
    f8 = f[8*32 +: 32];
    f9 = f[9*32 +: 32];
    g0 = g[0*32 +: 32];
    g1 = g[1*32 +: 32];
    g2 = g[2*32 +: 32];
    g3 = g[3*32 +: 32];
    g4 = g[4*32 +: 32];
    g5 = g[5*32 +: 32];
    g6 = g[6*32 +: 32];
    g7 = g[7*32 +: 32];
    g8 = g[8*32 +: 32];
    g9 = g[9*32 +: 32];
    
    h0 = f0 + g0;
    h1 = f1 + g1;
    h2 = f2 + g2;
    h3 = f3 + g3;
    h4 = f4 + g4;
    h5 = f5 + g5;
    h6 = f6 + g6;
    h7 = f7 + g7;
    h8 = f8 + g8;
    h9 = f9 + g9;
    $display("h0 is %h", h0);

    fe_add[0*32 +: 32] = h0;
    fe_add[1*32 +: 32] = h1;
    fe_add[2*32 +: 32] = h2;
    fe_add[3*32 +: 32] = h3;
    fe_add[4*32 +: 32] = h4;
    fe_add[5*32 +: 32] = h5;
    fe_add[6*32 +: 32] = h6;
    fe_add[7*32 +: 32] = h7;
    fe_add[8*32 +: 32] = h8;
    fe_add[9*32 +: 32] = h9;
end
endfunction