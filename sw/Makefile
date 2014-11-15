LIBS  = 
CFLAGS = -Wall
GCC = arm-xilinx-linux-gnueabi-gcc
SRC=$(wildcard *.c)

upload: bins
	cp edxcel /tftpboot
	
bins: $(SRC)
	$(GCC) -o edxcel $^ $(CFLAGS) $(LIBS)
