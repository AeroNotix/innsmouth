#include "nes.h"
#include "innsmouth.h"
#include "player.h"

#pragma zpsym("player");

#define OAM 0x0200

#pragma bss-name("CODE")

void __fastcall__ update_player_graphics(void) {
    POKE(OAM, player.y_pos);
    POKE(OAM+1, player.sprite_index);
    POKE(OAM+2, player.palette_index);
    POKE(OAM+3, player.x_pos);
}
