    processor 6502

; Platform specific code
; Code yet to be developed, example to use:
; ----------------------------------------------------------------------
#if SYSTEM = 64
	; Commodore64 specific code
#else
	; Commodore16 specific code
#endif

; Zero page utilities
; ----------------------------------------------------------------------

; Where is the snake head in video memory? Do math to calculate address
; using pointer at $a0-$a1
tileMem = $a0

; Pointer to status string ($a3-$a4)
printStatusString = $a3

; Pointer to intro string ($a3-$a4)
printIntroString = $a3
; Pointer to screen position where to print intro string ($fb-$fc)
introScreenStart = $fb

    org $801
. = $801    ; 10 SYS9216 ($2400) BASIC autostart
    BYTE #$0b,#$08,#$0a,#$00,#$9e,#$39,#$32,#$31,#$36,#$00,#$00,#$00

; SID tune (previously properly cleaned, see HVSC)
; ----------------------------------------------------------------------
. = $1000
sidtune:
    INCBIN "snake.sid"

; Data section
; ----------------------------------------------------------------------
. = $2100

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

; Costants
; ----------------------------------------------------------------------

; Status of the game (costants pre-processor defined, sort of enum)
ST_INTRO0   =   0
ST_INTRO1   =   1
ST_PLAY     =   2
ST_OUTRO    =   3
ST_END      =   4

; Screen features
SCREEN_W    =   40
SCREEN_H    =   24
; Snake features
SNAKE_TILE  =   81
SNAKE_COLOR =   5
; Food features
FOOD_TILE   =   90
FOOD_COLOR  =   15

; Strings
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
    BYTE "(C) 2018"
    BYTE #0
colorshade: ; a shade from dark-gray to bright yellow, and vice-versa (40 columns)
    BYTE    #11,#11,#11,#11,#11,#12,#12,#12,#12,#12,#5,#5,#5
    BYTE    #13,#13,#13,#13,#7,#7,#7,#7,#7,#7
    BYTE    #13,#13,#13,#13,#5,#5,#5,#12,#12,#12,#12,#12,#11,#11,#11,#11,#11
scoreString:
	BYTE "POINTS"
	BYTE #0

; List
; ----------------------------------------------------------------------
. = $2200
listX:

. = $2300
listY:

; ENTRY OF PROGRAM
; ----------------------------------------------------------------------
. = $2400
start:
    ; Clear screen, initialize keyboard, restore interrupts
    jsr $ff81

    ; Disable all interrupts
    sei

    ; Turn off CIA interrupts and (eventually) flush the pending queue
    ldy #$7f
    sty $dc0d
    sty $dd0d
    lda $dc0d
    lda $dd0d

    ; Set Interrupt Request Mask as we want IRQ by raster beam
    lda #$1
    sta $d01a

    ; Store in $314 address of our custom interrupt handler
    ldx #<irq	; least significant byte
    ldy #>irq	; most significant byte
    stx $314
    sty $315

    ; Set raster beam to trigger interrupt at row zero
    lda #$00
    sta $d012

    ; Bit#0 of $d011 is used as bit#9 of $d012, and must be zero
    lda $d011
    and #$7f
    sta $d011

    ; Initialize player for first song
    lda #0
    jsr sidtune

    ; Set status as first-time intro playing
    lda #ST_INTRO0
    sta status

    ; Enable interrupts
    cli

    ; Reset screen (and other parameters) to play intro
    jsr introreset

intro0running:              ; Cycle here until SPACE or `Q` is pressed
    jsr $ffe4               ; GETIN
    cmp #$20                ; Is it SPACE?
    beq intro0end           ; if yes, go to intro0end and start game (see)
    cmp #$51                ; Is it Q?
    bne intro0running       ; If not, keep looping here,
    jmp $fce2               ; else, reset the computer

    ; Intro is finished, now it's time to start the proper game
intro0end:
    ; Set init variables of the game
    jsr fullreset
    ; Set status as game playing
    lda #ST_PLAY
    sta status

endless:
    ; Loop waiting for gameover
    lda status
    cmp #ST_END     ; is status equal to end ?
    bne endless     ; if not, just wait looping here, else...

    jsr introreset  ; reset variables for intro
    lda #ST_INTRO0
    sta status      ; put machine into play intro status
    jmp intro0running   ; and go there waiting for keypress

; Full game reset
; ----------------------------------------------------------------------
fullreset:
    ; Clear screen
    ldx #$ff
    lda #$20
fullresetCLS:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    dex
    cpx #$ff
    bne fullresetCLS

    ; Set screen colors
    lda #12
    sta $d020   ; overscan
    lda #9
    sta $d021   ; center
    ; Upper bar -- fill with reversed spaces, color yellow
    ldx #39
upperbarLoop:
    lda #$a0    ; reversed color space
    sta $400,x
    lda #7
    sta $d800,x
    dex
    cpx #$ff
    bne upperbarLoop

	; Set upper bar text
	lda #<scoreString
	sta printStatusString
	lda #>scoreString
	sta printStatusString + 1
	jsr printStatus

    ; Init game variables
    lda #FOOD_TILE
    sta $500        ; Put first piece of food
    lda #4
    sta irqn        ; Initialize interrupt divider
    lda #6
    sta direction   ; Snake must go right
    lda #19
    sta snakeX      ; Snake is at screen center width...
    lda #12
    sta snakeY      ; ... and height
    lda #5
    sta listStart   ; Beginning of snake tiles list
    lda #5
    sta length      ; Length of the list

    rts

; Intro reset
; ----------------------------------------------------------------------
introreset:
    ; Clear screen
    ldx #$ff
    lda #$20
introresetCLS:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    dex
    cpx #$ff
    bne introresetCLS

    ; Copy shade colors from costant table to color RAM for 2nd and 4th
    ; line of text. Soon there will be some text bouncing on these
    ; lines
    ldx #39
introresetColorShade
    lda colorshade,x
    sta $d828,x     ; 2nd line
    sta $d878,x     ; 4th line
    dex
    cpx #$ff
    bne introresetColorShade

    ; Set screen colors
    lda #0
    sta $d020   ; overscan
    lda #0
    sta $d021   ; center

    ; Print website
    lda #<intro2string          ; lsb of string address
    sta printIntroString        ; put into lsb of source pointer
    lda #>intro2string          ; do the same for msb of string address
    sta printIntroString + 1    ; put into msb of source pointer
    lda #$26                    ; this is lsb of address of 20th line
    sta introScreenStart        ; put into lsb of dest pointer
    lda #$07                    ; do the same for msb of adress of 20th line
    sta introScreenStart + 1    ; put into msb of dest pointer
    jsr printIntro              ; print

    ; Print Copyright
    lda #<intro3string          ; the assembly is the same as above,
    sta printIntroString        ; just change string to be printed
    lda #>intro3string          ; and line (21th line)
    sta printIntroString + 1
    lda #$58
    sta introScreenStart
    lda #$07
    sta introScreenStart + 1
    jsr printIntro

    rts

; Interrupt Handler
; ----------------------------------------------------------------------
irq:
    ; Things that must be done every interrupt (50Hz)
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Acknoweledge IRQ
    dec $d019

    ; Save registers in stack
    pha
    txa
    pha
    tya
    pha

    ; Check status and call appropriate sub-routine
    ; Sort of switch-case
    lda status
    cmp #ST_INTRO0
    bne checkStatus1
    jsr statusIntro0
    jmp checkEndStatus
checkStatus1:
    cmp #ST_INTRO1
    bne checkStatus2
    jsr statusIntro1
    jmp checkEndStatus
checkStatus2
    cmp #ST_PLAY
    bne checkStatus3
    jsr statusPlay
    jmp checkEndStatus
checkStatus3
    cmp #ST_OUTRO
    bne checkEndStatus
    jsr statusOutro
    jmp checkEndStatus
checkEndStatus:

    ; Play music
    jsr sidtune + 3

    ; Increase random value
    ldx random
    inx
    stx random

    ; Restore registers from stack
    pla
    tay
    pla
    tax
    pla

    ; Go to original system routine
    jmp $ea31

; Currently statusIntro0 is the same as statusIntro1
; statusIntro1 has just been reserved for future use
statusIntro0:
statusIntro1:
    ; Decrement interrupt divider for the intro
    ldx introCounter
    dex
    stx introCounter
    cpx #0
    beq status1do   ; if divider is 0, then do status1do ...
    rts             ; ... else just do nothing and return
status1do:
    ; Reset introCounter
    ldx #5
    stx introCounter

    ; I want to print strings at different columns to make them
    ; bounce across the screen, so take last introX and add introXinc,
    ; then print string at that point. If introX is too far right, then
    ; set introXinc as #$ff (equals -1) so next time introX will be
    ; decremented by 1. And then, if introX is too far left, then
    ; set introXinc as #$01 so next time will be moved to right again.
    lda introX
    clc
    adc introXinc       ; this is #$01 or #$0ff, so actually it is +1 or -1
    sta introX
    cmp #19             ; am I too far right?
    beq status1setSX    ; if yes, set SX (left)
    cmp #0              ; am I too far left?
    beq status1setDX    ; if yes, set DX (right)
    jmp status1okset    ; else do nothing (aka, next time re-use current
                        ; increment value)
status1setDX:
    lda #$01            ; set introXinc as +1
    sta introXinc
    jmp status1okset
status1setSX:
    lda #$ff            ; set introXinc as -1
    sta introXinc
    jmp status1okset

status1okset:
    ; Print "SNAKE BY GIOMBA" (see above for pointer details)
    lda #<intro0string
    sta printIntroString
    lda #>intro0string
    sta printIntroString + 1
    ; $0428 is 2nd line (previously filled with color shades by reset routine)
    lda #$28
    clc
    adc introX                  ; just add X, to make it look like it has moved
    sta introScreenStart
    lda #$04
    sta introScreenStart + 1
    jsr printIntro

    ; Print "PRESS SPACE TO PLAY"
    lda #<intro1string
    sta printIntroString
    lda #>intro1string
    sta printIntroString + 1
    ; $0478 is 4th line (previously filled with color shades by reset routine)
    ; add #19, then sub introX will make it move to other way of 2nd line
    lda #$78
    clc
    adc #19         ; add #19
    sec
    sbc introX      ; sub introX
    sta introScreenStart
    lda #$04
    sta introScreenStart + 1
    jsr printIntro

    ; Some considerations on speed:
    ; yes, maybe I should have put the string chars once in screen text memory
    ; and then move it left and right. Should re-think about this.
    ; For now, just return.
    rts

statusPlay:     ; do Game
    ; Check counter
    ldx irqn
    dex
    stx irqn
    beq irqsometime     ; if counter is 0, then do these "rare" things
    rts                 ; else do nothing and simply return
    ; as you can see, game actually runs at 12 Hz

irqsometime:
    ; Things that must be done only one in four interrupts (12 Hz)
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ; If I am here, counter reached 0, so first reset it
    ldx #4
    stx irqn

    ; Get pressed key and decide snake direction
    jsr $ffe4   ; Kernal routine GETIN
    cmp #0
    beq keybEndCheck    ; if no key pressed, just skip this switch-case
    ldx #$7f            ; else, if key pressed, reset random variable
    stx random
keybCheckA:             ; check for press of key `A`
    cmp #$41
    bne keybCheckS      ; if not pressed `A`, just skip to next key to check
    lda direction       ; else check if current direction is right
    cmp #6
    beq keybEndCheck    ; if yes, you can't turn over yourself, so just skip to next key check
    lda #4
    sta direction       ; else set direction to left and store new value
    jmp keybEndCheck    ; skip all other key tests
keybCheckS:             ; simply re-do for S, D, W and other keys...
    cmp #$53
    bne keybCheckD
    lda direction
    cmp #8
    beq keybEndCheck
    lda #2
    sta direction
    jmp keybEndCheck
keybCheckD:
    cmp #$44
    bne keybCheckW
    lda direction
    cmp #4
    beq keybEndCheck
    lda #6
    sta direction
    jmp keybEndCheck
keybCheckW:
    cmp #$57
    bne keybCheckP
    lda direction
    cmp #2
    beq keybEndCheck
    lda #8
    sta direction
    jmp keybEndCheck
keybCheckP:
    cmp #$50
    bne keybEndCheck
    lda #5
    sta direction
    jmp keybEndCheck
keybEndCheck:

	; Get joystick status and decide snake direction
	; Joystick register bits 4:0 => Fire,Right,Left,Down,Up
	; 0 = Pressed; 1 = Idle
	lda $dc00			; CIA joystick port 2 register
	ror					; rotate bit and put bit#0 in CF
	tax					; store byte value for next key check
	bcs joyCheckDown	; if CF = 1, then key was not depressed, so skip and check next...
						; ... else key was depressed!
	lda direction		; check for not overlapping direction (turn over yourself)
	cmp #2
	beq joyEndCheck
	lda #8
	sta direction
	jmp joyEndCheck
joyCheckDown:
	txa
	ror
	tax
	bcs joyCheckLeft
	lda direction
	cmp #8
	beq joyEndCheck
	lda #2
	sta direction
	jmp joyEndCheck
joyCheckLeft:
	txa
	ror
	tax
	bcs joyCheckRight
	lda direction
	cmp #6
	beq joyEndCheck
	lda #4
	sta direction
	jmp joyEndCheck
joyCheckRight:
	txa
	ror
	tax
	bcs joyCheckFire
	lda direction
	cmp #4
	beq joyEndCheck
	lda #6
	sta direction
	jmp joyEndCheck
joyCheckFire:			; `Fire` joystick key used to pause game
	txa
	ror
	tax
	bcs joyEndCheck
	lda #5
	sta direction
joyEndCheck:

    ; Get direction and move head accordingly
    lda direction
dirCheck2:          ; check if direction is down...
    cmp #2
    bne dirCheck4   ; if not down, then skip and check next direction,
    ldy snakeY      ; else, direction is down, so get snakeY
    iny             ; increment snakeY (keep in mind that screen up/down coordinates are reversed)
    sty snakeY      ; update snakeY
dirCheck4:          ; simply re-do for other directions...
    cmp #4
    bne dirCheck6
    ldx snakeX
    dex
    stx snakeX
dirCheck6:
    cmp #6
    bne dirCheck8
    ldx snakeX
    inx
    stx snakeX
dirCheck8:
    cmp #8
    bne dirCheck5
    ldy snakeY
    dey
    sty snakeY
dirCheck5:
    cmp #5
    bne dirEndCheck
    jmp skipPauseTests
dirEndCheck:

    ; Check screen boundaries overflow
    lda snakeX
    cmp #40
    bne overCheckX0     ; if snakeX is not 40, then all ok, skip to next test
    lda #0              ; else, there is an overflow, so trespass screen border
    sta snakeX
overCheckX0:            ; simply re-do for every side of the screen
    lda snakeX
    cmp #$ff
    bne overCheckY1
    lda #39
    sta snakeX
overCheckY1:
    lda snakeY
    cmp #25
    bne overCheckY0
    lda #1
    sta snakeY
overCheckY0
    lda snakeY
    cmp #0
    bne overEndCheck
    lda #24
    sta snakeY
overEndCheck:

    ; Put new head coordinates in list
    ldy listStart
    lda snakeX
    sta listX,y
    lda snakeY
    sta listY,y
    iny
    sty listStart

    ldy #0

    ; Check for food eat / wall hit / self-eat
    ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    ; --- Food eat ---
    lda snakeX          ; calc head location in memory
    sta calcTileX
    lda snakeY
    sta calcTileY
    jsr calcTileMem
    lda (tileMem),y     ; read content of head memory location
    cmp #FOOD_TILE
    beq foodEaten       ; if memory does contain food, then perform foodEaten actions,
    jmp checkSelfEat    ; else just loooong jump to test if I ate myself
foodEaten:
    ldx length          ; else, increment snake length,
    inx
    stx length
genFood:
    ldx random
    inx
    stx random

    txa
genFoodX:               ; calculate `random` modulo SCREEN_W
    sec
    sbc #SCREEN_W
    cmp #SCREEN_W
    bcs genFoodX
    sta calcTileX

    txa
genFoodY:               ; calculate `random` modulo 22 (22 = SCREEN_H - 1)
    sec
    sbc #22
    cmp #22
    bcs genFoodY
    clc                 ; add 1 because 1st line can not be used
    adc #1
    sta calcTileY

    ; Now I have X and Y coordinate for food stored in calcTileX, calcTileY
    ; and I must check it is not the location that I am going to overwrite
    ; with the head in draw snake head...
    lda calcTileX
    cmp snakeX
    bne foodOK
    lda calcTileY
    cmp snakeY
    beq genFood
foodOK:
    ; debug -- print choosen X,Y for food
    ; ldy #$18
    ; lda calcTileX
    ; jsr printByte
    ; ldy #$1b
    ; lda calcTileY
    ; jsr printByte

    ldy #0
    jsr calcTileMem     ; calc food address in memory
    lda (tileMem),y     ; check if memory is empty
    cmp #$20            ; is there a space?
    bne genFood         ; if not, must generate another number
    lda #FOOD_TILE      ; else, just put that fucking piece of food there
    sta (tileMem),y

    lda #$d4
    clc
    adc tileMem + 1
    sta tileMem + 1
    lda #FOOD_COLOR
    sta (tileMem),y

    ; print score at $10th column
    ldy #$10
    lda length
    jsr printByte

    jmp checkEndSelfEat
checkEndFood:

    ; --- Self eat ---
checkSelfEat:
    cmp #SNAKE_TILE
    bne checkEndSelfEat
    jmp gameover
checkEndSelfEat:

    ; Draw snake head
    ldy #0
    lda snakeX          ; calc char address in video memory, and put SNAKE_TILE
    sta calcTileX
    lda snakeY
    sta calcTileY
    jsr calcTileMem
    lda #SNAKE_TILE
    sta (tileMem),y

    lda #$d4            ; add #$d400 to previous address (obtain color memory
    clc                 ; correspondent), and put SNAKE_COLOR
    adc tileMem + 1
    sta tileMem + 1
    lda #SNAKE_COLOR
    sta (tileMem),y

    ; Erase snake tail
    lda listStart       ; take start of list, and subtract snake length,
    sec                 ; to obtain index of end of list
    sbc length
    tax                 ; use previous value as index in list, and calc video memory address
    lda listX,x
    sta calcTileX
    lda listY,x
    sta calcTileY
    jsr calcTileMem
    lda #$20            ; just put a space to erase snake tail tile
    sta (tileMem),y

skipPauseTests:

    rts

; Game is over
; ----------------------------------------------------------------------
gameover:
    lda #<gameoverString
    sta printStatusString
    lda #>gameoverString
    sta printStatusString + 1
    jsr printStatus

    ; Set gameover and outro status
    lda #$ff
    sta outroDelay
    lda #ST_OUTRO
    sta status
    rts

; Decrement outroDelay, just to let player see her/his end screen
; with score
statusOutro:
    ldy outroDelay  ; load outroDelay and decrement
    dey
    sty outroDelay
    cpy #0
    beq statusOutroEnd
    rts
statusOutroEnd:
    ; Set status as ST_END: this way, the loop out of this interrupt,
    ; will know that we finished, and will play the intro again
    lda #ST_END
    sta status
    rts

; Subroutines
; ----------------------------------------------------------------------
; Do some math to calculate tile address in video memory
; using x,y coordinates
; Formula:  addr = $400 + y * SCREEN_W + x
calcTileMem:
    ; Save registers
    pha
    txa
    pha
    tya
    pha

    ; Set tileMem to $400
    lda #$00
    sta tileMem
    lda #$04
    sta tileMem + 1

    ldy calcTileY       ; Get head Y coordinate
calcTileMult:
    tya
    beq calcTileEnd     ; if Y is equal to zero, nothing to do, just skip moltiplication, else...
    dey                 ; decrement Y
    clc
    lda #SCREEN_W       ; A = screen width = 40
    adc tileMem         ; A = screen width + tileMem (low)
    sta tileMem         ; update tileMem (low)
    lda #0              ; do the same with higher byte: A = 0
    adc tileMem + 1     ; add (eventual) carry
    sta tileMem + 1     ; update tileMem (high)
    jmp calcTileMult    ; do again until Y == 0
calcTileEnd:            ; now multiplication is ended, so add X
    lda calcTileX
    adc tileMem
    sta tileMem
    lda #0
    adc tileMem + 1
    sta tileMem + 1

    ; Restore old registers
    pla
    tay
    pla
    tax
    pla

    rts

; Print a byte in hexadecimal
; A input register for byte to print
; Y input register for printing colum (on first line)
printByte:
    ; Copy parameter also in X
    tax

    lsr ; Take most significant nibble
    lsr
    lsr
    lsr
    jsr printDigit
    sta $400,y      ; print msb char

    txa             ; Take least significant nibble (use previous copy)
    and #$0f
    jsr printDigit
    sta $401,y       ; print lsb char

    rts

; Transform a base-36 digit into a Commodore screen code
; Leave input digit in accumulator; returns output screen code in accumulator
printDigit:
    cmp #10
    bcs printDigitL     ; if it is not a decimal digit, then go to printDigitL
    clc                 ; it is a decimal digit! Just add `0` (48)
    adc #48
    ora #$80            ; reverse color
    rts
printDigitL:            ; it is not a decimal digit, then...
    sec
    sbc #10             ; take away 10
    clc
    adc #1              ; add 1, so you obtain something in [A-F]
    ora #$80            ; reverse color
    rts

; Print null-terminated string on status bar
; address of string is given in input using memory location printStatusString
printStatus:
    ldy #0
printStatusLoop:
    lda (printStatusString),y
    beq printStatusEnd
    cmp #$20
    bne printStatusSkipSpace
    lda #$60
printStatusSkipSpace:
    sec
    sbc #$40    ; convert from standard ASCII to Commodore screen code
    ora #$80    ; reverse color
    sta $413,y
    iny
    jmp printStatusLoop
printStatusEnd:
    rts

; Print string for intro
; Input parameters:
;   printIntroString    pointer to string to be printed (source)
;   introScreenStart    pointer to text video memory on screen where to print (dest)
printIntro:
    ldy #0
printIntroLoop:
    lda (printIntroString),y    ; get char from string
    beq printIntroEnd           ; if zero, then end (string must be null-terminated)
    cmp #$40                    ; is char greater or equal to #$40 = #64 = `@' ?
    bcc printIntroEndCheck      ; if not, it is less, thus it must be
                                ; a full stop, comma, colon or something
                                ; that actually has the same value in both
                                ; true ASCII and in PET screen codes
                                ; otherwise, it is greater than `@`, so must
                                ; subtract 64 because CBM and its encodings
                                ; are simply a big shit
    sec
    sbc #$40

printIntroEndCheck:
    sta (introScreenStart),y    ; put screen code to screen
    iny                         ; next char in string
    jmp printIntroLoop
printIntroEnd:
    rts

;
; coded during december 2017
; by giomba -- giomba at glgprograms.it
; this software is free software and is distributed
; under the terms of GNU GPL v3 license
;
