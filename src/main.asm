.segment "CODE"

.include "nes.inc"
.include "macros.inc"
.include "constants.inc"
.include "globals.inc"

.import load_graphics_into_ppu, load_main_palette, handle_input, _update_player_graphics
.importzp _x_pos, _y_pos, graphics_need_update

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

    JSR handle_input
    JSR _update_player_graphics

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

    JSR _init_player

    JSR _update_player_graphics
    JSR load_main_palette

    JMP main
.endproc

.proc main
skip:
    JMP main
.endproc

.segment "CHR"
    .incbin "obj/nes/bggfx.chr"
    .incbin "obj/nes/spritegfx.chr"
