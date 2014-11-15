
#include <ed25519.h>
#include <global.h>
#include <assert.h>
#include <stdio.h>

#define MESSAGE_LEN 32
#define SIGNATURE_LEN 64
#define KEY_LEN 32

#define MESSAGE_WORDS 	(MESSAGE_LEN/4)
#define SIGNATURE_WORDS (SIGNATURE_LEN/4)
#define KEY_WORDS 		(KEY_LEN/4)

//Return 1 if sig is ok, 0 if sig fails
inline int sw_verify(uint8_t *sig, uint8_t *msg, uint8_t *key)
{
	return ed25519_verify(sig, msg, 32, key);
}

uint8_t hw_verify_sync(uint8_t *sig, uint8_t *msg, uint8_t *key)
{
	//Find available EPU
	int i;
	uint32_t result;
	//uint8_t epu_idx = XL_AVAILABLE_IDX;
	uint8_t epu_idx = 0;
	assert (epu_idx != XL_AVAILABLE_NONE);
	
	
	//Load signature
	for (i=0;i<SIGNATURE_WORDS;i++)
		XL_EPU_SIG(epu_idx)[i] = ((uint32_t*)&sig[0])[i];
	
	//Load message
	for (i=0;i<MESSAGE_WORDS;i++)
		XL_EPU_MSG(epu_idx)[i] = ((uint32_t*)&msg[0])[i];
		
	//Load key	
	for (i=0;i<KEY_WORDS;i++)
		XL_EPU_KEY(epu_idx)[i] = ((uint32_t*)&key[0])[i];
	
	//Start computation
	XL_EPU_GO(epu_idx) = XL_GO_CODE;
		
	//Wait until calculation is done
	while(!XL_EPU_DONE(epu_idx));

	result = XL_EPU_DONE(epu_idx);
	printf("result was: %d\n", result);
	
	//Codes are 0 for busy, 1 for sig pass and 2 for sig fail
	return result == 1;
}

void enumerate_API()
{
	int i;
	
	for (i = 0;i<XL_NUM_EPU;i++)
	{
		
	}
}
int check_ok_sig()
{
	uint8_t sig [64] = {0x55,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   , 		
						0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   };
	uint8_t key [32] = {0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   };
	uint8_t msg [32] = {0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   ,0   };
	int result = hw_verify_sync(sig, msg, key);
	return result;
}

int check_bad_sig()
{
	uint8_t sig [64] = {8,8,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,37,0,0,0,0,0,50};
	uint8_t key [32] = {															85,85,85,85,0,0,0,0,0,0,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0, 0,0,0,85,85,85,85};
	uint8_t msg [32] = {														3,4,5,6,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,38,0,0,4,3,2,1};
	int result = hw_verify_sync(sig, msg, key);
	return result;
}

void go()
{
	printf("ok sig result: %d\n", check_ok_sig());
	printf("bad sig result: %d\n", check_bad_sig());
}


