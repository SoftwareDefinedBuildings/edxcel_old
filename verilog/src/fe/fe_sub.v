/*
void fe_sub(fe h, const fe f, const fe g) {
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
    int32_t h0 = f0 - g0;
    int32_t h1 = f1 - g1;
    int32_t h2 = f2 - g2;
    int32_t h3 = f3 - g3;
    int32_t h4 = f4 - g4;
    int32_t h5 = f5 - g5;
    int32_t h6 = f6 - g6;
    int32_t h7 = f7 - g7;
    int32_t h8 = f8 - g8;
    int32_t h9 = f9 - g9;

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

function automatic [319:0] fe_sub;
input signed [319:0] f;
input signed [319:0] g;
begin : fe_sub_blk
    fe_sub[0*32 +: 32] = f[0*32 +: 32] - g[0*32 +: 32];
    fe_sub[1*32 +: 32] = f[1*32 +: 32] - g[1*32 +: 32];
    fe_sub[2*32 +: 32] = f[2*32 +: 32] - g[2*32 +: 32];
    fe_sub[3*32 +: 32] = f[3*32 +: 32] - g[3*32 +: 32];
    fe_sub[4*32 +: 32] = f[4*32 +: 32] - g[4*32 +: 32];
    fe_sub[5*32 +: 32] = f[5*32 +: 32] - g[5*32 +: 32];
    fe_sub[6*32 +: 32] = f[6*32 +: 32] - g[6*32 +: 32];
    fe_sub[7*32 +: 32] = f[7*32 +: 32] - g[7*32 +: 32];
    fe_sub[8*32 +: 32] = f[8*32 +: 32] - g[8*32 +: 32];
    fe_sub[9*32 +: 32] = f[9*32 +: 32] - g[9*32 +: 32];
end
endfunction