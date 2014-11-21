#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ge.h>
#include <precomp_data.h>
typedef int32_t fe[10];


void fe_mul(fe h, const fe f, const fe g);
void fe_mulp(fe h, const fe f, const fe g);
void ge_double_scalarmult_vartimep(fe r_X, fe r_Y, fe r_Z, const unsigned char *a, fe gA_X, fe gA_Y, fe gA_Z, fe gA_T, const unsigned char *b);
#if 0
def conv(x):
    r = [x[i*2:i*2+2] for i in xrange(len(x)/2)]
    r.reverse()
    print "{",
    for i in r:
       print ", 0x%s" % i,
    print "};"

#endif
void ge_tobytes_(unsigned char *s, const ge_p2 *h) {
    fe recip;
    fe x;
    fe y;
    fe_invert(recip, h->Z);
    fe_mul(x, h->X, recip);
    fe_mul(y, h->Y, recip);
    fe_tobytes(s, y);
    s[31] ^= fe_isnegative(x) << 7;
}
uint8_t sig32_arr [] = { 0xf2 , 0xff , 0xdf , 0xff , 0x9e , 0x00 , 0x6a , 0x0b , 0x83 , 0x9e , 0x2e , 0x5c , 0x79 , 0x61 , 0x2a , 0xcf , 0x50 , 0xf9 , 0xab , 0xe3 , 0xa3 , 0x9d , 0xa4 , 0x4f , 0x86 , 0x5f , 0xb4 , 0x30 , 0x6c , 0xbd , 0x15 , 0x17 , 0x2b , 0x02 , 0xfc , 0x33 , 0x41 , 0x41 , 0xf6 , 0xce , 0xdf , 0x44 , 0xc3 , 0xde , 0xdd , 0x2a , 0x26 , 0x22 , 0x79 , 0x4e , 0x42 , 0x92 , 0xf5 , 0x62 , 0xe3 , 0xd9 , 0x3f , 0x12 , 0x46 , 0x7a , 0x65 , 0x2c , 0x72 , 0x0e };
//{ 0x13 , 0xa2 , 0x5e , 0x32 , 0x85 , 0xa3 , 0x3d , 0x44 , 0xc3 , 0xf0 , 0xf9 , 0x22 , 0x9e , 0xc4 , 0x09 , 0x84 , 0x17 , 0xb7 , 0xd5 , 0x13 , 0x65 , 0x29 , 0xbe , 0x2d , 0xbc , 0x2c , 0x5d , 0xa2 , 0xc5 , 0xb9 , 0xb8 , 0x7d , 0xff , 0x89 , 0x9c , 0x4f , 0xa5 , 0x3c , 0x3d , 0x82 , 0x80 , 0xae , 0x68 , 0x29 , 0xe1 , 0xa0 , 0xc9 , 0xaa , 0x94 , 0x3e , 0x39 , 0xc8 , 0x60 , 0x03 , 0xa2 , 0xef , 0xfe , 0x2a , 0x53 , 0x08 , 0xd5 , 0x02 , 0xe3 , 0x03 };
void ge_double_scalarmult_vartime_(ge_p2 *r, const unsigned char *a, const ge_p3 *A, const unsigned char *b) ;
int main()
{
    int i;
    /*
    uint8_t a_x_arr [] = { 0xd5 , 0x66 , 0x26 , 0xfe , 0xe5 , 0x73 , 0x78 , 0x00 , 0x26 , 0x1d , 0x75 , 0xfe , 0xcd , 0x9b , 0x86 , 0xff , 0xd2 , 0x06 , 0xa4 , 0x00 , 0xd6 , 0x68 , 0x81 , 0xff , 0xe3 , 0xc9 , 0xfb , 0xff , 0xda , 0xc1 , 0x4e , 0xff , 0x57 , 0xc6 , 0x32 , 0x01 , 0x5c , 0x2f , 0xc0 , 0xff };
    uint8_t a_y_arr [] = { 0x8a , 0x48 , 0x96 , 0x01 , 0x49 , 0x97 , 0x79 , 0x00 , 0xb4 , 0x21 , 0xe5 , 0xfe , 0xce , 0xb3 , 0xca , 0xff , 0x88 , 0x94 , 0x2f , 0xfe , 0x4b , 0xb1 , 0x61 , 0xff , 0xf4 , 0x3b , 0xff , 0xfe , 0x59 , 0x4e , 0xa4 , 0x00 , 0xa4 , 0x58 , 0x6b , 0x00 , 0xbf , 0x27 , 0x03 , 0x00 };
    uint8_t a_z_arr [] = { 0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 };
    uint8_t a_t_arr [] = { 0xc2 , 0xe7 , 0xd5 , 0x00 , 0x03 , 0x91 , 0x6a , 0xff , 0x86 , 0xd3 , 0x4b , 0xff , 0x3a , 0x0d , 0x52 , 0xff , 0xb6 , 0xea , 0x38 , 0x00 , 0x01 , 0x7e , 0xe6 , 0xff , 0x5e , 0x6d , 0xf2 , 0x00 , 0x53 , 0x07 , 0x18 , 0x00 , 0xef , 0xec , 0x89 , 0x00 , 0x70 , 0xb7 , 0x14 , 0xff };
*/
    //uint8_t a_x_arr [] = { 0x44 , 0x22 , 0x89 , 0xff , 0x65 , 0xf6 , 0x87 , 0xff , 0x22 , 0xc2 , 0x9e , 0x00 , 0x0e , 0xa9 , 0xe0 , 0x00 , 0xf4 , 0x77 , 0xc9 , 0xfe , 0x33 , 0xd3 , 0x00 , 0x00 , 0x3e , 0x7c , 0x6e , 0xff , 0xba , 0xdf , 0xb0 , 0x00 , 0x0f , 0xc6 , 0x75 , 0xff , 0x69 , 0x44 , 0x14 , 0x00 };//{ 0x89 , 0x69 , 0xa5 , 0xff , 0x26 , 0x10 , 0x1b , 0xff , 0x83 , 0xaf , 0xe7 , 0x01 , 0xe4 , 0x10 , 0x03 , 0x00 , 0x68 , 0x9e , 0x98 , 0x01 , 0x2d , 0x85 , 0xb4 , 0x00 , 0x81 , 0xe5 , 0x59 , 0x00 , 0xf2 , 0xa7 , 0xa7 , 0x00 , 0x1f , 0xf6 , 0x2f , 0xfe , 0x3e , 0xb2 , 0x40 , 0xff };
    //uint8_t a_y_arr [] = { 0x06 , 0xbf , 0x38 , 0xfe , 0xa6 , 0x33 , 0x48 , 0xff , 0x09 , 0x6c , 0xfc , 0x00 , 0xb3 , 0x84 , 0x75 , 0xff , 0xaa , 0x8f , 0xcb , 0x01 , 0x15 , 0x2f , 0x4e , 0xff , 0x39 , 0xde , 0x51 , 0xff , 0xc9 , 0x0b , 0xe7 , 0x00 , 0x39 , 0xda , 0x3c , 0xfe , 0x77 , 0xf7 , 0x5c , 0x00 };//{ 0x93 , 0x63 , 0x4e , 0xfe , 0x9b , 0xb8 , 0x33 , 0xff , 0xcb , 0x89 , 0xbd , 0x00 , 0x8e , 0xa6 , 0x75 , 0xff , 0x1f , 0x38 , 0xef , 0xff , 0x33 , 0xc3 , 0x0b , 0xff , 0x7c , 0x58 , 0xad , 0x00 , 0x34 , 0x45 , 0xa1 , 0xff , 0xa8 , 0xab , 0xa6 , 0x00 , 0x75 , 0xc9 , 0xa0 , 0xff };
    //uint8_t a_z_arr [] = { 0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 };
    //uint8_t a_t_arr [] = { 0x55 , 0xc4 , 0xc9 , 0x00 , 0xc9 , 0xb5 , 0x19 , 0xff , 0xa3 , 0x35 , 0x54 , 0x01 , 0x20 , 0x26 , 0x28 , 0xff , 0x4d , 0x6b , 0x5a , 0x01 , 0x9f , 0xf0 , 0x1c , 0x00 , 0xc8 , 0xba , 0x07 , 0x00 , 0xba , 0xe2 , 0xb6 , 0x00 , 0x02 , 0x3c , 0x04 , 0x01 , 0x29 , 0x96 , 0xa1 , 0x00 };

    uint8_t public_key [] = { 0x06 , 0xbf , 0x38 , 0x96 , 0xce , 0x20 , 0x45 , 0x60 , 0xe3 , 0x67 , 0x96 , 0xb0 , 0x6e , 0xea , 0xe3 , 0x72 , 0x15 , 0x2f , 0x4e , 0x71 , 0xbc , 0xa3 , 0x46 , 0x5e , 0x38 , 0x97 , 0xa3 , 0xcd , 0xa3 , 0xdd , 0x3d , 0x97 };
//{ 0x83 , 0x45 , 0xdf , 0x01 , 0x44 , 0x4b , 0xf5 , 0x00 , 0xe8 , 0x72 , 0xe1 , 0xfe , 0x7e , 0x97 , 0xb2 , 0x00 , 0x78 , 0x19 , 0x2b , 0xff , 0xe0 , 0x17 , 0xbd , 0xff , 0x13 , 0x05 , 0x67 , 0xfe , 0x56 , 0x46 , 0x58 , 0x00 , 0x38 , 0x61 , 0x9a , 0xff , 0x59 , 0xb6 , 0x90 , 0xff };

    fe a_x;
   	fe a_y;
   	fe a_z;
   	fe a_t;
   	ge_p3 A;
   	printf("VARVDSF %d \n",ge_frombytes_negate_vartime(&A, public_key));
    printf("\nRESULT2: ");

   //	uint8_t sig32_arr [] = { 0x38 , 0x51 , 0xd5 , 0x60 , 0x69 , 0xf2 , 0x38 , 0xf0 , 0x30 , 0x97 , 0xeb , 0xfe , 0xf9 , 0xac , 0x3b , 0xcf , 0x27 , 0x18 , 0x43 , 0xe4 , 0x84 , 0x32 , 0x78 , 0x02 , 0x3c , 0x30 , 0x61 , 0x39 , 0xb9 , 0x1f , 0x0b , 0x06 };
    //uint8_t h_arr  [] = { 0x42 , 0xe6 , 0xb3 , 0xda , 0x74 , 0x6f , 0x79 , 0x82 , 0xc7 , 0x2e , 0x39 , 0x45 , 0xca , 0x2e , 0x98 , 0x73 , 0x62 , 0xae , 0x2a , 0xf2 , 0x5a , 0xa0 , 0x79 , 0x47 , 0x0f , 0xd7 , 0x23 , 0xb6 , 0x0d , 0x43 , 0x0c , 0x0a };
    uint8_t h_arr [] = { 0x4a , 0x91 , 0xfb , 0xa1 , 0xfd , 0xcb , 0x4b , 0xc2 , 0xe3 , 0xfa , 0x61 , 0x0a , 0x40 , 0xcf , 0xfb , 0x8d , 0x4f , 0x8b , 0xc6 , 0xc7 , 0xd8 , 0x17 , 0x03 , 0xf0 , 0x54 , 0x6d , 0xdd , 0x3e , 0x67 , 0xf3 , 0x0f , 0x07 };

    fe r_X;
    fe r_Y;
    fe r_Z;

    //#define THEM
    #ifdef THEM
    ge_p2 R;
    uint8_t refc [32];
    ge_double_scalarmult_vartime_(&R, h_arr, &A, sig32_arr + 32);
    ge_tobytes_(refc, &R);
    printf("\n\nREFC  ");
    for (i=256/8 - 1;i>=0;i--)
            printf("%02x", (uint8_t) refc[i]);
        printf("\n");

        #endif
    /*printf("r_x:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&R.X[0])[i]);
    }
    printf("\nr_y:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&R.Y[0])[i]);
    }
    printf("\nr_z:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&R.Z[0])[i]);
    }*/

    //printf("\n");
    #ifndef THEM
    ge_double_scalarmult_vartimep(r_X,r_Y,r_Z,h_arr,A.X,A.Y,A.Z,A.T,sig32_arr+32);
    #endif
   /* printf("r_x:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&r_X[0])[i]);
    }
    printf("\nr_y:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&r_Y[0])[i]);
    }
    printf("\nr_z:  ");
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&r_Z[0])[i]);
    }
    */
}
void printfe(char* ann, const fe v)
{
    int i;
    printf("%s : ", ann);
    for (i=320/8 - 1; i>= 0; i--)
    {
    	printf("%02x",((uint8_t*)&v[0])[i]);
    }
    printf("\n");
}
void ge_double_scalarmult_vartime_(ge_p2 *r, const unsigned char *a, const ge_p3 *A, const unsigned char *b) {
    signed char aslide[256];
    signed char bslide[256];
    ge_cached Ai[8]; /* A,3A,5A,7A,9A,11A,13A,15A */
    ge_p1p1 t;
    ge_p3 u;
    ge_p3 A2;
    int i;
    slide(aslide, a);
    slide(bslide, b);
    ge_p3_to_cached(&Ai[0], A);
    ge_p3_dbl(&t, A);
    ge_p1p1_to_p3(&A2, &t);
    ge_add(&t, &A2, &Ai[0]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[1], &u);
    ge_add(&t, &A2, &Ai[1]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[2], &u);
    ge_add(&t, &A2, &Ai[2]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[3], &u);
    ge_add(&t, &A2, &Ai[3]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[4], &u);
    ge_add(&t, &A2, &Ai[4]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[5], &u);
    ge_add(&t, &A2, &Ai[5]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[6], &u);
    ge_add(&t, &A2, &Ai[6]);
    ge_p1p1_to_p3(&u, &t);
    ge_p3_to_cached(&Ai[7], &u);
    ge_p2_0(r);
    i=255;

/*
    for (i = 255; i >= 0; --i) {
        if (aslide[i] || bslide[i]) {
            break;
        }
    }
*/
    for (; i >= 0; --i) {
    printf("loop stats %d\n",i);
    printfe("post presetup A2X",A2.X);
    printfe("post presetup A2Y",A2.Y);
    printfe("post presetup A2Z",A2.Z);
    printfe("post presetup A2T",A2.T);
    printfe("post presetup ux",u.X);
    printfe("post presetup uy",u.Y);
    printfe("post presetup uz",u.Z);
    printfe("post presetup ut",u.T);
    printfe("post presetup tx",t.X);
    printfe("post presetup ty",t.Y);
    printfe("post presetup tz",t.Z);
    printfe("post presetup tt",t.T);
    printfe("post presetup Ai.YplusX",Ai[0].YplusX);
    printfe("post presetup Ai.YminusX",Ai[0].YminusX);
    printfe("post presetup Ai.Z",Ai[0].Z);
    printfe("post presetup Ai.T2d",Ai[0].T2d);


        ge_p2_dbl(&t, r);

        if (aslide[i] > 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_add(&t, &u, &Ai[aslide[i] / 2]);
        }/* else if (aslide[i] < 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_sub(&t, &u, &Ai[(-aslide[i]) / 2]);
        }*/

        if (bslide[i] > 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_madd(&t, &u, &Bi[bslide[i] / 2]);
        } /*else if (bslide[i] < 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_msub(&t, &u, &Bi[(-bslide[i]) / 2]);
        }*/

        ge_p1p1_to_p2(r, &t);
       // printf("loop %d: \n", i);
       // printfe("r_X : ",r->X);
       // printfe("r_Y : ",r->Y);
       // printfe("r_Z : ",r->Z);
    }
    printfe("r_X : ",r->X);
    printfe("r_Y : ",r->Y);
    printfe("r_Z : ",r->Z);
}
void fe_mul2(fe h, const fe f, const fe g) {
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
    int32_t r_g9_19 = 19 * g9;
    printf("g9 is %016x\n",g9);
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
	get(g9_19);
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
    int32_t r_g1_19 = 19 * g1;
    int64_t r_f1g6    = f1   * (int64_t) g6;
    int64_t r_f1g7_2  = f1_2 * (int64_t) g7;
    int64_t r_f1g8    = f1   * (int64_t) g8;
    int64_t r_f1g9_38 = f1_2 * (int64_t) g9_19;
    printf("cycle 4 g9_19 is %016lx\n",g9_19);
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      4, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 5
    get(g7_19);
    get(g8_19);
    get(f0g0);
    get(f0g1);
    get(f0g2);
    get(f0g3);
    printf("cycle %d, %s is %ld\n", 5,"g7_19",g7_19);
    printf("cycle %d, %s is %ld\n", 5,"g8_19",g8_19);
    printf("cycle %d, %s is %16lx\n", 5,"f0g0" ,f0g0);
    printf("cycle %d, %s is %16lx\n", 5,"f0g1" ,f0g1);
    printf("cycle %d, %s is %ld\n", 5,"f0g2" ,f0g2);
    printf("cycle %d, %s is %ld\n", 5,"f0g3" ,f0g3);
    int64_t r_f2g1    = f2   * (int64_t) g1;
    int64_t r_f2g2    = f2   * (int64_t) g2;
    int64_t r_f2g3    = f2   * (int64_t) g3;
    int64_t r_f2g4    = f2   * (int64_t) g4;
    h0_acc += f0g0;
    printf("cy 5 f0g0 is %016lx\n",f0g0);
    h1_acc += f0g1;
    h2_acc += f0g2;
    h3_acc += f0g3;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      5, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 6
    get(g1_19);
    get(f0g4);
    get(f0g5);
    get(f0g6);
    get(f0g7);
    int64_t r_f2g5    = f2   * (int64_t) g5;
    int64_t r_f2g6    = f2   * (int64_t) g6;
    int64_t r_f2g7    = f2   * (int64_t) g7;
    int64_t r_f2g8_19 = f2   * (int64_t) g8_19;
    h4_acc += f0g4;
    h5_acc += f0g5;
    h6_acc += f0g6;
    h7_acc += f0g7;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      6, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 7
    get(f0g8);
    get(f0g9);
    get(f1g0);
    get(f1g1_2);
    int64_t r_f2g0    = f2   * (int64_t) g0;
    int64_t r_f3g0    = f3   * (int64_t) g0;
    int64_t r_f2g9_19 = f2   * (int64_t) g9_19;
    int64_t r_f3g1_2  = f3_2 * (int64_t) g1;
    h8_acc += f0g8;
    h9_acc += f0g9;
    h1_acc += f1g0;
    h2_acc += f1g1_2;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      7, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      8, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 9
    get(f1g6);
    get(f1g7_2);
    get(f1g8);
    get(f1g9_38);
    int64_t r_f3g6    = f3   * (int64_t) g6;
    int64_t r_f3g7_38 = f3_2 * (int64_t) g7_19;
    int64_t r_f3g8_19 = f3   * (int64_t) g8_19;
    int64_t r_f3g9_38 = f3_2 * (int64_t) g9_19;
    h7_acc += f1g6;
    h8_acc += f1g7_2;
    h9_acc += f1g8;
    h0_acc += f1g9_38;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      9, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      10, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 11
    get(f2g5);
    get(f2g6);
    get(f2g7);
    get(f2g8_19);
    int64_t r_f4g4    = f4   * (int64_t) g4;
    int64_t r_f4g5    = f4   * (int64_t) g5;
    int64_t r_f4g6_19 = f4   * (int64_t) g6_19;
    int64_t r_f4g7_19 = f4   * (int64_t) g7_19;
    h7_acc += f2g5;
    h8_acc += f2g6;
    h9_acc += f2g7;
    h0_acc += f2g8_19; 
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      11, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 12
    get(f2g0);
    get(f3g0);
    get(f2g9_19);
    get(f3g1_2);
    int64_t r_f4g8_19 = f4   * (int64_t) g8_19;
    int64_t r_f4g9_19 = f4   * (int64_t) g9_19;
    int64_t r_f5g0    = f5   * (int64_t) g0;
    int64_t r_f5g1_2  = f5_2 * (int64_t) g1;
    h2_acc += f2g0;
    h3_acc += f3g0;
    h1_acc += f2g9_19;
    h4_acc += f3g1_2;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      12, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      13, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      14, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      15, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      16, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      17, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      18, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      19, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      20, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
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
    h0_acc += f9g1_38;
    
    //==================================Cycle 28
    get(f9g2_19);
    get(f9g3_38);
    get(f9g4_19);
    get(f9g5_38);
    h1_acc += f9g2_19;
    h2_acc += f9g3_38;
    h3_acc += f9g4_19;
    h4_acc += f9g5_38;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      28, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    //==================================Cycle 29
    get(f9g6_19);
    get(f9g7_38);
    get(f9g8_19);
    get(f9g9_38);
    h5_acc += f9g6_19;
    h6_acc += f9g7_38;
    h7_acc += f9g8_19;
    h8_acc += f9g9_38;
    printf("cy %d \n h0=%016lx\n h1=%016lx\n h2=%016lx\n h3=%016lx\n h4=%016lx\n h5=%016lx\n h6=%016lx\n h7=%016lx\n h8=%016lx\n h9=%016lx\n", 
                      29, h0_acc, h1_acc, h2_acc, h3_acc, h4_acc, h5_acc, h6_acc, h7_acc, h8_acc, h9_acc);
    
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
    //int64_t h0 = f0g0 + f1g9_38 + f2g8_19 + f3g7_38 + f4g6_19 + f5g5_38 + f6g4_19 + f7g3_38 + f8g2_19 + f9g1_38;
    //int64_t h1 = f0g1 + f1g0   + f2g9_19 + f3g8_19 + f4g7_19 + f5g6_19 + f6g5_19 + f7g4_19 + f8g3_19 + f9g2_19;
    //int64_t h2 = f0g2 + f1g1_2 + f2g0   + f3g9_38 + f4g8_19 + f5g7_38 + f6g6_19 + f7g5_38 + f8g4_19 + f9g3_38;
    //int64_t h3 = f0g3 + f1g2   + f2g1   + f3g0   + f4g9_19 + f5g8_19 + f6g7_19 + f7g6_19 + f8g5_19 + f9g4_19;
    //int64_t h4 = f0g4 + f1g3_2 + f2g2   + f3g1_2 + f4g0   + f5g9_38 + f6g8_19 + f7g7_38 + f8g6_19 + f9g5_38;
    //int64_t h5 = f0g5 + f1g4   + f2g3   + f3g2   + f4g1   + f5g0   + f6g9_19 + f7g8_19 + f8g7_19 + f9g6_19;
    //int64_t h6 = f0g6 + f1g5_2 + f2g4   + f3g3_2 + f4g2   + f5g1_2 + f6g0   + f7g9_38 + f8g8_19 + f9g7_38;
    //int64_t h7 = f0g7 + f1g6   + f2g5   + f3g4   + f4g3   + f5g2   + f6g1   + f7g0   + f8g9_19 + f9g8_19;
    //int64_t h8 = f0g8 + f1g7_2 + f2g6   + f3g5_2 + f4g4   + f5g3_2 + f6g2   + f7g1_2 + f8g0   + f9g9_38;
    //int64_t h9 = f0g9 + f1g8   + f2g7   + f3g6   + f4g5   + f5g4   + f6g3   + f7g2   + f8g1   + f9g0   ;
    
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

	//==================================Cycle 30
	//TODO these adders might be big
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

	//==================================Cycle 31
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
    printf("h0 %ld\n", h0);
    printf("h1 %ld\n", h1);
    printf("h2 %ld\n", h2);
    printf("h3 %ld\n", h3);
    printf("h4 %ld\n", h4);
    printf("h5 %ld\n", h5);
    printf("h6 %ld\n", h6);
    printf("h7 %ld\n", h7);
    printf("h8 %ld\n", h8);
    printf("h9 %ld\n", h9);
}

static const fe d = {
    -10913610, 13857413, -15372611, 6949391, 114729, -8787816, -6275908, -3247719, -18696448, -12055116
};

static const fe sqrtm1 = {
    -32595792, -7943725, 9377950, 3500415, 12389472, -272473, -25146209, -2005654, 326686, 11406482
};

static const fe d2 = {
    -21827239, -5839606, -30745221, 13898782, 229458, 15978800, -12551817, -6495438, 29715968, 9444199
};

static const fe n2 = {0x00000002};

fe bram [100] ;

//Memorymap
#define MM_d              0
#define MM_sqrtml         1
#define MM_d2             2
#define MM_n2             3
#define MM_Bi             4
    //Bi is 8*3 elements long
    //so ends at 28
    //we leave space for other COE
#define MM_t_X            40
#define MM_t_Y            41
#define MM_t_Z            42
#define MM_t_T            43
#define MM_u_X            44
#define MM_u_Y            45
#define MM_u_Z            46
#define MM_u_T            47
#define MM_A2_X           48
#define MM_A2_Y           49
#define MM_A2_Z           50
#define MM_A2_T           51
#define MM_q_X            52
#define MM_q_Y            53
#define MM_q_Z            54
#define MM_Ai             55
    //Ai is 4*8 = 32 elements long
#define MM_A_X            87
#define MM_A_Y            88
#define MM_A_Z            89
#define MM_A_T            90
#define MM_t0             91
#define MM_tmp            92

#define Ai_YplusX  0
#define Ai_YminusX 1
#define Ai_Z       2
#define Ai_T2d     3

#define BLOAD(dest, val) memcpy(&bram[dest], val, sizeof(fe))

static int consttime_equal(const unsigned char *x, const unsigned char *y) {
    unsigned char r = 0;

    r = x[0] ^ y[0];
    #define F(i) r |= x[i] ^ y[i]
    F(1);
    F(2);
    F(3);
    F(4);
    F(5);
    F(6);
    F(7);
    F(8);
    F(9);
    F(10);
    F(11);
    F(12);
    F(13);
    F(14);
    F(15);
    F(16);
    F(17);
    F(18);
    F(19);
    F(20);
    F(21);
    F(22);
    F(23);
    F(24);
    F(25);
    F(26);
    F(27);
    F(28);
    F(29);
    F(30);
    F(31);
    #undef F

    return !r;
}
void ge_double_scalarmult_vartimep(fe r_X, fe r_Y, fe r_Z, const unsigned char *a, fe gA_X, fe gA_Y, fe gA_Z, fe gA_T, const unsigned char *b) {
    signed char aslide[256];
    signed char bslide[256];
    ge_cached Ai[8]; /* A,3A,5A,7A,9A,11A,13A,15A */
    //ge_cached Ai[0];
    //fe YplusX;
    //fe YminusX;
    //fe Z;
    //fe T2d;
    /*ge_cached Ai[1];
    ge_cached Ai[2];
    ge_cached Ai[3];
    ge_cached Ai[4];
    ge_cached Ai[5];
    ge_cached Ai[6];
    ge_cached Ai[7];*/
    #if 0
    //ge_p1p1 t;
    fe t_X;
    fe t_Y;
    fe t_Z;
    fe t_T;
    //ge_p3 u;
    fe u_X;
    fe u_Y;
    fe u_Z;
    fe u_T;
    //ge_p3 A2;
    fe A2_X;
    fe A2_Y;
    fe A2_Z;
    fe A2_T;
    //ge_p2 q;
    fe q_X;
    fe q_Y;
    fe q_Z;
    #endif

    BLOAD(MM_A_X, gA_X);
    BLOAD(MM_A_Y, gA_Y);
    BLOAD(MM_A_Z, gA_Z);
    BLOAD(MM_A_T, gA_T);

    #define t_X (bram[MM_t_X])
    #define t_Y (bram[MM_t_Y])
    #define t_Z (bram[MM_t_Z])
    #define t_T (bram[MM_t_T])
    #define u_X (bram[MM_u_X])
    #define u_Y (bram[MM_u_Y])
    #define u_Z (bram[MM_u_Z])
    #define u_T (bram[MM_u_T])
    #define A2_X (bram[MM_A2_X])
    #define A2_Y (bram[MM_A2_Y])
    #define A2_Z (bram[MM_A2_Z])
    #define A2_T (bram[MM_A2_T])
    #define q_X (bram[MM_q_X])
    #define q_Y (bram[MM_q_Y])
    #define q_Z (bram[MM_q_Z])
    #define A_X (bram[MM_A_X])
    #define A_Y (bram[MM_A_Y])
    #define A_Z (bram[MM_A_Z])
    #define A_T (bram[MM_A_T])
    int i;
    fe t0;
    fe tmp;
//0101001010001001110111111000010110111111110100111101001001000011110001110101111110000110010100000000001011110011110111111011000111110010110100010110001111100011000110111110100011000000000011110010101010110110101110110111110011100110110011111111000011100000
//0000001101111000100010010011010001000000010011011000011110000011000011100011100010101001111111011010101001001110010000100110000110100010111110101111001010100000110101100001010011000000010100011101000111011011101101000110010001010110000100110001001111100110
//0001011100010101101111010110110000110000101101000101111110000110010011111010010010011101101000111110001110101011111110010101000011001111001010100110000101111001010111000010111010011110100000110000101101101010000000001001111011111111110111111111111111110010
    slide(aslide, a);
    slide(bslide, b);

    printf("aslide: ");
    for (i=255;i>=0;i--)
        printf("%01x", (uint8_t) aslide[i]);
    printf("\na: ");
    for (i=256/8 - 1;i>=0;i--)
        printf("%02x", (uint8_t) a[i]);

    printf("\nbslide: ");
    for (i=255;i>=0;i--)
        printf("%01x", (uint8_t) bslide[i]);
    printf("\na: ");
    for (i=256/8 - 1;i>=0;i--)
        printf("%02x", (uint8_t) b[i]);
    printf("\n");

    //ge_p3_to_cached(&Ai[0]], A);
    {
        fe_add(Ai[0].YplusX, A_Y, A_X);     //k
        fe_sub(Ai[0].YminusX, A_Y, A_X);
        fe_copy(Ai[0].Z, A_Z);
        fe_mul(Ai[0].T2d, A_T, d2); //k
    }
    //ge_p3_dbl(&t, A);
    {

        //ge_p3_to_p2(&q, A);
        { //This just throws away A.T
            fe_copy(q_X, A_X);
            fe_copy(q_Y, A_Y);
            fe_copy(q_Z, A_Z);

        }
        //ge_p2_dbl(&t, &q);
        {
            fe_mul(t_X, q_X, q_X); //k checked
            fe_mul(t_Z, q_Y, q_Y); //k no check
            fe_mul(tmp, n2, q_Z);  //ka
            fe_mul(t_T, q_Z, tmp);
            fe_add(t_Y, q_X, q_Y);
            fe_mul(t0, t_Y, t_Y); //k
            fe_add(t_Y, t_Z, t_X); //k
            fe_sub(t_Z, t_Z, t_X); //k
            fe_sub(t_X, t0, t_Y); //k
            fe_sub(t_T, t_T, t_Z); //k
        }
    }
    //ge_p1p1_to_p3(&A2, &t);
    {
        fe_mul(A2_X, t_X, t_T); //k
        fe_mul(A2_Y, t_Y, t_Z); //k
        fe_mul(A2_Z, t_Z, t_T); //k
        fe_mul(A2_T, t_X, t_Y); //k
    }
    //ge_add(&t, &A2, &Ai[0]);
    {
        fe_add(t_X, A2_Y, A2_X); //k
        fe_sub(t_Y, A2_Y, A2_X); //k
        fe_mul(t_Z, t_X, Ai[0].YplusX); //k
        //checkline


        fe_mul(t_Y, t_Y, Ai[0].YminusX); //k
        fe_mul(t_T, Ai[0].T2d, A2_T); //k

        fe_mul(t_X, A2_Z, Ai[0].Z); //k
        fe_add(t0, t_X, t_X);

        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y); //k
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T); //k


    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }



    //ge_p3_to_cached(&Ai[1]], &u);
    {
        fe_add(Ai[1].YplusX, u_Y, u_X);
        fe_sub(Ai[1].YminusX, u_Y, u_X);
        fe_copy(Ai[1].Z, u_Z);
        fe_mul(Ai[1].T2d, u_T, d2);
    }//k

    //tag3
    //ge_add(&t, &A2, &Ai[1]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[1].YplusX);
        fe_mul(t_Y, t_Y, Ai[1].YminusX);
        fe_mul(t_T, Ai[1].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[1].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }



    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }

    //===checkline

    //ge_p3_to_cached(&Ai[2]], &u);
    {
        fe_add(Ai[2].YplusX, u_Y, u_X);
        fe_sub(Ai[2].YminusX, u_Y, u_X);
        fe_copy(Ai[2].Z, u_Z);
        fe_mul(Ai[2].T2d, u_T, d2);
    }
    //ge_add(&t, &A2, &Ai[2]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[2].YplusX);
        fe_mul(t_Y, t_Y, Ai[2].YminusX);
        fe_mul(t_T, Ai[2].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[2].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }


    //ge_p3_to_cached(&Ai[3]], &u);
    {
        fe_add(Ai[3].YplusX, u_Y, u_X);
        fe_sub(Ai[3].YminusX, u_Y, u_X);
        fe_copy(Ai[3].Z, u_Z);
        fe_mul(Ai[3].T2d, u_T, d2);
    }
    //ge_add(&t, &A2, &Ai[3]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[3].YplusX);
        fe_mul(t_Y, t_Y, Ai[3].YminusX);
        fe_mul(t_T, Ai[3].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[3].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }

    //===========checkline

    //ge_p3_to_cached(&Ai[4]], &u);
    {
        fe_add(Ai[4].YplusX, u_Y, u_X);
        fe_sub(Ai[4].YminusX, u_Y, u_X);
        fe_copy(Ai[4].Z, u_Z);
        fe_mul(Ai[4].T2d, u_T, d2);
    }
    //ge_add(&t, &A2, &Ai[4]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[4].YplusX);
        fe_mul(t_Y, t_Y, Ai[4].YminusX);
        fe_mul(t_T, Ai[4].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[4].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }
    //ge_p3_to_cached(&Ai[5]], &u);
    {
        fe_add(Ai[5].YplusX, u_Y, u_X);
        fe_sub(Ai[5].YminusX, u_Y, u_X);
        fe_copy(Ai[5].Z, u_Z);
        fe_mul(Ai[5].T2d, u_T, d2);
    }
    //ge_add(&t, &A2, &Ai[5]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[5].YplusX);
        fe_mul(t_Y, t_Y, Ai[5].YminusX);
        fe_mul(t_T, Ai[5].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[5].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }

    //ge_p3_to_cached(&Ai[6]], &u);
    {
        fe_add(Ai[6].YplusX, u_Y, u_X);
        fe_sub(Ai[6].YminusX, u_Y, u_X);
        fe_copy(Ai[6].Z, u_Z);
        fe_mul(Ai[6].T2d, u_T, d2);
    }
    //ge_add(&t, &A2, &Ai[6]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[6].YplusX);
        fe_mul(t_Y, t_Y, Ai[6].YminusX);
        fe_mul(t_T, Ai[6].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[6].Z);
        fe_add(t0, t_X, t_X);
        fe_sub(t_X, t_Z, t_Y);
        fe_add(t_Y, t_Z, t_Y);
        fe_add(t_Z, t0, t_T);
        fe_sub(t_T, t0, t_T);
    }
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u_X, t_X, t_T);
        fe_mul(u_Y, t_Y, t_Z);
        fe_mul(u_Z, t_Z, t_T);
        fe_mul(u_T, t_X, t_Y);
    }
    //ge_p3_to_cached(&Ai[7]], &u);
    {
        fe_add(Ai[7].YplusX, u_Y, u_X);
        fe_sub(Ai[7].YminusX, u_Y, u_X);
        fe_copy(Ai[7].Z, u_Z);
        fe_mul(Ai[7].T2d, u_T, d2);
    }
    //=========checkline

    //ge_p2_0(r);
    {
        fe_0(r_X);
        fe_1(r_Y);
        fe_1(r_Z);
    }


    int choseni = 255;
  /*  for (i = 0; i < 128; i++) {
        if (aslide[i] || bslide[i]) {
            choseni = i;
        }
    }
    for (i = 128; i < 256; i++) {
        if (aslide[i] || bslide[i]) {
            choseni = i;
        }
    }*/
    i = choseni;
    printf("i=%d\n", i);
    //TODO reinstate slide and add back in the negative checks here
    for (; i >= 0; --i) {
        printf("Loop %d\n",i-1);
        //ge_p2_dbl(&t, r);
        {

            fe_mul(t_X, r_X, r_X); //AA
            printfe("r_x", r_X);
            fe_mul(t_Z, r_Y, r_Y); //BB
             printfe("r_Y", r_Y);
            fe_mul(tmp, n2, r_Z);
             printfe("r_x", r_Z);
            fe_mul(t_T, r_Z, tmp);
            fe_add(t_Y, r_X, r_Y);
            fe_mul(t0, t_Y, t_Y);
            fe_add(t_Y, t_Z, t_X);
            fe_sub(t_Z, t_Z, t_X);
            fe_sub(t_X, t0, t_Y);
            fe_sub(t_T, t_T, t_Z);

        }
        if (aslide[i] > 0)
        {
            printf("loop %d ASLIDE\n", i);
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u_X, t_X, t_T);
                fe_mul(u_Y, t_Y, t_Z);
                fe_mul(u_Z, t_Z, t_T);
                fe_mul(u_T, t_X, t_Y);
            }
            int idx = aslide[i] / 2;
            //ge_add(&t, &u, &Ai[idx]);
            {
                fe_add(t_X, u_Y, u_X);
                fe_sub(t_Y, u_Y, u_X);
                fe_mul(t_Z, t_X, Ai[idx].YplusX);
                fe_mul(t_Y, t_Y, Ai[idx].YminusX);
                fe_mul(t_T, Ai[idx].T2d, u_T);
                fe_mul(t_X, u_Z, Ai[idx].Z);
                fe_add(t0, t_X, t_X);
                fe_sub(t_X, t_Z, t_Y);
                fe_add(t_Y, t_Z, t_Y);
                fe_add(t_Z, t0, t_T);
                fe_sub(t_T, t0, t_T);
            }
        }
        if (bslide[i] > 0)
        {
            printf("loop %d BSLIDE\n", i);
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u_X, t_X, t_T);
                fe_mul(u_Y, t_Y, t_Z);
                fe_mul(u_Z, t_Z, t_T);
                fe_mul(u_T, t_X, t_Y);
            }

            //ge_madd(&t, &u, &Bi[bslide[i] / 2]);
            {
                int idx = bslide[i] / 2;
                fe_add(t_X, u_Y, u_X);
                fe_sub(t_Y, u_Y, u_X);
             //   printfe("uX ", u_Y);
             //   printfe("uX ", u_X);
             //   printfe("tY", t_Y);
                fe_mul(t_Z, t_X, Bi[idx].yplusx); //k
                fe_mul(t_Y, t_Y, Bi[idx].yminusx); //k
             //   printfe("Bipx ", Bi[idx].yplusx);
             //   printfe("Biymx", Bi[idx].yminusx);
             //   printfe("tX ", t_X);
             //   printfe("tY", t_Y);
                fe_mul(t_T, Bi[idx].xy2d, u_T); //k
                fe_add(t0, u_Z, u_Z);
                fe_sub(t_X, t_Z, t_Y);
                fe_add(t_Y, t_Z, t_Y);
                fe_add(t_Z, t0, t_T);
                fe_sub(t_T, t0, t_T);

            }
        }
        //ge_p1p1_to_p2(r, &t);
        {
            fe_mul(r_X, t_X, t_T);
            fe_mul(r_Y, t_Y, t_Z);
            fe_mul(r_Z, t_Z, t_T);
        }

      //  printfe("4: ",t_T);
      //  printfe("5: ",t0);
      //  printfe("6: ",A2_T);
    }
    printf("end: \n");
    printfe("r_X : ",r_X);
    printfe("r_Y : ",r_Y);
    printfe("r_Z : ",r_Z);
    //void ge_tobytes(unsigned char *s, const ge_p2 *h) { //ff348211fef50137006a7aa9014d6f3f00fe8356fe5600a000dfcc46019732a5ff5135d600c4b8ae
                                                          //ff348211fef50137006a7aa9014d6f3f00fe8356fe5600a000dfcc46019732a5ff5135d600c4b8ae

        char s [32];   
        fe_invert(t0, r_Z);
        printfe("fei output", t0);
        fe_mul(t_X, r_X, t0);
        fe_mul(t_Y, r_Y, t0);
        fe_tobytes(s, t_Y);
        printfe("t0 : ",t0);
        printfe("rX : ",r_X);
        printfe("rY : ",r_Y);
        printfe("tmpX : ",t_X);
        printfe("tmpY : ",t_Y);
        printf("tmpy bytes: ");
        for (i=256/8 - 1;i>=0;i--)
            printf("%02x", (uint8_t) s[i]);
        s[31] ^= fe_isnegative(t_X) << 7;
        printf("\ntmpy mod bytes ");
        for (i=256/8 - 1;i>=0;i--)
            printf("%02x", (uint8_t) s[i]);
        printf("\n");

    if (!consttime_equal(s, sig32_arr)) {
        printf("NO MATCH");

    }
    else
    printf("MATCH");
    
}
