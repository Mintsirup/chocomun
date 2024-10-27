CC = /usr/local/arm/3.3.2/bin/arm-linux-gcc
LD = arm-linux-ld
OC = arm-linux-objcopy

CFLAGS	= -nostdinc -I. -I./include
CFLAGS	+= -Wall -Wstrict-prototypes -Who-trigraphs -02
CFLAGS	+= -fno-strict-aliasing
CFLAGS	+= -mcpu=xscale -mshort-load-bytes -msoft-float -fno-builtin

LDFLAGS	= -static -nostdlib -nostartfiles -nodefaultlibs -p -X -T ./main-ld-script

OCFLAGS	= -O binary -R .note -R .comment -S
all: choco.c
	$(CC) -c $(CFLAGS) -o entry.o entry.S
	$(CC) -c $(CFLAGS) -o gpio.o gpio.c
	$(CC) -c $(CFLAGS) -o time.o time.c
	$(CC) -c $(CFLAGS) -o vsprintf.o vsprintf.c
	$(CC) -c $(CFLAGS) -o printf.o printf.c
	$(CC) -c $(CFLAGS) -o string.o string.c
	$(CC) -c $(CFLAGS) -o serial.o serial.c
	$(CC) -c $(CFLAGS) -o lib1funcs.o lib1funcs.S
	$(CC) -c $(CFLAGS) -o choco.o choco.c
	$(LD) $(LDFLAGS) -o choco_elf entry.o gpio.o time.o vsprintf.o printf.o string.o serial.o lib1funcs.o choco.o
	$(OC) $(OCFLAGS) choco_elf choco_img
	$(CC) -c $(CFLAGS) -o serial.o serial.c -D IN_GUNSTIX
	$(LD) $(LDFLAGS) -o choco_gum_elf entry.o gpio.o time.o vsprintf.o printf.o>
	$(OC) $(OCFLAGS) choco_gum_elf choco_gum_img


clean:
	rm *.o
	rm choco_elf
	rm choco_img
	rm choco_gum_elf
	rm choco_gum_img
