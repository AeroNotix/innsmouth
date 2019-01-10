.importzp _buttons, _x_pos, _y_pos, _x_vel
.import _add_right_accel, _add_left_accel, _move_player
.export read_pads, handle_input

.include "macros.inc"
.include "nes.inc"

.segment "CODE"

.proc read_pads
    JSR read_pads_once
.endproc

.proc read_pads_once
    STROBE_JOYPADS _buttons
next_key:
    LDA JOY1
    CMP #%00000001
    AND #$01
    LSR A
    ROL _buttons
    BCC next_key
    RTS
.endproc

.proc handle_input
    JSR read_pads
    JSR _add_right_accel
    JSR _add_left_accel
    JSR _move_player
    RTS
.endproc
