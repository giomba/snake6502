#if VERBOSE = 1
LASTINIT SET .
#endif

; Intro reset
; ----------------------------------------------------------------------
introreset SUBROUTINE
    jsr multicolorOff

    jsr clearScreen

    ; Set screen colors
    lda #0
    sta $d020   ; overscan
    sta $d021   ; center

    lda #14
    sta introYscroll

    ldx #$78
    stx dstPointer
    ldy #$04
    sty dstPointer + 1

    lda #68+19
    sta rasterLineInt

#if DEBUG = 1
    ldy #$00
.charsetLoop:
    tya
    sta $4c8,y
    iny
    bne .charsetLoop
#endif

#if VERBOSE = 1
    ECHO "introreset.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif
