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


