
#include <stdio.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>     
#include <global.h>  
char* banner = "\033[34;1m"
" ___  ___  _  _  __  ___  __    \n"
"(  _)(   \\( \\/ )/ _)(  _)(  )   \n"
" ) _) ) ) ))  (( (_  ) _) )(__  \n" 
"(___)(___/(_/\\_)\\__)(___)(____) \n";

uint32_t *PL;

#define PL_ADDR 0x43C00000
#define PL_SIZE 0x10000

void initialize_pl()
{

    /* Open /dev/mem file */
	int fd = open ("/dev/mem", O_RDWR);
	if (fd < 1) 
	{
		perror("Could not open /dev/mem");
		exit(1);
	}
	PL = mmap(NULL, PL_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, PL_ADDR);
	if (!PL) 
	{
	    printf("Could not map PL\n");
	    exit(1);
	}
	
	//Get PL version
	uint32_t version = PL[0];
	uint32_t num_epu = PL[1];
	XL_EPU_MSG(0)[0] = 0x11111111;
	XL_EPU_KEY(0)[0] = 0x22222222;
	XL_EPU_SIG(0)[0] = 0x33333333;
	XL_EPU_GO(0) = 0x00000410;
	//(PL[2048 + 49]) = 0x410; //set vlaid
	/*(PL[2048 + 50]) = 0x410; //Nvalid
	(PL[2048 + 49]) = 0x410; //set vlaid
	(PL[2048 + 50]) = 0x410; //Nvalid
	(PL[2048 + 49]) = 0x410; //set vlaid
	(PL[2048 + 50]) = 0x410; //Nvalid
	//*((uint32_t*)(PL_ADDR + 0x20C8) = 0x410;*/
	//PL test
	if (version >> 16 == 0x0410)
	{
	    printf("%sPL linked (%d EPU's), version 0x%08x\n\033[0m",banner, num_epu, version);
	}
	exit(1);
	
}

