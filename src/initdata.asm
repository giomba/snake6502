    SEG programSegment
; Initialized variables
; ----------------------------------------------------------------------

; Intro counter
introCounter:
    BYTE #$4

; Intro string x position, and next increment
introX:
    BYTE #$0
introXinc:
    BYTE #$1

; Delay
delay:
    BYTE #$ff

; Costants
; ----------------------------------------------------------------------

; Status of the game (costants pre-processor defined, sort of enum)
ST_INTRO0       =   0
ST_INTRO1       =   1
ST_INTRO2       =   2
ST_INTRO3       =   3
ST_INTRO4       =   4
ST_INTRO5       =   5
ST_INTRO6       =   6
ST_INTRO7       =   7
ST_INTRO8       =   8
ST_MENURESET    =   64
ST_MENU         =   65
ST_LEVEL_TITLE  =   128
ST_LEVEL_LOAD   =   129
ST_PLAY         =   130
ST_DELAY        =   131
ST_END          =   132
ST_PAUSE        =	255

; Screen features
SCREEN_W    =   40
SCREEN_H    =   24

; Tiles
; -----
EMPTY_TILE  =   $e0
SNAKE_TILE  =   $e1
FOOD_TILE   =   $e2
WALL_TILE   =   $e3

; Tiles colors
; Note: these colors will be picked by the level select routine
;   thus their order must match those of the values assigned to tiles
tilesColors:
EMPTY_COLOR:
    BYTE $0
SNAKE_COLOR:
    BYTE $d
FOOD_COLOR:
    BYTE $a
WALL_COLOR:
    BYTE $8

; Strings
; ----------------------------------------------------------------------

gameoverString:
    BYTE "GAME IS OVER"
    BYTE #0
intro2string:
    BYTE "RETROFFICINA.GLGPROGRAMS.IT"
    BYTE #0
intro3string:
#if DEBUG = 1
	BYTE "DBG RELS"
#else
    BYTE "2017 (C) 2021"
#endif
    BYTE #0
levelIntroString:
    BYTE "NEXT LEVEL"
    BYTE #0
scoreString:
	BYTE "SCORE      PART"
	BYTE #0
noMoreLevelsString:
    BYTE "NO MORE LEVELS"
    BYTE #0
introStringA1:
    BYTE "RETROFFICINA"
    BYTE #$0
introStringA2:
    BYTE "AND"
    BYTE #$0
introStringA3:
    BYTE "GIOMBA"
    BYTE #$0
introStringA4:
    BYTE "PRESENT"
    BYTE #$0
introStringA5:
    BYTE "A COMMODORE 64"
    BYTE #$0
introStringA6:
    BYTE "VIDEOGAME"
    BYTE #$0

; Levels
; ----------------------------------------------------------------------
levelsList:
    INCBIN "../res.bin/levels.bin"
