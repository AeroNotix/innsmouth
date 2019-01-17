.importzp _buttons, _x_pos, _y_pos, _x_vel
.import _add_directional_acceleration, _move_player, _decelerate
.export handle_input

.include "macros.inc"
.include "nes.inc"

.segment "CODE"

.proc handle_input
    JSR _add_directional_acceleration
    JSR _decelerate
    JSR _move_player
    RTS
.endproc
