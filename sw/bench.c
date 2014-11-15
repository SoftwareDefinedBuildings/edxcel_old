
#include <ed25519.h>

#define MESSAGE_LEN 32

//Return 1 if sig is ok, 0 if sig fails
inline int sw_verify(uint8_t *sig, uint8_t *msg, uint8_t *key)
{
	return ed25519_verify(sig, msg, 32, key);
}

uint8_t hw_verify_start(uint8_t *sig, uint8_t *msg, uint8_t *key)
{
	//Find available EPU
	uint8_t epu_idx = PL[
}
