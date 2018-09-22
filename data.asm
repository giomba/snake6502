; Data section
; ----------------------------------------------------------------------
; Number of interrupt
; Used as counter to be decremented to do some things less frequently
irqn:
    BYTE

; Direction of the snake (2,4,6,8 as down,left,right,up)
; 5 means `pause`
direction:
    BYTE

; Snake head coordinates in video memory
snakeX:
    BYTE
snakeY:
    BYTE

; Parameters for calcTileMem
calcTileX:
    BYTE
calcTileY:
    BYTE

; List start and length
listStart:
    BYTE
length:
    BYTE

; Random value
random:
    BYTE

; Status
status:
    BYTE

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


