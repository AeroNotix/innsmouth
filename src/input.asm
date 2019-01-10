.importzp _buttons, _x_pos, _y_pos, _x_vel
.import _add_right_accel, _add_left_accel, _move_player, _decelerate, _read_pads_once
.export handle_input

.include "macros.inc"
.include "nes.inc"

.segment "CODE"

.proc handle_input
    JSR _read_pads_once
    JSR _add_right_accel
    JSR _add_left_accel
    JSR _decelerate
    JSR _move_player
    RTS
.endproc
