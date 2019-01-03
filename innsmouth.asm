.segment "HEADER"
.byte "NES", 26, 2, 1, 0, 0

SPRITE = $0200

.segment "ZEROPAGE"

.segment "SRAM1"

VBLANK_COUNTER:
    .byte $00
BACKGROUND_INDEX:
    .byte $00

.segment "STARTUP"

.segment "CODE"

palette:
.byte $0E,$00,$0E,$19,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$21
.byte $0E,$20,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0

.include "include/nes.inc"
.include "include/macros.inc"
.include "init.asm"
.include "graphics.asm"

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


retnmi:
    RTI
.endproc

.proc reset_handler
    ;; basic "voodoo" prevention
    ;; * disable interrupts
    ;; * clear decimal bit
    ;; * set stack pointer
    ;; * We should also set RAM to known values but w/e
    SEI
    CLD
    ;; Set the stack pointer
    LDX #$FF
    TXS
    ;;  end voodoo prevention

    WAIT_FOR_VBLANK

    ;; Initialize PPU Control Register One parameters
    LDX #VBLANK_NMI
    STX PPUCTRL

    ;; Set PPU Mask parameters
    LDX #OBJ_ON | BG_ON
    STX PPUMASK

.endproc

.proc main
    ;; Infinite loop - all logic is done within VBLank NMI code
    JMP main
.endproc

.segment "RODATA"

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHARS"
.res 8192
