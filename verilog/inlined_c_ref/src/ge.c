#include "ge.h"
#include "precomp_data.h"


/*
r = p + q
*/

void ge_add(ge_p1p1 *r, const ge_p3 *p, const ge_cached *q) {
    fe t0;
    fe_add(r->X, p->Y, p->X);
    fe_sub(r->Y, p->Y, p->X);
    fe_mul(r->Z, r->X, q->YplusX);
    fe_mul(r->Y, r->Y, q->YminusX);
    fe_mul(r->T, q->T2d, p->T);
    fe_mul(r->X, p->Z, q->Z);
    fe_add(t0, r->X, r->X);
    fe_sub(r->X, r->Z, r->Y);
    fe_add(r->Y, r->Z, r->Y);
    fe_add(r->Z, t0, r->T);
    fe_sub(r->T, t0, r->T);
}



static void slide(signed char *r, const unsigned char *a) {
    int i;
    int b;
    int k;

    for (i = 0; i < 256; ++i) {
        r[i] = 1 & (a[i >> 3] >> (i & 7));
    }

    for (i = 0; i < 256; ++i)
        if (r[i]) {
            for (b = 1; b <= 6 && i + b < 256; ++b) {
                if (r[i + b]) {
                    if (r[i] + (r[i + b] << b) <= 15) {
                        r[i] += r[i + b] << b;
                        r[i + b] = 0;
                    } else if (r[i] - (r[i + b] << b) >= -15) {
                        r[i] -= r[i + b] << b;

                        for (k = i + b; k < 256; ++k) {
                            if (!r[k]) {
                                r[k] = 1;
                                break;
                            }

                            r[k] = 0;
                        }
                    } else {
                        break;
                    }
                }
            }
        }
}

/*
r = a * A + b * B
where a = a[0]+256*a[1]+...+256^31 a[31].
and b = b[0]+256*b[1]+...+256^31 b[31].
B is the Ed25519 base point (x,4/5) with x positive.
*/

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

    for (i = 255; i >= 0; --i) {
        if (aslide[i] || bslide[i]) {
            break;
        }
    }

    i = 0;

    for (; i >= 0; --i) {
        ge_p2_dbl(&t, r);

        if (aslide[i] > 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_add(&t, &u, &Ai[aslide[i] / 2]);
        } else if (aslide[i] < 0) {
            ge_p1p1_to_p3(&u, &t);
            //ge_sub(&t, &u, &Ai[(-aslide[i]) / 2]);
            {
                fe t0;
                int idx = (-aslide[i]) / 2 + 1;

                fe_add(t.X, u.Y, u.X);
                fe_sub(t.Y, u.Y, u.X);
                fe_mul(t.Z, t.X, Ai[idx].YminusX);
                fe_mul(t.Y, t.Y, Ai[idx].YplusX);
                fe_mul(t.T, Ai[idx].T2d, u.T);
                fe_mul(t.X, u.Z, Ai[idx].Z);
                fe_add(t0,  t.X, t.X);
                fe_sub(t.X, t.Z, t.Y);
                fe_add(t.Y, t.Z, t.Y);
                fe_sub(t.Z, t0, t.T);
                fe_add(t.T, t0, t.T);
            }
        }

        if (bslide[i] > 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_madd(&t, &u, &Bi[bslide[i] / 2]);
        } else if (bslide[i] < 0) {
            ge_p1p1_to_p3(&u, &t);
            ge_msub(&t, &u, &Bi[(-bslide[i]) / 2]);
        }

        ge_p1p1_to_p2(r, &t);
    }
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


fe bram [100] ;

//Memorymap
#define MM_t_X            0
#define MM_t_Y            1
#define MM_t_Z            2
#define MM_t_T            3
#define MM_u_X            4
#define MM_u_Y            5
#define MM_u_Z            6
#define MM_u_T            7
#define MM_A2_X           8
#define MM_A2_Y           9
#define MM_A2_Z           10
#define MM_A2_T           11
#define MM_q_X            12
#define MM_q_Y            13
#define MM_q_Z            14
#define MM_Ai             15
    //Ai is 4*8 = 32 elements long
#define MM_A_X           47
#define MM_A_Y           48
#define MM_A_Z           49
#define MM_A_T           50

#define Ai_YplusX  0
#define Ai_YminusX 1
#define Ai_Z       2
#define Ai_T2d     3

#define BLOAD(dest, val) memcpy(&bram[dest], val, sizeof(fe))

void ge_double_scalarmult_vartime(ge_p2 *r, const unsigned char *a, const ge_p3 *A, const unsigned char *b) {
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

    BLOAD(MM_A_X, A->X);
    BLOAD(MM_A_Y, A->Y);
    BLOAD(MM_A_Z, A->Z);
    BLOAD(MM_A_T, A->T);

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
    fe n2 = {0x00000002}; // init first int32_t of n2 as 2
    fe tmp;

    slide(aslide, a);
    slide(bslide, b);

    //ge_p3_to_cached(&Ai[0]], A);
    {
        fe_add(Ai[0].YplusX, A_Y, A_X);
        fe_sub(Ai[0].YminusX, A_Y, A_X);
        fe_copy(Ai[0].Z, A_Z);
        fe_mul(Ai[0].T2d, A_T, d2);
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
            fe_mul(t_X, q_X, q_X);
            fe_mul(t_Z, q_Y, q_Y);
            fe_mul(tmp, n2, q_Z);
            fe_mul(t_T, q_Z, tmp);
            fe_add(t_Y, q_X, q_Y);
            fe_mul(t0, t_Y, t_Y);
            fe_add(t_Y, t_Z, t_X);
            fe_sub(t_Z, t_Z, t_X);
            fe_sub(t_X, t0, t_Y);
            fe_sub(t_T, t_T, t_Z);
        }
    }
    //ge_p1p1_to_p3(&A2, &t);
    {
        fe_mul(A2_X, t_X, t_T);
        fe_mul(A2_Y, t_Y, t_Z);
        fe_mul(A2_Z, t_Z, t_T);
        fe_mul(A2_T, t_X, t_Y);
    }
    //ge_add(&t, &A2, &Ai[0]);
    {
        fe_add(t_X, A2_Y, A2_X);
        fe_sub(t_Y, A2_Y, A2_X);
        fe_mul(t_Z, t_X, Ai[0].YplusX);
        fe_mul(t_Y, t_Y, Ai[0].YminusX);
        fe_mul(t_T, Ai[0].T2d, A2_T);
        fe_mul(t_X, A2_Z, Ai[0].Z);
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
    //ge_p3_to_cached(&Ai[1]], &u);
    {
        fe_add(Ai[1].YplusX, u_Y, u_X);
        fe_sub(Ai[1].YminusX, u_Y, u_X);
        fe_copy(Ai[1].Z, u_Z);
        fe_mul(Ai[1].T2d, u_T, d2);
    }
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
    //ge_p2_0(r);
    {
        fe_0(r->X);
        fe_1(r->Y);
        fe_1(r->Z);
    }

    for (i = 255; i >= 0; --i) {
        if (aslide[i] || bslide[i]) {
            break;
        }
    }

    for (; i >= 0; --i) {
        //ge_p2_dbl(&t, r);
        {

        
            fe_mul(t_X, r->X, r->X);
            fe_mul(t_Z, r->Y, r->Y);
            fe_mul(tmp, n2, r->Z);
            fe_mul(t_T, r->Z, tmp);
            fe_add(t_Y, r->X, r->Y);
            fe_mul(t0, t_Y, t_Y);
            fe_add(t_Y, t_Z, t_X);
            fe_sub(t_Z, t_Z, t_X);
            fe_sub(t_X, t0, t_Y);
            fe_sub(t_T, t_T, t_Z);
        }
        if (aslide[i] > 0) {
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
        } else if (aslide[i] < 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u_X, t_X, t_T);
                fe_mul(u_Y, t_Y, t_Z);
                fe_mul(u_Z, t_Z, t_T);
                fe_mul(u_T, t_X, t_Y);
            }
            //ge_sub(&t, &u, &Ai_(-aslide[i]) / 2]);
            {

                int idx = (-aslide[i]) / 2;

                fe_add(t_X, u_Y, u_X);
                fe_sub(t_Y, u_Y, u_X);
                fe_mul(t_Z, t_X, Ai[idx].YminusX);
                fe_mul(t_Y, t_Y, Ai[idx].YplusX);
                fe_mul(t_T, Ai[idx].T2d, u_T);
                fe_mul(t_X, u_Z, Ai[idx].Z);
                fe_add(t0, t_X, t_X);
                fe_sub(t_X, t_Z, t_Y);
                fe_add(t_Y, t_Z, t_Y);
                fe_sub(t_Z, t0, t_T);
                fe_add(t_T, t0, t_T);
            }
        }

        if (bslide[i] > 0) {
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
                fe_mul(t_Z, t_X, Bi[idx].yplusx);
                fe_mul(t_Y, t_Y, Bi[idx].yminusx);
                fe_mul(t_T, Bi[idx].xy2d, u_T);
                fe_add(t0, u_Z, u_Z);
                fe_sub(t_X, t_Z, t_Y);
                fe_add(t_Y, t_Z, t_Y);
                fe_add(t_Z, t0, t_T);
                fe_sub(t_T, t0, t_T);
            }
        } else if (bslide[i] < 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u_X, t_X, t_T);
                fe_mul(u_Y, t_Y, t_Z);
                fe_mul(u_Z, t_Z, t_T);
                fe_mul(u_T, t_X, t_Y);
            }
            //ge_msub(&t, &u, &Bi[(-bslide[i]) / 2]);
            {
                int idx = (-bslide[i]) / 2;
                fe_add(t_X, u_Y, u_X);
                fe_sub(t_Y, u_Y, u_X);
                fe_mul(t_Z, t_X, Bi[idx].yminusx);
                fe_mul(t_Y, t_Y, Bi[idx].yplusx);
                fe_mul(t_T, Bi[idx].xy2d, u_T);
                fe_add(t0, u_Z, u_Z);
                fe_sub(t_X, t_Z, t_Y);
                fe_add(t_Y, t_Z, t_Y);
                fe_sub(t_Z, t0, t_T);
                fe_add(t_T, t0, t_T);
            }
        }

        //ge_p1p1_to_p2(r, &t);
        {
            fe_mul(r->X, t_X, t_T);
            fe_mul(r->Y, t_Y, t_Z);
            fe_mul(r->Z, t_Z, t_T);
        }
    }
}




int ge_frombytes_negate_vartime(ge_p3 *h, const unsigned char *s) {
    fe u;
    fe v;
    fe v3;
    fe vxx;
    fe check;
    fe_frombytes(h->Y, s);
    fe_1(h->Z);
    fe_mul(u, h->Y, h->Y);
    fe_mul(v, u, d);
    fe_sub(u, u, h->Z);     /* u = y^2-1 */
    fe_add(v, v, h->Z);     /* v = dy^2+1 */
    fe_mul(v3, v, v);
    fe_mul(v3, v3, v);      /* v3 = v^3 */
    fe_mul(h->X, v3, v3);
    fe_mul(h->X, h->X, v);
    fe_mul(h->X, h->X, u);  /* x = uv^7 */
    fe_pow22523(h->X, h->X); /* x = (uv^7)^((q-5)/8) */
    fe_mul(h->X, h->X, v3);
    fe_mul(h->X, h->X, u);  /* x = uv^3(uv^7)^((q-5)/8) */
    fe_mul(vxx, h->X, h->X);
    fe_mul(vxx, vxx, v);
    fe_sub(check, vxx, u);  /* vx^2-u */

    if (fe_isnonzero(check)) {
        fe_add(check, vxx, u); /* vx^2+u */

        if (fe_isnonzero(check)) {
            return -1;
        }

        fe_mul(h->X, h->X, sqrtm1);
    }

    if (fe_isnegative(h->X) == (s[31] >> 7)) {
        fe_neg(h->X, h->X);
    }

    fe_mul(h->T, h->X, h->Y);
    return 0;
}


/*
r = p + q
*/

void ge_madd(ge_p1p1 *r, const ge_p3 *p, const ge_precomp *q) {
    fe t0;
    fe_add(r->X, p->Y, p->X);
    fe_sub(r->Y, p->Y, p->X);
    fe_mul(r->Z, r->X, q->yplusx);
    fe_mul(r->Y, r->Y, q->yminusx);
    fe_mul(r->T, q->xy2d, p->T);
    fe_add(t0, p->Z, p->Z);
    fe_sub(r->X, r->Z, r->Y);
    fe_add(r->Y, r->Z, r->Y);
    fe_add(r->Z, t0, r->T);
    fe_sub(r->T, t0, r->T);
}


/*
r = p - q
*/

void ge_msub(ge_p1p1 *r, const ge_p3 *p, const ge_precomp *q) {
    fe t0;

    fe_add(r->X, p->Y, p->X);
    fe_sub(r->Y, p->Y, p->X);
    fe_mul(r->Z, r->X, q->yminusx);
    fe_mul(r->Y, r->Y, q->yplusx);
    fe_mul(r->T, q->xy2d, p->T);
    fe_add(t0, p->Z, p->Z);
    fe_sub(r->X, r->Z, r->Y);
    fe_add(r->Y, r->Z, r->Y);
    fe_sub(r->Z, t0, r->T);
    fe_add(r->T, t0, r->T);
}


/*
r = p
*/

void ge_p1p1_to_p2(ge_p2 *r, const ge_p1p1 *p) {
    fe_mul(r->X, p->X, p->T);
    fe_mul(r->Y, p->Y, p->Z);
    fe_mul(r->Z, p->Z, p->T);
}



/*
r = p
*/

void ge_p1p1_to_p3(ge_p3 *r, const ge_p1p1 *p) {
    fe_mul(r->X, p->X, p->T);
    fe_mul(r->Y, p->Y, p->Z);
    fe_mul(r->Z, p->Z, p->T);
    fe_mul(r->T, p->X, p->Y);
}


void ge_p2_0(ge_p2 *h) {
    fe_0(h->X);
    fe_1(h->Y);
    fe_1(h->Z);
}



/*
r = 2 * p
*/

void ge_p2_dbl(ge_p1p1 *r, const ge_p2 *p) {
    fe t0;
    fe n2 = {0x00000002}; // init first int32_t of n2 as 2
    fe tmp;

    fe_mul(r->X, p->X, p->X);
    fe_mul(r->Z, p->Y, p->Y);
    fe_mul(tmp, n2, p->Z);
    fe_mul(r->T, p->Z, tmp);
    fe_add(r->Y, p->X, p->Y);
    fe_mul(t0, r->Y, r->Y);
    fe_add(r->Y, r->Z, r->X);
    fe_sub(r->Z, r->Z, r->X);
    fe_sub(r->X, t0, r->Y);
    fe_sub(r->T, r->T, r->Z);
}


/*
r = 2 * p
*/

void ge_p3_dbl(ge_p1p1 *r, const ge_p3 *p) {
    ge_p2 q;
    ge_p3_to_p2(&q, p);
    ge_p2_dbl(r, &q);
}



/*
r = p
*/



void ge_p3_to_cached(ge_cached *r, const ge_p3 *p) {
    fe_add(r->YplusX, p->Y, p->X);
    fe_sub(r->YminusX, p->Y, p->X);
    fe_copy(r->Z, p->Z);
    fe_mul(r->T2d, p->T, d2);
}


/*
r = p
*/

void ge_p3_to_p2(ge_p2 *r, const ge_p3 *p) {
    fe_copy(r->X, p->X);
    fe_copy(r->Y, p->Y);
    fe_copy(r->Z, p->Z);
}


/*
r = p - q
*/

void ge_sub(ge_p1p1 *r, const ge_p3 *p, const ge_cached *q) {
    fe t0;
    
    fe_add(r->X, p->Y, p->X);
    fe_sub(r->Y, p->Y, p->X);
    fe_mul(r->Z, r->X, q->YminusX);
    fe_mul(r->Y, r->Y, q->YplusX);
    fe_mul(r->T, q->T2d, p->T);
    fe_mul(r->X, p->Z, q->Z);
    fe_add(t0, r->X, r->X);
    fe_sub(r->X, r->Z, r->Y);
    fe_add(r->Y, r->Z, r->Y);
    fe_sub(r->Z, t0, r->T);
    fe_add(r->T, t0, r->T);
}


void ge_tobytes(unsigned char *s, const ge_p2 *h) {
    fe recip;
    fe x;
    fe y;
    fe_invert(recip, h->Z);
    fe_mul(x, h->X, recip);
    fe_mul(y, h->Y, recip);
    fe_tobytes(s, y);
    s[31] ^= fe_isnegative(x) << 7;
}
