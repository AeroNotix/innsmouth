ASM_FILES=$(wildcard %.asm) # make this automatic

all:
	@ca65 innsmouth.asm && ld65 innsmouth.o -t nes -o innsmouth.nes

play: all
	mesen innsmouth.nes
