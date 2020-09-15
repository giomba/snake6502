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

; Initialized segments
; ----------------------------------------------------------------------
    SEG autostartSegment
#if CARTRIDGE = 0
    org $801
    INCLUDE "basic.asm" ; BASIC _MUST_ stay at this address
#else
    org $800
    INCLUDE "cart.asm"
#endif
    INCLUDE "initdata.asm"

; Program "Segment" Low
; ----------------------------------------------------------------------
; You just have to fill this empty space, don't you think so? ;-)
    INCLUDE "game.asm"
    INCLUDE "gameover.asm"
    INCLUDE "introreset.asm"
    INCLUDE "program.asm"
    INCLUDE "subroutines.asm"
    INCLUDE "levels.asm"
    INCLUDE "intro1.asm"
; Note: some code had to be included at an higher address

#if VERBOSE = 1
    ECHO "End of Low Program Segment. Space left:",($1000 - .)
#endif

; SID tune (previously properly cleaned, see HVSC)
; ----------------------------------------------------------------------
    SEG sidSegment
    org $1000
sidtune:
    INCBIN "../res.bin/amour.sid"
#if VERBOSE = 1
    ECHO "End of SIDtune at ",.
#endif
    INCLUDE "multicolor.asm"
    INCLUDE "levelreset.asm"
    INCLUDE "outro.asm"
#if VERBOSE = 1
    ECHO "End of Middle Program Segment. Space left:",($2000 - .)
#endif

; Font Data
; ----------------------------------------------------------------------
    SEG tggsSegment
    org $2000
; This binary data that defines the font is exactly 2kB long ($800)
tggsFont:
    INCLUDE "tggs.asm"

; Program Segment High
; ----------------------------------------------------------------------

#if VERBOSE = 1
    ECHO "End of High Program Segment at: ",.,"Space left:",($cd00 - .)
#endif

#if VERBOSE = 1
#if CARTRIDGE = 0
    ; +2 because of PRG header
    ECHO "PRG size:",([. - $801 + 2]d),"dec"
#else
    ECHO "BIN size:",([. - $800]d),"dec"
#endif
#endif

; Uninitialized segments
; ----------------------------------------------------------------------
; Cartridge locations
; -------------------
    SEG.U cartridgeSegment
    org $8000
cartridgeStart:

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
; coded during december 2017
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;

; vim: set expandtab tabstop=4 shiftwidth=4:
