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
    SEG.U zeropageSegment
    org $02
    INCLUDE "zeropage.asm"

    ; Initialized segments
    SEG basicSegment
    org $801
    INCLUDE "basic.asm"

    SEG dataSegment
    org $900
    INCLUDE "data.asm"
    INCLUDE "const.asm"

; List
; ----------------------------------------------------------------------
. = $e00
listX:
. = $f00
listY:

; SID tune (previously properly cleaned, see HVSC)
; ----------------------------------------------------------------------
    SEG sidSegment
    org $1000
sidtune:
    INCBIN "amour.sid"
#if DEBUG = 1
    ECHO "End of SIDtune. Space left: ",($2000 - .)
#endif

; Font Data
; ----------------------------------------------------------------------
    SEG tggsSegment
    org $2000
; This binary data that defines the font is exactly 2kB long ($800)
tggsFont:
    INCBIN "tggs.font"

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
    ECHO "Program ends at: ",.
#endif

;
; coded during december 2017
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;

; vim: set expandtab tabstop=4 shiftwidth=4:
