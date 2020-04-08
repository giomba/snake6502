; load new level on the screen
statusLevelTitle SUBROUTINE
    jsr clearScreen

    ; Print "Next Level"
    lda #<levelIntroString
    sta srcStringPointer
    lda #>levelIntroString
    sta srcStringPointer + 1

    lda #$00
    sta dstScreenPointer
    lda #$04
    sta dstScreenPointer + 1
    jsr printString

    ; Print level Title
    lda levelPointer
    sta srcStringPointer
    lda levelPointer + 1
    sta srcStringPointer + 1

    lda #$e2
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    ; advance level pointer, based on title string length
    iny
    tya
    tax
    lda #levelPointer
    sta nextPointerPointer
    jsr nextPointer

    ; wait
    lda #ST_LEVEL_LOAD
    sta delayStatus
    lda #ST_DELAY
    sta status
    rts

statusLevelLoad SUBROUTINE
    ; Upper bar -- fill with spaces, color yellow
    ldx #39
.loop:
    lda #$0
    sta $400,x
    lda #7
    sta $d800,x
    dex
    cpx #$ff
    bne .loop

    ; Set upper bar score/part text
    lda #<scoreString
    sta srcStringPointer
    lda #>scoreString
    sta srcStringPointer + 1
    lda #$14
    sta dstScreenPointer
    lda #$04
    sta dstScreenPointer + 1
    jsr printString

    ; Set score
    ldy #26
    lda score + 1
    jsr printByte
    ldy #28
    lda score
    jsr printByte

    ; initialize video pointer with first video memory address
    ; (skip first line, used for the status bar)
    ldy #39
    sty levelVideoPointer
    ldy #$04
    sty levelVideoPointer + 1

    ldy #39
    sty levelColorPointer
    ldy #$d8
    sty levelColorPointer + 1

; Level data is compressed with RLE. Array example:
; +---+---+---+---+--..--+---+---+
; | T | N | T | N |  ..  | 0 | 0 |
; +---+---+---+---+--..--+---+---+
; T tile char
; N count (how many repeated tile chars)
; 0 end of level

writeLevelLoop:
    ; read `T`
    ldy #0
    lda (levelPointer),y
    sta levelT

    ; read `N`
    iny
    lda (levelPointer),y
    sta levelN

    ; increment array pointer
    iny
    tya
    tax
    lda #levelPointer
    sta nextPointerPointer
    jsr nextPointer

    ; check for array end
    lda levelN
    cmp #0
    beq writeLevelEnd

    ; retrieve `N` and put in Y
    ldy levelN

    ; unpack char from RLE to the screen
writeLevelElement:
    lda levelT
    sta (levelVideoPointer),y
        ; tiles colors can be found in an array
        ; position in array = tile value - $60
    sec
    sbc #$60
    tax
    lda tilesColors,x
    sta (levelColorPointer),y
    dey
    bne writeLevelElement

    ; increment dest video memory pointer
    lda #levelVideoPointer
    sta nextPointerPointer
    ldx levelN
    jsr nextPointer

    lda #levelColorPointer
    sta nextPointerPointer
    ldx levelN
    jsr nextPointer

    jmp writeLevelLoop

writeLevelEnd:
    lda #ST_PLAY
    sta status
    rts

