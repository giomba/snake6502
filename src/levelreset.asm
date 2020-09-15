#if VERBOSE = 1
LASTINIT SET .
#endif

; Reset variables for a new level
; ----------------------------------------------------------------------
levelresetvar:
    ; Turn MultiColor mode on
    jsr multicolorOn

    ; Init game variables
    lda #4
    sta irqn        ; Initialize interrupt divider
    lda #6
    sta direction   ; Snake must go right
    ; Note: these values depends on following list initialization
    lda #19
    sta snakeX      ; Snake is at screen center width...
    lda #12
    sta snakeY      ; ... and height
    lda #5
    sta listStart   ; Beginning of snake tiles list
    lda #5
    sta length      ; Length of the list

    ; Clear snake lists X and Y
    ldx #$00
clearListLoop:
    dex
    lda #19
    sta listX,x
    lda #12
    sta listY,x
    cpx #$00
    bne clearListLoop

    rts

#if VERBOSE = 1
    ECHO "levelreset.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif