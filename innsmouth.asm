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
    ;; Did we reach desired vblank count?
    CPX $00DD
    ;; if not, return from NMI handler
    BNE retnmi
    ;; if so, increment to the next bg colour
    INC $00FF

    ;; Tell the PPU which address we're interested in
    LDX #$3f
    LDA #$00
    STX $2006
    STA $2006

    ;; Write to that address $3f00 the contents of $00FF (the next bg colour)
    LDA $00FF
    STA $2007

    ;; Do something with the PPU?
    LDA #%00011110
    STA $2001

    ;; Reset vblank counter
    LDX #$00
    STX $00DD

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
    STX PPUCTRL0

    ;; Initialize PPU Control Register Two Parameters
    ;; All DEFAULT
    LDX #%00000000
    STX PPUCTRL1

    ;; Set the next bg colour to $00
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
    ;; Infinite loop - all logic is done within VBLank NMI code
    JMP main
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHARS"
.res 8192
.segment "STARTUP"
