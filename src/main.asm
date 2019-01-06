.segment "CODE"

.include "nes.inc"
.include "macros.inc"
.include "constants.inc"
.include "globals.inc"
.import load_graphics_into_ppu

.segment "ZEROPAGE"
CURRENT_CHAR: .res 1

.segment "CODE"

.proc irq_handler
    RTI
.endproc

.proc nmi_handler
    LDA #0
    STA OAMADDR
    LDA #>OAM
    STA OAM_DMA
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
    LDX #OBJ_ON | BG_OFF
    STX PPUMASK

    JSR update_graphics
    JMP main
.endproc

.proc main
    JMP main
.endproc

.segment "CHR"
    .incbin "obj/nes/bggfx.chr"
    .incbin "obj/nes/spritegfx.chr"
