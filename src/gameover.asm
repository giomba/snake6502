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
    sta delay
    lda #ST_END
    sta delayStatus
    lda #ST_DELAY
    sta status
    rts


