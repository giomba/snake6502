; Full game reset
; ----------------------------------------------------------------------
gamereset:
    ; Turn MultiColor mode on
    jsr multicolorOn

    ; Set overscan
    lda #11
    sta $d020
    ; Upper bar -- fill with reversed spaces, color yellow
    ldx #39
upperbarLoop:
    lda #$a0    ; reversed color space
    sta $400,x
    lda #7
    sta $d800,x
    dex
    cpx #$ff
    bne upperbarLoop

    ; Set upper bar text
    lda #<scoreString
    sta printStatusString
    lda #>scoreString
    sta printStatusString + 1
    jsr printStatus

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

    ; Set current level pointer to list start
    lda #<levelsList
    sta levelPointer
    lda #>levelsList
    sta levelPointer + 1

    rts

