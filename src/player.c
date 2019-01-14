#include "innsmouth.h"
#include "nes.h"
#include "input.h"
#include "player.h"

extern char buttons;

#define CLAMP(VALUE, MAX) do { if (VALUE > MAX) { VALUE = MAX; } } while(0)

#pragma zpsym("buttons");

#pragma bss-name("ZEROPAGE")

// cc65 doesn't really quite allow stack allocated memory
Player player;

#pragma bss-name("CODE")

void __fastcall__  init_player(void) {
    player.h_dir = left;
    player.v_dir = right;
    player.x_pos = 0;
    player.y_pos = 0;
    player.x_vel = 0;
    player.y_vel = 0;

    // todo: define these numbers
    player.sprite_index = 20;
    player.palette_index = 7;
}

void __fastcall__  read_pads_once(void) {
    POKE(JOY1, 1);
    POKE(JOY1, 0);
    buttons = 0;
    // manually -funroll'd
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    buttons = (buttons << 1) | (JOYPAD1_READ & 1);
}


void __fastcall__  move_player(void) {
    if (player.h_dir == right) {
        player.x_pos += player.x_vel;
    } else {
        player.x_pos -= player.x_vel;
    }
    if (player.v_dir == down) {
        player.y_pos += player.y_vel;
    } else {
        player.y_pos -= player.y_vel;
    }
}

void __fastcall__  add_up_accel(void) {
    if (buttons & 8) {
        player.v_dir = up;
        player.y_vel += ACCELERATE_RATE;
        CLAMP(player.y_vel, MAX_SPEED);
    }
}

void __fastcall__  add_down_accel(void) {
    if (buttons & 4) {
        player.v_dir = down;
        player.y_vel += ACCELERATE_RATE;
        CLAMP(player.y_vel, MAX_SPEED);
    }
}

void __fastcall__  add_right_accel(void) {
    if (buttons & 1) {
        player.h_dir = right;
        player.x_vel += ACCELERATE_RATE;
        CLAMP(player.x_vel, MAX_SPEED);
    }
}

void __fastcall__  add_left_accel(void) {
    if (buttons & 2) {
        player.h_dir = left;
        player.x_vel += ACCELERATE_RATE;
        CLAMP(player.x_vel, MAX_SPEED);
    }
}

void __fastcall__  decelerate(void) {
    if (!(buttons & 1) && !(buttons & 2)) {
        if (player.x_vel > 0) {
            player.x_vel -= DECELERATE_RATE;
        }
    }

    if (!(buttons & 4) && !(buttons & 8)) {
        if (player.y_vel > 0) {
            player.y_vel -= DECELERATE_RATE;
        }
    }
}
