;; -*- asm -*-
.ifndef GLOBAL_INC
.define GLOBAL_INC

;;; main.asm
.global nmi_handler, irq_handler, reset_handler

;;; graphics.c
.global _update_player_graphics

;;; input.asm
.global handle_input

;;; zp.asm
.globalzp _buttons, graphics_need_update

;; player.c
.global _init_player, _add_directional_acceleration, _decelerate, _move_player, _read_pads_once
.endif
