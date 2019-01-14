#include "nes.h"
#include "input.h"

#define ACCELERATE_RATE 1
#define DECELERATE_RATE 1
#define MAX_SPEED 4

extern char buttons;
#pragma zpsym("buttons");

#pragma bss-name("ZEROPAGE")

// cc65 doesn't really quite allow stack allocated memory
char accumulate_buttons;
char x;

int x_pos;
int y_pos;

signed char ignore_vel;
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

signed char __fastcall__ max(signed char a, signed char b) {
    if (a > b) {
        return a;
    }
    return b;
}

// Todo: refactor following acceleration functions into offsets into a
// parameter list. Each L/R/U/D key can be used as the index into the
// table and the zeroth index can be a NOP.
//
// The implementation must take into account that cc65/6502 arrays are
// dog shit slow and are very chunky pieces of code when compiled.

/* struct acceleration_rate { */
/*     signed char* axis; */
/*     unsigned char rate; */
/* }; */

/* struct acceleration_rate acceleration_rates[] = { */
/*     {*ignore_vel, 0}, */
/*     {*x_vel, ACCELERATE_RATE} */
/* };

   void apply_acceleration() {
       up_operation = acceleration_rates[buttons & 8];
       *up_operation.axis += up_operation.rate
   }

   And so on for each keypress. The implementation ideally should be
   done in assembly since the generated code for this will be
   terrible.
*/


void __fastcall__  move_player(void) {
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
