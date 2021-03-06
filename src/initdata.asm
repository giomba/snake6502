#if VERBOSE = 1
LASTINIT SET .
#endif

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
ST_LEVEL_TITLE  =   2
ST_LEVEL_LOAD   =   3
ST_PLAY         =   4
ST_DELAY        =   5
ST_END          =   6
ST_PAUSE        =	255

; Screen features
SCREEN_W    =   40
SCREEN_H    =   24

; Tiles
; -----
EMPTY_TILE  =   $60
SNAKE_TILE  =   $61
FOOD_TILE   =   $62
WALL_TILE   =   $63

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
intro0string:
#if SYSTEM = 64
    BYTE "   SNAKE BY GIOMBA   "
#else
	BYTE "  SNAKE16 BY GIOMBA  "
#endif
    BYTE #0
intro1string:
    BYTE " PRESS SPACE TO PLAY "
    BYTE #0
intro2string:
    BYTE "RETROFFICINA.GLGPROGRAMS.IT"
    BYTE #0
intro3string:
#if DEBUG = 1
	BYTE "DBG RELS"
#else
    BYTE "(C) 2018"
#endif
    BYTE #0
levelIntroString:
    BYTE "NEXT LEVEL"
    BYTE #0
colorshade: ; a gradient of dark-bright-dark (40 columns)
	HEX 0b 0b 0b 0b 0b 0c 0c 0c 0c 0c 05 05 05 0d 0d 0d 0d 07 07 07 07 07 07 0d 0d 0d 0d 05 05 05 0c 0c 0c 0c 0c 0b 0b 0b 0b 0b
scoreString:
	BYTE "SCORE      PART"
	BYTE #0
noMoreLevelsString:
    BYTE "NO MORE LEVELS"
    BYTE #0

; Levels
; ----------------------------------------------------------------------
levelsList:
    INCBIN "../res.bin/levels.bin"

#if VERBOSE = 1
    ECHO "initdata.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif