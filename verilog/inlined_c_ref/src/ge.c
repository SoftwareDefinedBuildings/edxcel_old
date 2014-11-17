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

void ge_double_scalarmult_vartime(ge_p2 *r, const unsigned char *a, const ge_p3 *A, const unsigned char *b) {
    signed char aslide[256];
    signed char bslide[256];
    ge_cached Ai[8]; /* A,3A,5A,7A,9A,11A,13A,15A */
    ge_p1p1 t;
    ge_p3 u;
    ge_p3 A2;
    int i;
    slide(aslide, a);
    slide(bslide, b);
    //ge_p3_to_cached(&Ai[0], A);
    {
        fe_add(Ai[0].YplusX, A->Y, A->X);
        fe_sub(Ai[0].YminusX, A->Y, A->X);
        fe_copy(Ai[0].Z, A->Z);
        fe_mul(Ai[0].T2d, A->T, d2);
    }
    //ge_p3_dbl(&t, A);
    {
        ge_p2 q;
        //ge_p3_to_p2(&q, A);
        { //This just throws away A.T
            fe_copy(q.X, A->X);
            fe_copy(q.Y, A->Y);
            fe_copy(q.Z, A->Z);
        }
        //ge_p2_dbl(&t, &q);
        {
            fe t0;
            fe n2 = {0x00000002}; // init first int32_t of n2 as 2
            fe tmp;

            fe_mul(t.X, q.X, q.X);
            fe_mul(t.Z, q.Y, q.Y);
            fe_mul(tmp, n2, q.Z);
            fe_mul(t.T, q.Z, tmp);
            fe_add(t.Y, q.X, q.Y);
            fe_mul(t0, t.Y, t.Y);
            fe_add(t.Y, t.Z, t.X);
            fe_sub(t.Z, t.Z, t.X);
            fe_sub(t.X, t0, t.Y);
            fe_sub(t.T, t.T, t.Z);
        }
    }
    //ge_p1p1_to_p3(&A2, &t);
    {
        fe_mul(A2.X, t.X, t.T);
        fe_mul(A2.Y, t.Y, t.Z);
        fe_mul(A2.Z, t.Z, t.T);
        fe_mul(A2.T, t.X, t.Y);
    }
    ge_add(&t, &A2, &Ai[0]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[1], &u);
    {
        fe_add(Ai[1].YplusX, u.Y, u.X);
        fe_sub(Ai[1].YminusX, u.Y, u.X);
        fe_copy(Ai[1].Z, u.Z);
        fe_mul(Ai[1].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[1]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[2], &u);
    {
        fe_add(Ai[2].YplusX, u.Y, u.X);
        fe_sub(Ai[2].YminusX, u.Y, u.X);
        fe_copy(Ai[2].Z, u.Z);
        fe_mul(Ai[2].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[2]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[3], &u);
    {
        fe_add(Ai[3].YplusX, u.Y, u.X);
        fe_sub(Ai[3].YminusX, u.Y, u.X);
        fe_copy(Ai[3].Z, u.Z);
        fe_mul(Ai[3].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[3]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[4], &u);
    {
        fe_add(Ai[4].YplusX, u.Y, u.X);
        fe_sub(Ai[4].YminusX, u.Y, u.X);
        fe_copy(Ai[4].Z, u.Z);
        fe_mul(Ai[4].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[4]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[5], &u);
    {
        fe_add(Ai[5].YplusX, u.Y, u.X);
        fe_sub(Ai[5].YminusX, u.Y, u.X);
        fe_copy(Ai[5].Z, u.Z);
        fe_mul(Ai[5].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[5]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[6], &u);
    {
        fe_add(Ai[6].YplusX, u.Y, u.X);
        fe_sub(Ai[6].YminusX, u.Y, u.X);
        fe_copy(Ai[6].Z, u.Z);
        fe_mul(Ai[6].T2d, u.T, d2);
    }
    ge_add(&t, &A2, &Ai[6]);
    //ge_p1p1_to_p3(&u, &t);
    {
        fe_mul(u.X, t.X, t.T);
        fe_mul(u.Y, t.Y, t.Z);
        fe_mul(u.Z, t.Z, t.T);
        fe_mul(u.T, t.X, t.Y);
    }
    //ge_p3_to_cached(&Ai[7], &u);
    {
        fe_add(Ai[7].YplusX, u.Y, u.X);
        fe_sub(Ai[7].YminusX, u.Y, u.X);
        fe_copy(Ai[7].Z, u.Z);
        fe_mul(Ai[7].T2d, u.T, d2);
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
            fe t0;
            fe n2 = {0x00000002}; // init first int32_t of n2 as 2
            fe tmp;
        
            fe_mul(t.X, r->X, r->X);
            fe_mul(t.Z, r->Y, r->Y);
            fe_mul(tmp, n2, r->Z);
            fe_mul(t.T, r->Z, tmp);
            fe_add(t.Y, r->X, r->Y);
            fe_mul(t0, t.Y, t.Y);
            fe_add(t.Y, t.Z, t.X);
            fe_sub(t.Z, t.Z, t.X);
            fe_sub(t.X, t0, t.Y);
            fe_sub(t.T, t.T, t.Z);
        }
        if (aslide[i] > 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u.X, t.X, t.T);
                fe_mul(u.Y, t.Y, t.Z);
                fe_mul(u.Z, t.Z, t.T);
                fe_mul(u.T, t.X, t.Y);
            }
            ge_add(&t, &u, &Ai[aslide[i] / 2]);
        } else if (aslide[i] < 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u.X, t.X, t.T);
                fe_mul(u.Y, t.Y, t.Z);
                fe_mul(u.Z, t.Z, t.T);
                fe_mul(u.T, t.X, t.Y);
            }
            //ge_sub(&t, &u, &Ai[(-aslide[i]) / 2]);
            {
                fe t0;
                int idx = (-aslide[i]) / 2;

                fe_add(t.X, u.Y, u.X);
                fe_sub(t.Y, u.Y, u.X);
                fe_mul(t.Z, t.X, Ai[idx].YminusX);
                fe_mul(t.Y, t.Y, Ai[idx].YplusX);
                fe_mul(t.T, Ai[idx].T2d, u.T);
                fe_mul(t.X, u.Z, Ai[idx].Z);
                fe_add(t0, t.X, t.X);
                fe_sub(t.X, t.Z, t.Y);
                fe_add(t.Y, t.Z, t.Y);
                fe_sub(t.Z, t0, t.T);
                fe_add(t.T, t0, t.T);
            }
        }

        if (bslide[i] > 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u.X, t.X, t.T);
                fe_mul(u.Y, t.Y, t.Z);
                fe_mul(u.Z, t.Z, t.T);
                fe_mul(u.T, t.X, t.Y);
            }
            //ge_madd(&t, &u, &Bi[bslide[i] / 2]);
            {
                int idx = bslide[i] / 2;
                fe t0;
                fe_add(t.X, u.Y, u.X);
                fe_sub(t.Y, u.Y, u.X);
                fe_mul(t.Z, t.X, Bi[idx].yplusx);
                fe_mul(t.Y, t.Y, Bi[idx].yminusx);
                fe_mul(t.T, Bi[idx].xy2d, u.T);
                fe_add(t0, u.Z, u.Z);
                fe_sub(t.X, t.Z, t.Y);
                fe_add(t.Y, t.Z, t.Y);
                fe_add(t.Z, t0, t.T);
                fe_sub(t.T, t0, t.T);
            }
        } else if (bslide[i] < 0) {
            //ge_p1p1_to_p3(&u, &t);
            {
                fe_mul(u.X, t.X, t.T);
                fe_mul(u.Y, t.Y, t.Z);
                fe_mul(u.Z, t.Z, t.T);
                fe_mul(u.T, t.X, t.Y);
            }
            //ge_msub(&t, &u, &Bi[(-bslide[i]) / 2]);
            {
                fe t0;
                int idx = (-bslide[i]) / 2;
                fe_add(t.X, u.Y, u.X);
                fe_sub(t.Y, u.Y, u.X);
                fe_mul(t.Z, t.X, Bi[idx].yminusx);
                fe_mul(t.Y, t.Y, Bi[idx].yplusx);
                fe_mul(t.T, Bi[idx].xy2d, u.T);
                fe_add(t0, u.Z, u.Z);
                fe_sub(t.X, t.Z, t.Y);
                fe_add(t.Y, t.Z, t.Y);
                fe_sub(t.Z, t0, t.T);
                fe_add(t.T, t0, t.T);
            }
        }

        //ge_p1p1_to_p2(r, &t);
        {
            fe_mul(r->X, t.X, t.T);
            fe_mul(r->Y, t.Y, t.Z);
            fe_mul(r->Z, t.Z, t.T);
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
