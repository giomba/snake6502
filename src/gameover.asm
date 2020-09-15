#if VERBOSE = 1
LASTINIT SET .
#endif

; Game is over
; ----------------------------------------------------------------------
gameover:
    lda #<gameoverString
    sta srcStringPointer
    lda #>gameoverString
    sta srcStringPointer + 1

    lda #$00
    sta dstScreenPointer
    lda #$04
    sta dstScreenPointer + 1
    jsr printString

    ; Set gameover and outro status
    lda #$ff
    sta delay
    lda #ST_END
    sta delayStatus
    lda #ST_DELAY
    sta status
    rts

#if VERBOSE = 1
    ECHO "gameover.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif