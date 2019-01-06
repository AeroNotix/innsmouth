.export update_graphics, OAM

;;; CPU RAM copy of OAM
OAM = $0200

.proc update_graphics
    LDX #0
next_graphic:
    STX OAM
    LDA #126
    STA OAM+1,x
    LDA #7
    STA OAM+2,x
    LDA #0
    STA OAM+3,x
    RTS
.endproc
