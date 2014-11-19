LIBS  = 
CFLAGS = -Wall
GCCARM = arm-xilinx-linux-gnueabi-gcc

SRC=$(wildcard src/*.c)
SRC += test.c

upload: bins-arm
	cp edtest /tftpboot
	
bins-arm: $(SRC)
	$(GCCARM) -o edtest $^ $(CFLAGS) $(LIBS)
	
bins: $(SRC)
	gcc -o edtest $^ $(CFLAGS) $(LIBS)
