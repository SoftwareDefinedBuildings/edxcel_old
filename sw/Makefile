LIBS  = 
CFLAGS = -Wall -I./ed25519/src/ -I.
GCC = arm-xilinx-linux-gnueabi-gcc
SRC=$(wildcard *.c ed25519/src/*.c)

upload: bins
	cp edxcel /tftpboot
	
bins: $(SRC)
	$(GCC) -o edxcel $^ $(CFLAGS) $(LIBS)
