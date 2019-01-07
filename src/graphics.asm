.include "macros.inc"

.importzp buttons, x_pos, y_pos
.export update_graphics, OAM

;;; CPU RAM copy of OAM
OAM = $0200

.proc update_graphics
    LDX #0
next_graphic:
    WRITE_OAM y_pos, #20, #7, x_pos, X
    RTS
.endproc
