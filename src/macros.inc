;; -*- asm -*-

.ifndef MACROS_INC
.define MACROS_INC

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

.macro WAIT_FOR_VBLANK
    :    ;; Wait for PPU to stabilize
    BIT PPUSTATUS
    BPL :-
.endmacro

.macro STROBE_JOYPADS counter
    ;;; We need to strobe bit 0 of JOY1 in order to reload the keys.
    ;;; We set JOY1 bit 0 to 1, then zero. Bit 0=1 continually reloads
    ;;; the keys, we toggle this bit to read a single snapshot.

    ;; First send a 1 to JOY1
    LDA #$01
    STA JOY1
    STA counter
    LSR A                       ; A is now 0 (LSR is potentially a quicker op then LDA 0)
    STA JOY1                    ; send 0 to JOY1, joypad reloading stops
    ;; The joypads have now been reloaded and their state will be constant
.endmacro

.endif
