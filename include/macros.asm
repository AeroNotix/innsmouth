;;; A simple macro to shorten setting the PPU request address
.macro PPU_REQUEST highbyte, lowbyte
    LDX highbyte
    LDA lowbyte
    STX PPUADDR
    STA PPUADDR
.endmacro

.macro PPU_WRITE highbyte, lowbyte, data
    PPU_REQUEST highbyte, lowbyte
    LDA data
    STA PPUDATA
.endmacro
