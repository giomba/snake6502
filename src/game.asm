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
    lda $dc00           ; CIA joystick port 2 register
    ror                 ; rotate bit and put bit#0 in CF
    tax                 ; store byte value for next key check
    bcs joyCheckDown    ; if CF = 1, then key was not depressed, so skip and check next...
                        ; ... else key was depressed!
    lda direction       ; check for not overlapping direction (turn over yourself)
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
joyCheckFire:           ; `Fire` joystick key used to pause game
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
#if DEBUG = 1
    ; print choosen X,Y for food
    ldy #$18
    lda calcTileX
    jsr printByte
    ldy #$1b
    lda calcTileY
    jsr printByte
#endif

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

checkWallHit:
    cmp #WALL_TILE
    bne checkEndWallHit
    jmp gameover
checkEndWallHit:

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

;    lda #WALL_COLOR
;    sta $d860,y

skipPauseTests:

    rts


