#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

/* #define ED25519_DLL */
#include "src/ed25519.h"

#include "src/ge.h"
#include "src/sc.h"

#include <stdio.h>

int main() {
    unsigned char public_key[32], private_key[64], seed[32];
    unsigned char signature[64];
    unsigned char *message = private_key;
    const int message_len = 32; // use private key as message

    long i, j;

    for (i = 0; i < 100000; i++) {
        /* create a random seed, and a keypair out of that seed */
        ed25519_create_seed(seed);
        ed25519_create_keypair(public_key, private_key, seed);
    
        /* create signature on the message with the keypair */
        ed25519_sign(signature, message, message_len, public_key, private_key);
   
        printf("pk:"); 
        for (j = 0; j < 32; j++)
            printf("%02x", public_key[j]);
        printf("\n");
    
        printf("sk:"); 
        for (j = 0; j < 64; j++)
            printf("%02x", private_key[j]);
        printf("\n");
        
        printf("msg:"); 
        for (j = 0; j < 32; j++)
            printf("%02x", message[j]);
        printf("\n");
        
        printf("sig:"); 
        for (j = 0; j < 64; j++)
            printf("%02x", signature[j]);
        printf("\n");
    }

    return 0;
}
