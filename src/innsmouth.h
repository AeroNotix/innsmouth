#ifndef INNSMOUTH_H
#define INNSMOUTH_H 1

#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))

#endif
