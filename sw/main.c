#include <stdio.h>
#include "global.h"


extern void go();

int main(int argc, char** argv)
{
    initialize_pl();
    go();
    return 0;
}
