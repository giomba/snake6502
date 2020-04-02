statusLevelSelect:  ; select new level

    ldy #39
    sty tempPointer
    ldy #$04
    sty tempPointer + 1

writeLevelLoop:
    ldy #0
    lda (levelPointer),y

    pha

    lda #levelPointer
    sta nextPointerPointer
    ldx #1
    jsr nextPointer

    ldy #0
    lda (levelPointer),y

    pha

    lda #levelPointer
    sta nextPointerPointer
    ldx #1
    jsr nextPointer

    pla

    tay
    tax
    pla

    cmp #0
    beq writeLevelEnd
writeLevelElement:
    sta (tempPointer),y
    dey
    bne writeLevelElement

    lda #tempPointer
    sta nextPointerPointer
    ; x still holds the total number
    jsr nextPointer
    jmp writeLevelLoop

writeLevelEnd:
    lda #ST_PLAY
    sta status
    rts


; Input:
; regX = count
nextPointer:
    lda #0
    sta nextPointerPointer + 1

    txa

    clc
    ldy #0
    adc (nextPointerPointer),y
    sta (nextPointerPointer),y
    ldy #1
    lda (nextPointerPointer),y
    adc #0
    sta (nextPointerPointer),y

    rts

