.segment "HEADER"
.byte "NES", 26, 2, 1, 0, 0

.segment "ZEROPAGE"

VBLANK_COUNTER:
    .byte $00
BACKGROUND_INDEX:
    .byte $00

.segment "CODE"

.include "include/defines.asm"
.include "include/macros.asm"

;;; Simple pallete
palette:
.byte $0E,$00,$0E,$19,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$21
.byte $0E,$20,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0


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
    RTS
.endproc

.proc irq_handler
    RTI
.endproc

.proc nmi_handler
    ;; Every $10 Vblanks, change the background colour (BACKGROUND_INDEX contains the
    ;; bg colour)

    ;; Set X to desired number of vblanks to wait before changing colour
    LDX #$10
    ;; increment vblank counter
    INC VBLANK_COUNTER
    ;; Did we reach desired vblank count?
    CPX VBLANK_COUNTER
    ;; if not, return from NMI handler
    BNE retnmi
    ;; if so, increment to the next bg colour
    INC BACKGROUND_INDEX

    ;; Reset vblank counter
    LDX #$00
    STX VBLANK_COUNTER

    ;; Write the background to the PPU
    PPU_WRITE #$3F, #$00, BACKGROUND_INDEX

    ;; Do something with the PPU?
    LDA #%00011110
    STA PPUMASK
retnmi:
    RTI
.endproc

.proc reset_handler
    ;; basic "voodoo" prevention
    ;; * disable interrupts
    ;; * clear decimal bit
    ;; (should also realistically set RAM(s) to known values)
    SEI
    CLD
    ;;  end voodoo prevention

    ;; Initialize PPU Control Register One parameters
    ;; Generate NMI on VBlank ENABLED
    LDX #%10000000
    STX PPUCTRL

    ;; Initialize PPU Control Register Two Parameters
    ;; All DEFAULT
    LDX #%00000000
    STX PPUMASK

    ;; Set the stack pointer
    LDX #$FF
    TXS

    JSR initgraphics

    ;; Re-enable interrupts
    CLI

vblankwait:
    ;; wait for PPU to stabilize
    BIT PPUSTATUS
    BPL vblankwait
    JMP main
.endproc

.proc main
    ;; Infinite loop - all logic is done within VBLank NMI code
    JMP main
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHARS"
.res 8192
.segment "STARTUP"
