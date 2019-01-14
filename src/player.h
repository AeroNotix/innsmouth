#ifndef PLAYER_H
#define PLAYER_H 1

#define ACCELERATE_RATE 1
#define DECELERATE_RATE 1
#define MAX_SPEED 4

typedef enum horizontal_direction{h_none, h_left, h_right} H_DIR;
typedef enum vertical_direction{v_none, v_up, v_down} V_DIR;

typedef struct Player {
    H_DIR h_dir;
    V_DIR v_dir;

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
