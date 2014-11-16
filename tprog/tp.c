#include <stdio.h>
#include <stdlib.h>

typedef int32_t fe[10];


void fe_mul(fe h, const fe f, const fe g);
void fe_mulp(fe h, const fe f, const fe g);

int main()
{
    int i;
    fe h = {[0 ... 9] = 0x5a5a5a5a};
    fe g = {[0 ... 9] = 0x7a7a7a7a};
    fe r = {[0 ... 9] = 0x00000000};
    fe r2 = {[0 ... 9] = 0x00000000};
    fe_mul(r, h, g);
    fe_mulp(r, h, g);
    printf("r:  ");
    for (i=0; i < 10; i++) {
        printf("%08x ", r[i]);
    }
    printf("\n");
    printf("r2: ");
    for (i=0; i < 10; i++) {
        printf("%08x ", r[i]);
    }
    printf("\n");
}

void fe_mul(fe h, const fe f, const fe g) {
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
    int32_t g1_19 = 19 * g1; /* 1.959375*2^29 */
    int32_t g2_19 = 19 * g2; /* 1.959375*2^30; still ok */
    int32_t g3_19 = 19 * g3;
    int32_t g4_19 = 19 * g4;
    int32_t g5_19 = 19 * g5;
    int32_t g6_19 = 19 * g6;
    int32_t g7_19 = 19 * g7;
    int32_t g8_19 = 19 * g8;
    int32_t g9_19 = 19 * g9;
    int32_t f1_2 = 2 * f1;
    int32_t f3_2 = 2 * f3;
    int32_t f5_2 = 2 * f5;
    int32_t f7_2 = 2 * f7;
    int32_t f9_2 = 2 * f9;
    int64_t f0g0    = f0   * (int64_t) g0;
    int64_t f0g1    = f0   * (int64_t) g1;
    int64_t f0g2    = f0   * (int64_t) g2;
    int64_t f0g3    = f0   * (int64_t) g3;
    int64_t f0g4    = f0   * (int64_t) g4;
    int64_t f0g5    = f0   * (int64_t) g5;
    int64_t f0g6    = f0   * (int64_t) g6;
    int64_t f0g7    = f0   * (int64_t) g7;
    int64_t f0g8    = f0   * (int64_t) g8;
    int64_t f0g9    = f0   * (int64_t) g9;
    int64_t f1g0    = f1   * (int64_t) g0;
    int64_t f1g1_2  = f1_2 * (int64_t) g1;
    int64_t f1g2    = f1   * (int64_t) g2;
    int64_t f1g3_2  = f1_2 * (int64_t) g3;
    int64_t f1g4    = f1   * (int64_t) g4;
    int64_t f1g5_2  = f1_2 * (int64_t) g5;
    int64_t f1g6    = f1   * (int64_t) g6;
    int64_t f1g7_2  = f1_2 * (int64_t) g7;
    int64_t f1g8    = f1   * (int64_t) g8;
    int64_t f1g9_38 = f1_2 * (int64_t) g9_19;
    int64_t f2g0    = f2   * (int64_t) g0;
    int64_t f2g1    = f2   * (int64_t) g1;
    int64_t f2g2    = f2   * (int64_t) g2;
    int64_t f2g3    = f2   * (int64_t) g3;
    int64_t f2g4    = f2   * (int64_t) g4;
    int64_t f2g5    = f2   * (int64_t) g5;
    int64_t f2g6    = f2   * (int64_t) g6;
    int64_t f2g7    = f2   * (int64_t) g7;
    int64_t f2g8_19 = f2   * (int64_t) g8_19;
    int64_t f2g9_19 = f2   * (int64_t) g9_19;
    int64_t f3g0    = f3   * (int64_t) g0;
    int64_t f3g1_2  = f3_2 * (int64_t) g1;
    int64_t f3g2    = f3   * (int64_t) g2;
    int64_t f3g3_2  = f3_2 * (int64_t) g3;
    int64_t f3g4    = f3   * (int64_t) g4;
    int64_t f3g5_2  = f3_2 * (int64_t) g5;
    int64_t f3g6    = f3   * (int64_t) g6;
    int64_t f3g7_38 = f3_2 * (int64_t) g7_19;
    int64_t f3g8_19 = f3   * (int64_t) g8_19;
    int64_t f3g9_38 = f3_2 * (int64_t) g9_19;
    int64_t f4g0    = f4   * (int64_t) g0;
    int64_t f4g1    = f4   * (int64_t) g1;
    int64_t f4g2    = f4   * (int64_t) g2;
    int64_t f4g3    = f4   * (int64_t) g3;
    int64_t f4g4    = f4   * (int64_t) g4;
    int64_t f4g5    = f4   * (int64_t) g5;
    int64_t f4g6_19 = f4   * (int64_t) g6_19;
    int64_t f4g7_19 = f4   * (int64_t) g7_19;
    int64_t f4g8_19 = f4   * (int64_t) g8_19;
    int64_t f4g9_19 = f4   * (int64_t) g9_19;
    int64_t f5g0    = f5   * (int64_t) g0;
    int64_t f5g1_2  = f5_2 * (int64_t) g1;
    int64_t f5g2    = f5   * (int64_t) g2;
    int64_t f5g3_2  = f5_2 * (int64_t) g3;
    int64_t f5g4    = f5   * (int64_t) g4;
    int64_t f5g5_38 = f5_2 * (int64_t) g5_19;
    int64_t f5g6_19 = f5   * (int64_t) g6_19;
    int64_t f5g7_38 = f5_2 * (int64_t) g7_19;
    int64_t f5g8_19 = f5   * (int64_t) g8_19;
    int64_t f5g9_38 = f5_2 * (int64_t) g9_19;
    int64_t f6g0    = f6   * (int64_t) g0;
    int64_t f6g1    = f6   * (int64_t) g1;
    int64_t f6g2    = f6   * (int64_t) g2;
    int64_t f6g3    = f6   * (int64_t) g3;
    int64_t f6g4_19 = f6   * (int64_t) g4_19;
    int64_t f6g5_19 = f6   * (int64_t) g5_19;
    int64_t f6g6_19 = f6   * (int64_t) g6_19;
    int64_t f6g7_19 = f6   * (int64_t) g7_19;
    int64_t f6g8_19 = f6   * (int64_t) g8_19;
    int64_t f6g9_19 = f6   * (int64_t) g9_19;
    int64_t f7g0    = f7   * (int64_t) g0;
    int64_t f7g1_2  = f7_2 * (int64_t) g1;
    int64_t f7g2    = f7   * (int64_t) g2;
    int64_t f7g3_38 = f7_2 * (int64_t) g3_19;
    int64_t f7g4_19 = f7   * (int64_t) g4_19;
    int64_t f7g5_38 = f7_2 * (int64_t) g5_19;
    int64_t f7g6_19 = f7   * (int64_t) g6_19;
    int64_t f7g7_38 = f7_2 * (int64_t) g7_19;
    int64_t f7g8_19 = f7   * (int64_t) g8_19;
    int64_t f7g9_38 = f7_2 * (int64_t) g9_19;
    int64_t f8g0    = f8   * (int64_t) g0;
    int64_t f8g1    = f8   * (int64_t) g1;
    int64_t f8g2_19 = f8   * (int64_t) g2_19;
    int64_t f8g3_19 = f8   * (int64_t) g3_19;
    int64_t f8g4_19 = f8   * (int64_t) g4_19;
    int64_t f8g5_19 = f8   * (int64_t) g5_19;
    int64_t f8g6_19 = f8   * (int64_t) g6_19;
    int64_t f8g7_19 = f8   * (int64_t) g7_19;
    int64_t f8g8_19 = f8   * (int64_t) g8_19;
    int64_t f8g9_19 = f8   * (int64_t) g9_19;
    int64_t f9g0    = f9   * (int64_t) g0;
    int64_t f9g1_38 = f9_2 * (int64_t) g1_19;
    int64_t f9g2_19 = f9   * (int64_t) g2_19;
    int64_t f9g3_38 = f9_2 * (int64_t) g3_19;
    int64_t f9g4_19 = f9   * (int64_t) g4_19;
    int64_t f9g5_38 = f9_2 * (int64_t) g5_19;
    int64_t f9g6_19 = f9   * (int64_t) g6_19;
    int64_t f9g7_38 = f9_2 * (int64_t) g7_19;
    int64_t f9g8_19 = f9   * (int64_t) g8_19;
    int64_t f9g9_38 = f9_2 * (int64_t) g9_19;
    int64_t h0 = f0g0 + f1g9_38 + f2g8_19 + f3g7_38 + f4g6_19 + f5g5_38 + f6g4_19 + f7g3_38 + f8g2_19 + f9g1_38;
    int64_t h1 = f0g1 + f1g0   + f2g9_19 + f3g8_19 + f4g7_19 + f5g6_19 + f6g5_19 + f7g4_19 + f8g3_19 + f9g2_19;
    int64_t h2 = f0g2 + f1g1_2 + f2g0   + f3g9_38 + f4g8_19 + f5g7_38 + f6g6_19 + f7g5_38 + f8g4_19 + f9g3_38;
    int64_t h3 = f0g3 + f1g2   + f2g1   + f3g0   + f4g9_19 + f5g8_19 + f6g7_19 + f7g6_19 + f8g5_19 + f9g4_19;
    int64_t h4 = f0g4 + f1g3_2 + f2g2   + f3g1_2 + f4g0   + f5g9_38 + f6g8_19 + f7g7_38 + f8g6_19 + f9g5_38;
    int64_t h5 = f0g5 + f1g4   + f2g3   + f3g2   + f4g1   + f5g0   + f6g9_19 + f7g8_19 + f8g7_19 + f9g6_19;
    int64_t h6 = f0g6 + f1g5_2 + f2g4   + f3g3_2 + f4g2   + f5g1_2 + f6g0   + f7g9_38 + f8g8_19 + f9g7_38;
    int64_t h7 = f0g7 + f1g6   + f2g5   + f3g4   + f4g3   + f5g2   + f6g1   + f7g0   + f8g9_19 + f9g8_19;
    int64_t h8 = f0g8 + f1g7_2 + f2g6   + f3g5_2 + f4g4   + f5g3_2 + f6g2   + f7g1_2 + f8g0   + f9g9_38;
    int64_t h9 = f0g9 + f1g8   + f2g7   + f3g6   + f4g5   + f5g4   + f6g3   + f7g2   + f8g1   + f9g0   ;
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

    carry0 = (h0 + (int64_t) (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    carry4 = (h4 + (int64_t) (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;

    carry1 = (h1 + (int64_t) (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    carry5 = (h5 + (int64_t) (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;

    carry2 = (h2 + (int64_t) (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    carry6 = (h6 + (int64_t) (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;

    carry3 = (h3 + (int64_t) (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    carry7 = (h7 + (int64_t) (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;

    carry4 = (h4 + (int64_t) (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    carry8 = (h8 + (int64_t) (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;

    carry9 = (h9 + (int64_t) (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;

    carry0 = (h0 + (int64_t) (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;

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

#define get(x) int64_t x = r_##x
void fe_mulp(fe h, const fe f, const fe g) {
	
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
    int32_t f1_2 = 2 * f1;
    int32_t f3_2 = 2 * f3;
    int32_t f5_2 = 2 * f5;
    int32_t f7_2 = 2 * f7;
    int32_t f9_2 = 2 * f9;
    int64_t h0_acc = 0;
    int64_t h1_acc = 0;
    int64_t h2_acc = 0;
    int64_t h3_acc = 0;
    int64_t h4_acc = 0;
    int64_t h5_acc = 0;
    int64_t h6_acc = 0;
    int64_t h7_acc = 0;
    int64_t h8_acc = 0;
    int64_t h9_acc = 0;
    
    //==================================Cycle 0
    int32_t r_g1_19 = 19 * g1;
    int32_t r_g2_19 = 19 * g2;
    int64_t r_f0g0    = f0   * (int64_t) g0;
    int64_t r_f0g1    = f0   * (int64_t) g1;
    int64_t r_f0g2    = f0   * (int64_t) g2;
    int64_t r_f0g3    = f0   * (int64_t) g3;
    
    //==================================Cycle 1
    int32_t r_g3_19 = 19 * g3;
    int32_t r_g4_19 = 19 * g4;
    int64_t r_f0g4    = f0   * (int64_t) g4;
    int64_t r_f0g5    = f0   * (int64_t) g5;
    int64_t r_f0g6    = f0   * (int64_t) g6;
    int64_t r_f0g7    = f0   * (int64_t) g7;
    
    //==================================Cycle 2
	get(g1_19);
    get(g2_19);
    int32_t r_g5_19 = 19 * g5;
    int32_t r_g6_19 = 19 * g6;
    int64_t r_f0g8    = f0   * (int64_t) g8;
    int64_t r_f0g9    = f0   * (int64_t) g9;
    int64_t r_f1g0    = f1   * (int64_t) g0;
    int64_t r_f1g1_2  = f1_2 * (int64_t) g1;
    
   	//==================================Cycle 3
    get(g3_19);
    get(g4_19);
    int32_t r_g7_19 = 19 * g7;
    int32_t r_g8_19 = 19 * g8;
    int64_t r_f1g2    = f1   * (int64_t) g2;
    int64_t r_f1g3_2  = f1_2 * (int64_t) g3;
    int64_t r_f1g4    = f1   * (int64_t) g4;
    int64_t r_f1g5_2  = f1_2 * (int64_t) g5;
    
    //==================================Cycle 4
    get(g5_19);
    get(g6_19);
    int32_t r_g9_19 = 19 * g9;
    int64_t r_f1g6    = f1   * (int64_t) g6;
    int64_t r_f1g7_2  = f1_2 * (int64_t) g7;
    int64_t r_f1g8    = f1   * (int64_t) g8;
    int64_t r_f2g0    = f2   * (int64_t) g0;
    
    //==================================Cycle 5
    get(g7_19);
    get(g8_19);
    get(f0g0);
    get(f0g1);
    get(f0g2);
    get(f0g3);
    int64_t r_f2g1    = f2   * (int64_t) g1;
    int64_t r_f2g2    = f2   * (int64_t) g2;
    int64_t r_f2g3    = f2   * (int64_t) g3;
    int64_t r_f2g4    = f2   * (int64_t) g4;
    h0_acc += f0g0;
    h1_acc += f0g1;
    h2_acc += f0g2;
    h3_acc += f0g3;
    
    //==================================Cycle 6
    get(g9_19);
    get(f0g4);
    get(f0g5);
    get(f0g6);
    get(f0g7);
    int64_t r_f2g5    = f2   * (int64_t) g5;
    int64_t r_f2g6    = f2   * (int64_t) g6;
    int64_t r_f2g7    = f2   * (int64_t) g7;
    int64_t r_f3g0    = f3   * (int64_t) g0;
    h4_acc += f0g4;
    h5_acc += f0g5;
    h6_acc += f0g6;
    h7_acc += f0g7;
    
    //==================================Cycle 7
    get(f0g8);
    get(f0g9);
    get(f1g0);
    get(f1g1_2);
    int64_t r_f1g9_38 = f1_2 * (int64_t) g9_19;
    int64_t r_f2g8_19 = f2   * (int64_t) g8_19;
    int64_t r_f2g9_19 = f2   * (int64_t) g9_19;
    int64_t r_f3g1_2  = f3_2 * (int64_t) g1;
    h8_acc += f0g8;
    h9_acc += f0g9;
    h1_acc += f1g0;
    h2_acc += f1g1_2;
    
    //==================================Cycle 8
    get(f1g2);
    get(f1g3_2);
    get(f1g4);
    get(f1g5_2);
    int64_t r_f3g2    = f3   * (int64_t) g2;
    int64_t r_f3g3_2  = f3_2 * (int64_t) g3;
    int64_t r_f3g4    = f3   * (int64_t) g4;
    int64_t r_f3g5_2  = f3_2 * (int64_t) g5;
    h3_acc += f1g2;
    h4_acc += f1g3_2;
    h5_acc += f1g4;
    h6_acc += f1g5_2;
    
    //==================================Cycle 9
    get(f1g6);
    get(f1g7_2);
    get(f1g8);
    get(f2g0);
    int64_t r_f3g6    = f3   * (int64_t) g6;
    int64_t r_f3g7_38 = f3_2 * (int64_t) g7_19;
    int64_t r_f3g8_19 = f3   * (int64_t) g8_19;
    int64_t r_f3g9_38 = f3_2 * (int64_t) g9_19;
    h7_acc += f1g6;
    h8_acc += f1g7_2;
    h9_acc += f1g8;
    h2_acc += f2g0;
    
    //==================================Cycle 10
    get(f2g1);
    get(f2g2);
    get(f2g3);
    get(f2g4);
    int64_t r_f4g0    = f4   * (int64_t) g0;
    int64_t r_f4g1    = f4   * (int64_t) g1;
    int64_t r_f4g2    = f4   * (int64_t) g2;
    int64_t r_f4g3    = f4   * (int64_t) g3;
    h3_acc += f2g1;
    h4_acc += f2g2;
    h5_acc += f2g3;
    h6_acc += f2g4;
    
    //==================================Cycle 11
    get(f2g5);
    get(f2g6);
    get(f2g7);
    get(f3g0);
    int64_t r_f4g4    = f4   * (int64_t) g4;
    int64_t r_f4g5    = f4   * (int64_t) g5;
    int64_t r_f4g6_19 = f4   * (int64_t) g6_19;
    int64_t r_f4g7_19 = f4   * (int64_t) g7_19;
    h7_acc += f2g5;
    h8_acc += f2g6;
    h9_acc += f2g7;
    h3_acc += f3g0; //<<<<XTAG this clashes with  cycle 10 h3
    
    //==================================Cycle 12
    get(f1g9_38);
    get(f2g8_19);
    get(f2g9_19);
    get(f3g1_2);
    int64_t r_f4g8_19 = f4   * (int64_t) g8_19;
    int64_t r_f4g9_19 = f4   * (int64_t) g9_19;
    int64_t r_f5g0    = f5   * (int64_t) g0;
    int64_t r_f5g1_2  = f5_2 * (int64_t) g1;
    h0_acc += f1g9_38;
    h0_acc += f2g8_19; //<<<<<CLASHES WITH SAME CYCLE
    h1_acc += f2g9_19;
    h4_acc += f3g1_2;
    
    //==================================Cycle 13
    get(f3g2);
    get(f3g3_2);
    get(f3g4);
    get(f3g5_2);
    int64_t r_f5g2    = f5   * (int64_t) g2;
    int64_t r_f5g3_2  = f5_2 * (int64_t) g3;
    int64_t r_f5g4    = f5   * (int64_t) g4;
    int64_t r_f5g5_38 = f5_2 * (int64_t) g5_19;
    h5_acc += f3g2;
    h6_acc += f3g3_2;
    h7_acc += f3g4;
    h8_acc += f3g5_2;
    
    //==================================Cycle 14
    get(f3g6);
    get(f3g7_38);
    get(f3g8_19);
    get(f3g9_38);
    int64_t r_f5g6_19 = f5   * (int64_t) g6_19;
    int64_t r_f5g7_38 = f5_2 * (int64_t) g7_19;
    int64_t r_f5g8_19 = f5   * (int64_t) g8_19;
    int64_t r_f5g9_38 = f5_2 * (int64_t) g9_19;
    h9_acc += f3g6;
    h0_acc += f3g7_38;
    h1_acc += f3g8_19;
    h2_acc += f3g9_38;
    
    //==================================Cycle 15
    get(f4g0);
    get(f4g1);
    get(f4g2);
    get(f4g3);
    int64_t r_f6g0    = f6   * (int64_t) g0;
    int64_t r_f6g1    = f6   * (int64_t) g1;
    int64_t r_f6g2    = f6   * (int64_t) g2;
    int64_t r_f6g3    = f6   * (int64_t) g3;
    h4_acc += f4g0;
    h5_acc += f4g1;
    h6_acc += f4g2;
    h7_acc += f4g3;
    
    //==================================Cycle 16
    get(f4g4);
    get(f4g5);
    get(f4g6_19);
    get(f4g7_19);
    int64_t r_f6g4_19 = f6   * (int64_t) g4_19;
    int64_t r_f6g5_19 = f6   * (int64_t) g5_19;
    int64_t r_f6g6_19 = f6   * (int64_t) g6_19;
    int64_t r_f6g7_19 = f6   * (int64_t) g7_19;
    h8_acc += f4g4;
    h9_acc += f4g5;
    h0_acc += f4g6_19;
    h1_acc += f4g7_19;
    
    //==================================Cycle 17
    get(f4g8_19);
    get(f4g9_19);
    get(f5g0);
    get(f5g1_2);
    int64_t r_f6g8_19 = f6   * (int64_t) g8_19;
    int64_t r_f6g9_19 = f6   * (int64_t) g9_19;
    int64_t r_f7g0    = f7   * (int64_t) g0;
    int64_t r_f7g1_2  = f7_2 * (int64_t) g1;
    h2_acc += f4g8_19;
    h3_acc += f4g9_19;
    h5_acc += f5g0;
    h6_acc += f5g1_2;
    
    //==================================Cycle 18
    get(f5g2);
    get(f5g3_2);
    get(f5g4);
    get(f5g5_38);
    int64_t r_f7g2    = f7   * (int64_t) g2;
    int64_t r_f7g3_38 = f7_2 * (int64_t) g3_19;
    int64_t r_f7g4_19 = f7   * (int64_t) g4_19;
    int64_t r_f7g5_38 = f7_2 * (int64_t) g5_19;
    h7_acc += f5g2;
    h8_acc += f5g3_2;
    h9_acc += f5g4;
    h0_acc += f5g5_38;
    
    //==================================Cycle 19
    get(f5g6_19);
    get(f5g7_38);
    get(f5g8_19);
    get(f5g9_38);
    int64_t r_f7g6_19 = f7   * (int64_t) g6_19;
    int64_t r_f7g7_38 = f7_2 * (int64_t) g7_19;
    int64_t r_f7g8_19 = f7   * (int64_t) g8_19;
    int64_t r_f7g9_38 = f7_2 * (int64_t) g9_19;
    h1_acc += f5g6_19;
    h2_acc += f5g7_38;
    h3_acc += f5g8_19;
    h4_acc += f5g9_38;
    
    //==================================Cycle 20
    get(f6g0);
    get(f6g1);
    get(f6g2);
    get(f6g3);
    int64_t r_f8g0    = f8   * (int64_t) g0;
    int64_t r_f8g1    = f8   * (int64_t) g1;
    int64_t r_f8g2_19 = f8   * (int64_t) g2_19;
    int64_t r_f8g3_19 = f8   * (int64_t) g3_19;
    h6_acc += f6g0;
    h7_acc += f6g1;
    h8_acc += f6g2;
    h9_acc += f6g3;
    
    //==================================Cycle 21
    get(f6g4_19);
    get(f6g5_19);
    get(f6g6_19);
    get(f6g7_19);
    int64_t r_f8g4_19 = f8   * (int64_t) g4_19;
    int64_t r_f8g5_19 = f8   * (int64_t) g5_19;
    int64_t r_f8g6_19 = f8   * (int64_t) g6_19;
    int64_t r_f8g7_19 = f8   * (int64_t) g7_19;
    h0_acc += f6g4_19;
    h1_acc += f6g5_19;
    h2_acc += f6g6_19;
    h3_acc += f6g7_19;
    
    //==================================Cycle 22
    get(f6g8_19);
    get(f6g9_19);
    get(f7g0);
    get(f7g1_2);
    int64_t r_f8g8_19 = f8   * (int64_t) g8_19;
    int64_t r_f8g9_19 = f8   * (int64_t) g9_19;
    int64_t r_f9g0    = f9   * (int64_t) g0;
    int64_t r_f9g1_38 = f9_2 * (int64_t) g1_19;
    h4_acc += f6g8_19;
    h5_acc += f6g9_19;
    h7_acc += f7g0;
    h8_acc += f7g1_2;
    
    //==================================Cycle 23
    get(f7g2);
    get(f7g3_38);
    get(f7g4_19);
    get(f7g5_38);
    int64_t r_f9g2_19 = f9   * (int64_t) g2_19;
    int64_t r_f9g3_38 = f9_2 * (int64_t) g3_19;
    int64_t r_f9g4_19 = f9   * (int64_t) g4_19;
    int64_t r_f9g5_38 = f9_2 * (int64_t) g5_19;
    h9_acc += f7g2;
    h0_acc += f7g3_38;
    h1_acc += f7g4_19;
    h2_acc += f7g5_38;
    
    //==================================Cycle 24
    get(f7g6_19);
    get(f7g7_38);
    get(f7g8_19);
    get(f7g9_38);
    int64_t r_f9g6_19 = f9   * (int64_t) g6_19;
    int64_t r_f9g7_38 = f9_2 * (int64_t) g7_19;
    int64_t r_f9g8_19 = f9   * (int64_t) g8_19;
    int64_t r_f9g9_38 = f9_2 * (int64_t) g9_19;
    h3_acc += f7g6_19;
    h4_acc += f7g7_38;
    h5_acc += f7g8_19;
    h6_acc += f7g9_38;
    
    //==================================Cycle 25
    get(f8g0);
    get(f8g1);
    get(f8g2_19);
    get(f8g3_19);
    h8_acc += f8g0;
    h9_acc += f8g1;
    h0_acc += f8g2_19;
    h1_acc += f8g3_19;
    
    //==================================Cycle 26
    get(f8g4_19);
    get(f8g5_19);
    get(f8g6_19);
    get(f8g7_19);
    h2_acc += f8g4_19;
    h3_acc += f8g5_19;
    h4_acc += f8g6_19;
    h5_acc += f8g7_19;
    
    //==================================Cycle 27
    get(f8g8_19);
    get(f8g9_19);
    get(f9g0);
    get(f9g1_38);
    h6_acc += f8g8_19;
    h7_acc += f8g9_19;
    h9_acc += f9g0;
    h1_acc += f9g1_38;
    
    //==================================Cycle 28
    get(f9g2_19);
    get(f9g3_38);
    get(f9g4_19);
    get(f9g5_38);
    h2_acc += f9g2_19;
    h3_acc += f9g3_38;
    h4_acc += f9g4_19;
    h5_acc += f9g5_38;
    
    //==================================Cycle 29
    get(f9g6_19);
    get(f9g7_38);
    get(f9g8_19);
    get(f9g9_38);
    h6_acc += f9g6_19;
    h7_acc += f9g7_38;
    h8_acc += f9g8_19;
    h9_acc += f9g9_38;
    
    int64_t h0 = h0_acc;
    int64_t h1 = h1_acc;
    int64_t h2 = h2_acc;
    int64_t h3 = h3_acc;
    int64_t h4 = h4_acc;
    int64_t h5 = h5_acc;
    int64_t h6 = h6_acc;
    int64_t h7 = h7_acc;
    int64_t h8 = h8_acc;
    int64_t h9 = h9_acc;
    
    
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

    carry0 = (h0 + (int64_t) (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    carry4 = (h4 + (int64_t) (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;

    carry1 = (h1 + (int64_t) (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    carry5 = (h5 + (int64_t) (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;

    carry2 = (h2 + (int64_t) (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    carry6 = (h6 + (int64_t) (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;

    carry3 = (h3 + (int64_t) (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    carry7 = (h7 + (int64_t) (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;

    carry4 = (h4 + (int64_t) (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    carry8 = (h8 + (int64_t) (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;

    carry9 = (h9 + (int64_t) (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;

    carry0 = (h0 + (int64_t) (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;

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

