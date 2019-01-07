.importzp buttons, x_pos, y_pos
.export update_graphics, OAM

;;; CPU RAM copy of OAM
OAM = $0200

.proc update_graphics
    LDX #0
next_graphic:
    LDA y_pos
    STA OAM
    LDA #20
    STA OAM+1,x
    LDA #7
    STA OAM+2,x
    LDA x_pos
    STA OAM+3,x
    RTS
.endproc
