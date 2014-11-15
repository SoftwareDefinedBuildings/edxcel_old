
#include <stdio.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>       
char* banner = "\033[34;1m"
" ___  ___  _  _  __  ___  __    \n"
"(  _)(   \\( \\/ )/ _)(  _)(  )   \n"
" ) _) ) ) ))  (( (_  ) _) )(__  \n" 
"(___)(___/(_/\\_)\\__)(___)(____) \n";

uint32_t *PL;

#define PL_ADDR 0x43C00000
#define PL_SIZE 0xFFFF

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
	if (version >> 16 == 0x0410)
	{
	    printf("%sPL linked, version 0x%08x\n\033[0m",banner, version);
	}
	
}

