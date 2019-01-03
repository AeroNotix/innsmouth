.proc clear_memory
    LDA     #$00
    STA     $0000, X
    STA     $0100, X
    STA     $0300, X
    STA     $0400, X
    STA     $0500, X
    STA     $0600, X
    STA     $0700, X
    INX
    BNE     clear_memory
    RTS
.endproc
