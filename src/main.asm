.segment "CODE"

.include "nes.inc"
.include "macros.inc"
.include "constants.inc"
.include "globals.inc"

.segment "ZEROPAGE"
VBLANK_COUNTER: .res 1
BACKGROUND_INDEX:   .res 1

.segment "CODE"

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

    WAIT_FOR_VBLANK

    ;; Set PPU Mask parameters
    LDX #OBJ_ON | BG_ON
    STX PPUMASK

    WAIT_FOR_VBLANK

.endproc

.proc main
    ;; Infinite loop - all logic is done within VBLank NMI code
    JMP main
.endproc
