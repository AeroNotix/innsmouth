.export load_main_palette

.include "macros.inc"
.include "nes.inc"

.proc load_main_palette
    PPU_REQUEST #$3F, #$00
    LDX #$00
copypalloop:
  LDA initial_palette,x
  STA PPUDATA
  INX
  CPX #32
  BCC copypalloop
  RTS
.endproc

.segment "RODATA"
initial_palette:
  .byt $22,$18,$28,$38,$0F,$06,$16,$26,$0F,$08,$19,$2A,$0F,$02,$12,$22
  .byt $22,$08,$16,$37,$0F,$06,$16,$26,$0F,$0A,$1A,$2A,$0F,$02,$12,$22
