    processor 6502

; Platform specific code
; Code yet to be developed, example to use:
; ----------------------------------------------------------------------
#if SYSTEM = 64
    ; Commodore64 specific code
#else
    ; Commodore16 specific code
#endif

; Uninitialized zeropage segment
; ----------------------------------------------------------------------
    SEG.U zeropageSegment
    org $02
    INCLUDE "zeropage.asm"

#if DEBUG = 1
    ; Locations $90-$FF in zeropage are used by kernal
    ECHO "End of zeropage variables. Space left: ",($90 - .)
#endif

; Initialized segments
; ----------------------------------------------------------------------
    SEG dataSegment
    org $801
    INCLUDE "basic.asm" ; BASIC must stay at this address
    INCLUDE "data.asm"
    INCLUDE "const.asm"
#if DEBUG = 1
    ECHO "End of Data + Basic Segment. Space left: ",($1000 - .)
#endif


; SID tune (previously properly cleaned, see HVSC)
; ----------------------------------------------------------------------
    SEG sidSegment
    org $1000
sidtune:
    INCBIN "../res/amour.sid"
#if DEBUG = 1
    ECHO "End of SIDtune. Space left: ",($2000 - .)
#endif

; Font Data
; ----------------------------------------------------------------------
    SEG tggsSegment
    org $2000
; This binary data that defines the font is exactly 2kB long ($800)
tggsFont:
    INCLUDE "tggs.asm"

; Include program
; ----------------------------------------------------------------------
    SEG programSegment
    org $2800
    jmp start

    INCLUDE "game.asm"
    INCLUDE "gameover.asm"
    INCLUDE "gamereset.asm"
    INCLUDE "introreset.asm"
    INCLUDE "intro1.asm"
    INCLUDE "multicolor.asm"
    INCLUDE "outro.asm"
    INCLUDE "program.asm"
    INCLUDE "subroutines.asm"

#if DEBUG = 1
    ECHO "End of program at: ",.,"Space left:",($ce00 - .)
#endif

#if DEBUG = 1
    ; +2 because of PRG header
    ECHO "PRG size:",([. - $801 + 2]d),"dec"
#endif

; Uninitialized list segment
; ----------------------------------------------------------------------
    SEG.U listSegment
    org $ce00
listX DS 256
listY DS 256

;
; coded during december 2017
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;

; vim: set expandtab tabstop=4 shiftwidth=4:
