; load new level on the screen
statusLevelSelect:
    ; initialize video pointer with first video memory address
    ; (skip first line, used for the status bar)
    ldy #39
    sty levelVideoPointer
    ldy #$04
    sty levelVideoPointer + 1

; Level data is compressed with RLE. Array example:
; +---+---+---+---+---+-..-+---+---+
; | T | C | T | C | . |    | 0 | 0 |
; +---+---+---+---+---+-..-+---+---+
; T tile char
; C count (how many repeated tile chars)
; 0 end of level

writeLevelLoop:
    ; read `T`, and save onto stack
    ldy #0
    lda (levelPointer),y
    pha

    ; increment array pointer
    lda #levelPointer
    sta nextPointerPointer
    ldx #1
    jsr nextPointer

    ; read `C`, and save onto stack
    ldy #0
    lda (levelPointer),y
    pha

    ; increment array pointer
    lda #levelPointer
    sta nextPointerPointer
    ldx #1
    jsr nextPointer

    ; retrieve `C` from stack and put in X and Y
    pla
    tay
    tax
    ; retrieve `T` from stack
    pla

    ; check array end
    cmp #0
    beq writeLevelEnd

    ; unpack char from RLE to the screen
writeLevelElement:
    sta (levelVideoPointer),y
    dey
    bne writeLevelElement

    lda #levelVideoPointer
    sta nextPointerPointer
    ; reg X is still holding the original `C`
    jsr nextPointer
    jmp writeLevelLoop

writeLevelEnd:
    lda #ST_PLAY
    sta status
    rts

