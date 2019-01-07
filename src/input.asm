.importzp buttons, x_pos, y_pos
.export read_pads, handle_input

.include "macros.inc"

JOY1      = $4016
JOY2      = $4017

BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

.segment "CODE"

.proc read_pads
    ;; Absolutely not halal
    ;;  The movement should be velocity-based not pixel-based, fix
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
    JSR read_pads_once
.endproc

.proc read_pads_once
    STROBE_JOYPADS buttons
next_key:
    LDA JOY1
    CMP #%00000001
    AND #$01
    LSR A
    ROL buttons
    BCC next_key
    RTS
.endproc

.proc handle_input
    JSR read_pads
    LDA buttons
    CMP #BUTTON_RIGHT
    BEQ inc_x
    CMP #BUTTON_LEFT
    BEQ dec_x
    CMP #BUTTON_UP
    BEQ dec_y
    CMP #BUTTON_DOWN
    BEQ inc_y
    RTS
inc_x:
    INC x_pos
    RTS
dec_x:
    DEC x_pos
    RTS
inc_y:
    INC y_pos
    RTS
dec_y:
    DEC y_pos
    RTS
.endproc
