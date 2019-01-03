.proc clearsprites
    LDA #$00
    LDX #$00
clearnextsprite:
    STA SPRITE, X
    INX
    BNE clearnextsprite
    RTS
.endproc

.proc initsprite
    lda #$70
    sta SPRITE          ; Y coordinate
    lda #$01
    sta SPRITE+1        ; Pattern number
    sta SPRITE+3        ; X coordinate
                            ; sprite+2, color, stays 0.

    rts
.endproc

.proc dma_sprite_table
    lda #>SPRITE
    sta $4014
    RTS
.endproc

.proc loadpalette
    PPU_REQUEST #$3F, #$00
continue_palette_write:
    LDA palette, X
    STA PPUDATA
    INX
    CPX #$20
    BNE continue_palette_write
    RTS
.endproc

.proc initgraphics
    JSR loadpalette
    JSR clearsprites
    JSR initsprite
    RTS
.endproc
