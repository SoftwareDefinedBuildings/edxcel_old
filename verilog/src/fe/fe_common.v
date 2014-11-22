
/*
static uint64_t load_3(const unsigned char *in) {
    uint64_t result;

    result = (uint64_t) in[0];
    result |= ((uint64_t) in[1]) << 8;
    result |= ((uint64_t) in[2]) << 16;

    return result;
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
input signed [319:0] f;
input signed [319:0] g;
begin : fe_add_blk
    fe_add[0*32 +: 32] = f[0*32 +: 32] + g[0*32 +: 32];
    fe_add[1*32 +: 32] = f[1*32 +: 32] + g[1*32 +: 32];
    fe_add[2*32 +: 32] = f[2*32 +: 32] + g[2*32 +: 32];
    fe_add[3*32 +: 32] = f[3*32 +: 32] + g[3*32 +: 32];
    fe_add[4*32 +: 32] = f[4*32 +: 32] + g[4*32 +: 32];
    fe_add[5*32 +: 32] = f[5*32 +: 32] + g[5*32 +: 32];
    fe_add[6*32 +: 32] = f[6*32 +: 32] + g[6*32 +: 32];
    fe_add[7*32 +: 32] = f[7*32 +: 32] + g[7*32 +: 32];
    fe_add[8*32 +: 32] = f[8*32 +: 32] + g[8*32 +: 32];
    fe_add[9*32 +: 32] = f[9*32 +: 32] + g[9*32 +: 32];
end
endfunction


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
