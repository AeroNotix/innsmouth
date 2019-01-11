#include "nes.h"
#include "input.h"

#define ACCELERATE_RATE 1
#define DECELERATE_RATE 1
#define MAX_SPEED 5

extern char buttons;
#pragma zpsym("buttons");

#pragma bss-name("ZEROPAGE")

// cc65 doesn't really quite allow stack allocated memory
char accumulate_buttons;
char x;

int x_pos;
int y_pos;

signed char x_vel;
signed char y_vel;

#pragma bss-name("CODE")

void __fastcall__  init_player(void) {
    x_pos = 0;
    y_pos = 0;
    x_vel = 0;
    y_vel = 0;
}

void __fastcall__  read_pads_once(void) {
    POKE(JOY1, 1);
    POKE(JOY1, 0);
    buttons = 0;
    for (x = 0; x < 8; x++) {
        buttons = (buttons << 1) | (JOYPAD1_READ & 1);
    }
}

signed char max(signed char a, signed char b) {
    if (a > b) {
        return a;
    }
    return b;
}

void move_player() {
    x_pos += x_vel;
    y_pos += y_vel;
}

void __fastcall__  add_up_accel(void) {
    if (buttons & 8) {
        y_vel -= ACCELERATE_RATE;
        if (y_vel < -MAX_SPEED) {
            y_vel = -MAX_SPEED;
        }
    }
}

void __fastcall__  add_down_accel(void) {
    if (buttons & 4) {
        y_vel += ACCELERATE_RATE;
        if (y_vel > MAX_SPEED) {
            y_vel = MAX_SPEED;
        }
    }
}

void __fastcall__  add_right_accel(void) {
    if (buttons & 1) {
        x_vel += ACCELERATE_RATE;
        if (x_vel > MAX_SPEED) {
            x_vel = MAX_SPEED;
        }
    }
}

void __fastcall__  add_left_accel(void) {
    if (buttons & 2) {
        x_vel -= ACCELERATE_RATE;
        if (x_vel < -MAX_SPEED) {
            x_vel = -MAX_SPEED;
        }
    }
}

void __fastcall__  decelerate(void) {
    if (!(buttons & 1) && !(buttons & 2)) {
        if (x_vel < 0) {
            x_vel += DECELERATE_RATE;
        }
        if (x_vel > 0) {
            x_vel -= DECELERATE_RATE;
        }
    }

    if (!(buttons & 4) && !(buttons & 8)) {
        if (y_vel < 0) {
            y_vel += DECELERATE_RATE;
        }
        if (y_vel > 0) {
            y_vel -= DECELERATE_RATE;
        }
    }
}
