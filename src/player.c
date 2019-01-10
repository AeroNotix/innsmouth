#include "nes.h"

#define ACCELERATE_AMOUNT 1
#define DECELERATE_AMOUNT 20
#define MAX_SPEED 100

extern char buttons;
#pragma zpsym("buttons");

#pragma bss-name("ZEROPAGE")

int x_pos;
int y_pos;

signed char x_pos_hi;
signed char x_pos_lo;
signed char y_pos_hi;
signed char y_pos_lo;

unsigned char x_vel;
unsigned char y_vel;

#pragma bss-name("CODE")

void init_player() {
    x_pos = 0;
    y_pos = 0;
    x_pos_hi = 0;
    x_pos_lo = 0;
    y_pos_hi = 0;
    y_pos_lo = 0;
    x_vel = 0;
    y_vel = 0;
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

void add_right_accel() {
    if (buttons & 0x01 == 0x01) {
        x_vel = x_vel + ACCELERATE_AMOUNT;
    } else {
        /* x_vel = max(x_vel - DECELERATE_AMOUNT, 0); */
    }
}

void add_left_accel() {
    /* if (buttons & 0x02 && x_vel > -MAX_SPEED) { */
    /*     x_vel -= ACCELERATE_AMOUNT; */
    /* } else { */
    /*     //x_vel += DECELERATE_AMOUNT; */
    /* } */
}
