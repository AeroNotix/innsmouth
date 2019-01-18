#ifndef PLAYER_H
#define PLAYER_H 1

#include <stdbool.h>

#define ACCELERATE_RATE 100
#define DECELERATE_RATE 100
#define MAX_WALK_SPEED 750
#define MAX_RUN_SPEED 1500

typedef enum direction{left, right, up, down} DIR;

typedef struct Player {
    DIR h_dir;
    DIR v_dir;

    signed char x_pos;
    signed char y_pos;

    int x_vel;
    int y_vel;

    signed char sprite_index;
    signed char palette_index;

    bool running;

} Player;

#pragma bss-name("ZEROPAGE")
extern Player player;

#endif
