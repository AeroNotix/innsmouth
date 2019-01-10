#include "nes.h"

#define JOY1 0x4016

#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))

#define JOYPAD1_READ PEEK(JOY1)
