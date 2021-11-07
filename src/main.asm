    processor 6502

    SEG.U zeropageSegment
ORG_ZEROPAGE EQU $02
    org ORG_ZEROPAGE

    SEG sidSegment
ORG_SID EQU $1000
    org ORG_SID
ORG_FONT EQU $2400
    SEG fontSegment
    org ORG_FONT
ORG_PROGRAM EQU $2800
    SEG programSegment
    org ORG_PROGRAM

ORG_DATA EQU $cd00
    SEG.U dataSegment
    org ORG_DATA

; INCLUDE
; -----------------------------------------------------------------------------
LASTINIT SET ORG_SID
    INCLUDE "sidtune.asm"
    ECHO "sidtune : start ",LASTINIT," end ",.," size ",(. - LASTINIT)

LASTINIT SET ORG_FONT
    INCLUDE "font.asm"
    ECHO "font    : start ",LASTINIT," end ",.," size ",(. - LASTINIT)

LASTINIT SET ORG_PROGRAM
    INCLUDE "program.asm"
    INCLUDE "initdata.asm"
    INCLUDE "game.asm"
    INCLUDE "gameover.asm"
    INCLUDE "subroutines.asm"
    INCLUDE "levels.asm"
    INCLUDE "intro1.asm"
    INCLUDE "multicolor.asm"
    INCLUDE "levelreset.asm"
    INCLUDE "outro.asm"
    INCLUDE "data.asm"
    INCLUDE "macro.asm"
    ECHO "program : start ",LASTINIT," end ",.," size ",(. - LASTINIT)

;
; coded 2017, 2018, 2019, 2020, 2021
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;
