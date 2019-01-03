ASM_FILES=$(wildcard *.asm)
OBJ_FILES=$(patsubst %.asm,%.o,${ASM_FILES})

all: innsmouth.nes

clean:
	@rm *.nes *.o

innsmouth.nes: innsmouth.o
	@ld65 innsmouth.o -t nes -o innsmouth.nes

%.o: %.asm
	ca65 $^ -o $@

play: all
	mesen innsmouth.nes
