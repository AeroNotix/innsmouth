;; -*- asm -*-
.ifndef GLOBAL_INC
.define GLOBAL_INC

;;; main.asm
.global nmi_handler, irq_handler, reset_handler

;;; graphics.asm
.global update_graphics, OAM

;;; input.asm
.global handle_input

;;; zp.asm
.globalzp _buttons, graphics_need_update

;; player.c
.globalzp _x_pos, _y_pos, _x_vel, _y_vel
.global _init_player, _add_right_accel, _add_left_accel, _move_player, _read_pads_once
.endif
