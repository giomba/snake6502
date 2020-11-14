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

#if VERBOSE = 1
    ; Locations $90-$FF in zeropage are used by kernal
    ECHO "End of zeropage variables. Space left: ",($90 - .)
#endif

; SID tune (previously properly cleaned, see HVSC)
; ----------------------------------------------------------------------
    SEG sidSegment
    org $1000
sidtune:
    INCBIN "../res.bin/amour.sid"
#if VERBOSE = 1
    ECHO "End of SIDtune at ",.,"Space left:",($2000 - .)
#endif

; Font Data
; ----------------------------------------------------------------------
    SEG fontSegment
    org $2000
; This binary data that defines the font is exactly 2kB long ($800)
    INCLUDE "font.asm"

; Program Segment
; ----------------------------------------------------------------------
    SEG programSegment
    org $2800
    INCLUDE "program.asm"
    INCLUDE "initdata.asm"
    INCLUDE "game.asm"
    INCLUDE "gameover.asm"
    INCLUDE "introreset.asm"
    INCLUDE "subroutines.asm"
    INCLUDE "levels.asm"
    INCLUDE "intro1.asm"
    INCLUDE "multicolor.asm"
    INCLUDE "levelreset.asm"
    INCLUDE "outro.asm"
#if VERBOSE = 1
    ECHO "End of program segment at:",.
    ECHO "PACK SIZE:",(. - $1000),"=",[(. - $1000)d]
#endif

; Data variables
; -----------------
    SEG.U dataSegment
    org $cd00
    INCLUDE "data.asm"
#if VERBOSE = 1
    ECHO "End of Data segment. Space left:",($ce00 - .)
#endif

; Lists
; -----------------
    SEG.U listSegment
    org $ce00
listX DS 256
listY DS 256

;
; coded 2017, 2018, 2019, 2020
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;
