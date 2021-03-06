CC=sparc-elf-gcc
SIZE=sparc-elf-size
OBJCPY=sparc-elf-objcopy
OBJDMP=sparc-elf-objdump

CFLAGS=-msoft-float -Wall -O0
LDFLAGS=-qsvt -qnoambapp
#DEFINES=-DLEON -DBSIZE=10 -DDEBUG
#DEFINES=-DLEON -DBSIZE=10 -DSINGLERUN -DGPIODBG
#DEFINES=-DLEON -DBSIZE=10 -DSINGLEPROC -DGPIODBG
DEFINES=-DLEON -DBSIZE=10


TARGET=main
SOURCES= bubblesort.c main.c
OBJECTS=$(SOURCES:.c=.o)
#DEST=/Home/
#DEST=/home/pvilla/phd/grlib-gpl-1.4.1-b4156/designs/leon3mp/
DEST=/home/estevanlara/Downloads/grlib-gpl-20184.1-b4217/designs/leon3-xilinx-ml510
#target: dependecies
#(tab) commands
all: comp

#target for all objects, dependencies all sources
#this is what is called when the comp target is called
#note: $@ means the left part of the :, all the objects in this case
#      $^ means the right part of the :, all the C sources in this case
%.o: %.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $^ $(LDFLAGS)


#special target that has a non-C source
testandset.o: testandset.s
	$(CC) $(CFLAGS) -c -o $@ $^ $(LDFLAGS)

#link all objects into the executable
#this invoke each item in the $(OBJECTS) variable
comp: $(OBJECTS) testandset.o
	$(CC) $(CFLAGS) $(DEFINES) -o $(TARGET).exe $^ $(LDFLAGS)

srec: comp
	$(SIZE) $(TARGET).exe
	$(OBJCPY) -O srec --gap-fill 0 $(TARGET).exe ram.srec

copy: srec
	cp ram.srec $(DEST)

dump: comp
	$(OBJDMP) -D $(TARGET).exe > $(TARGET).dump

clean:
	rm -rf $(TARGET).exe ram.srec *.o $(TARGET).dump
