/*
void fe_neg(fe h, const fe f) {
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
    int32_t h0 = -f0;
    int32_t h1 = -f1;
    int32_t h2 = -f2;
    int32_t h3 = -f3;
    int32_t h4 = -f4;
    int32_t h5 = -f5;
    int32_t h6 = -f6;
    int32_t h7 = -f7;
    int32_t h8 = -f8;
    int32_t h9 = -f9;

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

function automatic [319:0] fe_neg;
input signed [319:0] f;
begin : fe_neg_blk
    fe_neg[0*32 +: 32] = -f[0*32 +: 32];
    fe_neg[1*32 +: 32] = -f[1*32 +: 32];
    fe_neg[2*32 +: 32] = -f[2*32 +: 32];
    fe_neg[3*32 +: 32] = -f[3*32 +: 32];
    fe_neg[4*32 +: 32] = -f[4*32 +: 32];
    fe_neg[5*32 +: 32] = -f[5*32 +: 32];
    fe_neg[6*32 +: 32] = -f[6*32 +: 32];
    fe_neg[7*32 +: 32] = -f[7*32 +: 32];
    fe_neg[8*32 +: 32] = -f[8*32 +: 32];
    fe_neg[9*32 +: 32] = -f[9*32 +: 32];
end
endfunction