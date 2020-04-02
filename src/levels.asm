; load new level on the screen
statusLevelSelect:
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
; +---+---+---+---+---+---+--..--+---+---+---+
; | T | C | N | T | C | N |  ..  | 0 | 0 | 0 |
; +---+---+---+---+---+---+--..--+---+---+---+
; T tile char
; C tile color
; N count (how many repeated tile chars)
; 0 end of level

writeLevelLoop:
    ; read `T`
    ldy #0
    lda (levelPointer),y
    sta levelT

    ; read `C`
    iny
    lda (levelPointer),y
    sta levelC

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
    lda levelC
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

