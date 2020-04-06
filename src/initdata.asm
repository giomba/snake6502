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

; Outro delay
outroDelay
    BYTE #$ff


; Costants
; ----------------------------------------------------------------------

; Status of the game (costants pre-processor defined, sort of enum)
ST_INTRO0       =   0
ST_INTRO1       =   1
ST_LEVELSELECT  =   2
ST_PLAY         =   3
ST_OUTRO        =   4
ST_END          =   5
ST_PAUSE        =	255

; Screen features
SCREEN_W    =   40
SCREEN_H    =   24
; Snake features
SNAKE_TILE  =   81
SNAKE_COLOR =   13
; Food features
FOOD_TILE   =   90
FOOD_COLOR  =   10
; Wall features
WALL_TILE   =   91

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
colorshade: ; a gradient of dark-bright-dark (40 columns)
	HEX 0b 0b 0b 0b 0b 0c 0c 0c 0c 0c 05 05 05 0d 0d 0d 0d 07 07 07 07 07 07 0d 0d 0d 0d 05 05 05 0c 0c 0c 0c 0c 0b 0b 0b 0b 0b
scoreString:
	BYTE "POINTS"
	BYTE #0

; Levels
; ----------------------------------------------------------------------
levelsList:
    INCBIN "../res.bin/levels.bin"

