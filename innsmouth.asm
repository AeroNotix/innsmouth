.segment "HEADER"
.byte "NES", 26, 2, 1, 0, 0

.segment "CODE"

.include "include/defines.asm"

.proc irq_handler
    RTI
.endproc

.proc nmi_handler
    ;; Every $10 Vblanks, change the background colour ($00FF contains the
    ;; bg colour)

    ;; Set X to desired number of vblanks to wait before changing colour
    LDX #$10
    ;; increment vblank counter
    INC $00DD
    ;; Did we reach desired vblank amount?
    CPX $00DD
    ;; if not, return from NMI handler
    BNE retnmi
    ;; if so, increment the bg colour and reset vblank counter
    INC $00FF

    LDX #$00
    STX $00DD
    LDX #$3f
    STX $2006
    LDX #$00
    STX $2006
    LDA $00FF
    STA $2007
    LDA #%00011110
    STA $2001

retnmi:
    RTI
.endproc

.proc reset_handler
    ;; basic "voodoo" prevention reset
    ;; * disable interrupts
    ;; * clear decimal bit
    SEI
    CLD
    ;;  end voodoo prevention

    ;; Initialize PPU Control Register One parameters
    ;; Generate NMI on VBlank ENABLED
    LDX #%10000000
    STX PPUCTRL0

    ;; Initialize PPU Control Register Two Parameters
    ;; All DEFAULT
    LDX #%00000000
    STX PPUCTRL1

    ;; Set the bg colour to $00
    LDX #$00
    STX $00FF

    ;; Set the VBlank counter to zero
    LDX #$00
    STX $00DD

vblankwait:
    ;; wait for PPU to stabilize
    BIT PPUSTATUS
    BPL vblankwait
    JMP main
.endproc

.proc main
    JMP main
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHARS"
.res 8192
.segment "STARTUP"
