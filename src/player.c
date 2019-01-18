#include "innsmouth.h"
#include "nes.h"
#include "input.h"
#include "player.h"

extern char buttons;

#define CLAMP(VALUE, MAX) do { if (VALUE > MAX) { VALUE = MAX; } } while(0)

#pragma zpsym("buttons");

#pragma bss-name("ZEROPAGE");

// cc65 doesn't really quite allow stack allocated memory
signed char x;
Player player;

#pragma bss-name("CODE")

void __fastcall__  init_player(void) {
    player.h_dir = left;
    player.v_dir = right;
    player.x_pos = 0;
    player.y_pos = 0;
    player.x_vel = 0;
    player.y_vel = 0;
    player.running = false;

    // todo: define these numbers
    player.sprite_index = 20;
    player.palette_index = 7;
}

void __fastcall__  read_pads_once(void) {
    POKE(JOY1, 1);
    POKE(JOY1, 0);
    buttons = 0;
    for (x = 0; x < 8; ++x) {
        buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    }
}

int min(int a, int b) {
    if (a > b) {
        return b;
    }
    return a;
}

/*
  Trying to implement 16-bit maths with CC65 is a pain. Not a lot
  works as expected. So I am left with this very repetitive code.
*/

void clamp_y(void) {
    if (player.running) {
        if (player.y_vel > MAX_RUN_SPEED) {
            player.y_vel = MAX_RUN_SPEED;
        }
    } else {
        if (player.y_vel > MAX_WALK_SPEED) {
            player.y_vel = MAX_WALK_SPEED;
        }
    }
}

void clamp_x(void) {
    if (player.running) {
        if (player.x_vel > MAX_RUN_SPEED) {
            player.x_vel = MAX_RUN_SPEED;
        }
    } else {
        if (player.x_vel > MAX_WALK_SPEED) {
            player.x_vel = MAX_WALK_SPEED;
        }
    }
}

void __fastcall__  move_player(void) {
    clamp_x();
    clamp_y();
    if (player.h_dir == right) {
        player.x_pos += (player.x_vel >> 8);
    } else {
        player.x_pos -= (player.x_vel >> 8);
    }
    if (player.v_dir == down) {
        player.y_pos += (player.y_vel >> 8);
    } else {
        player.y_pos -= (player.y_vel >> 8);
    }
}

void __fastcall__  add_directional_acceleration(void) {
    read_pads_once();

    if (buttons & 128) {
        player.running = true;
    } else {
        player.running = false;
    }

    if (buttons & 8) {
        if (player.v_dir == down) {
            player.y_vel = 0;
        } else {
            player.y_vel += ACCELERATE_RATE;
        }
        player.v_dir = up;
    }
    if (buttons & 4) {
        if (player.v_dir == up) {
            player.y_vel = 0;
        } else {
            player.y_vel += ACCELERATE_RATE;
        }
        player.v_dir = down;
    }
    if (buttons & 1) {
        if (player.h_dir == left) {
            player.x_vel = 0;
        } else {
            player.x_vel += ACCELERATE_RATE;
        }
        player.h_dir = right;

    }
    if (buttons & 2) {
        if (player.h_dir == right) {
            player.x_vel = 0;
        } else {
            player.x_vel += ACCELERATE_RATE;
        }
        player.h_dir = left;

    }
}

void __fastcall__  decelerate(void) {
    if (!(buttons & 1) && !(buttons & 2)) {
        player.x_vel -= DECELERATE_RATE;
        if (player.x_vel < 0) {
            player.x_vel = 0;
        }
    }

    if (!(buttons & 4) && !(buttons & 8)) {
        player.y_vel -= DECELERATE_RATE;
        if (player.y_vel < 0) {
            player.y_vel = 0;
        }
    }
}
