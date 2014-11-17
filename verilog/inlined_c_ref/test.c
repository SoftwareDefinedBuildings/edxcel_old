#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* #define ED25519_DLL */
#include "src/ed25519.h"

int main() {
    unsigned char public_key[32];
    unsigned char signature[64];
    unsigned char message[64];
    const int message_len = 64; // use private key as message
    unsigned char str[256];

    int i, j;

    int count_total = 0;
    int count_success = 0;
    while (1) {
        char *pos;

        if (scanf("%s", str) == EOF)
            break;

        pos = str + 3; // get rid of heading of each line
        for (j = 0; j < 32; j++) {
            sscanf(pos, "%2hhx", &public_key[j]);
            pos += 2 * sizeof(char);
        }
    
        scanf("%s", str);
        pos = str + 3;
        for (j = 0; j < 64; j++) {
            sscanf(pos, "%2hhx", &message[j]);
            pos += 2 * sizeof(char);
        }
        
        scanf("%s", str);
        pos = str + 4;
        for (j = 0; j < 64; j++) {
            sscanf(pos, "%2hhx", &signature[j]);
            pos += 2 * sizeof(char);
        }
        
        int success = ed25519_verify(signature, message, message_len, public_key);
        
        count_total++;
        if (success) count_success++;
        printf("success = %d (%d/%d)\n", success, count_success, count_total);
    }

    return 0;

}
