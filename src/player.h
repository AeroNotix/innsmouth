#ifndef PLAYER_H
#define PLAYER_H 1

#define ACCELERATE_RATE 1
#define DECELERATE_RATE 1
#define MAX_SPEED 4

typedef enum direction{left, right, up, down} DIR;

typedef struct Player {
    DIR h_dir;
    DIR v_dir;

    int x_pos;
    int y_pos;

    signed char x_vel;
    signed char y_vel;

    signed char sprite_index;
    signed char palette_index;
} Player;

#pragma bss-name("ZEROPAGE")
extern Player player;

#endif
