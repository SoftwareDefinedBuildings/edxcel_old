#ifndef __GLOBAL_H__
#define __GLOBAL_H__

#include <stdint.h>

void initialize_pl();
extern uint32_t *PL;

#define XL_VERSION 			(PL[0])
#define XL_NUM_EPU 			(PL[1])
#define XL_READY_FLAGS		(PL[4])
#define XL_AVAILABLE_IDX	(PL[5])
#define XL_SIGNOK_FLAGS		(PL[6])
#define XL_EPU_SIG(x)		(PL[2048 + 64*(x))
#define XL_EPU_KEY(x)		(PL[2048 + 64*(x)+32)
#define XL_EPU_KEY(x)		(PL[2048 + 64*(x)+40)
#define XL_EPU_GO(x)		(PL[2048 + 64*(x)+
#endif
