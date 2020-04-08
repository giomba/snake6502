; Game is over
; ----------------------------------------------------------------------
gameover:
    lda #<gameoverString
    sta printIntroString
    lda #>gameoverString
    sta printIntroString + 1

    lda #$00
    sta introScreenStart
    lda #$04
    sta introScreenStart + 1
    jsr printIntro

    ; Set gameover and outro status
    lda #$ff
    sta delay
    lda #ST_END
    sta delayStatus
    lda #ST_DELAY
    sta status
    rts


