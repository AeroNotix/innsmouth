.include "globals.inc"
.include "macros.inc"

.importzp buttons, _x_pos, _y_pos, x_velocity, y_velocity
.export update_graphics, OAM

;;; CPU RAM copy of OAM
OAM = $0200

.proc update_graphics
    LDX #0
next_graphic:
    WRITE_OAM _y_pos, #20, #7, _x_pos, X
    RTS
.endproc
