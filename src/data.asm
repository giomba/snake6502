    SEG.U dataSegment
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

; Level temporary vars
levelT:
    BYTE
levelN:
    BYTE

; next status after delay
delayStatus:
    BYTE

; Total score of the game
score:
    WORD

; vertical scroll intro
introYscroll:
    BYTE

; interrupt raster line to draw moustache
moustacheLine:
    BYTE

; horizontal intro scroll
XScrollOffset:
    BYTE
XScrollDirection:
    BYTE
XCharOffset:
    BYTE

; Lists for snake head and tail
listX DS 256
listY DS 256
