; Intro reset
; ----------------------------------------------------------------------
introreset:
    jsr multicolorOff

    jsr clearScreen

    ; Copy shade colors from costant table to color RAM for 2nd and 4th line of text
    ldx #39
introresetColorShade
    lda colorshade,x
    sta $d828,x     ; 2nd line
    sta $d878,x     ; 4th line
    dex
    cpx #$ff
    bne introresetColorShade

    ; Set screen colors
    lda #0
    sta $d020   ; overscan
    sta $d021   ; center

    ; Print website
    lda #<intro2string          ; lsb of string address
    sta srcStringPointer        ; put into lsb of source pointer
    lda #>intro2string          ; do the same for msb of string address
    sta srcStringPointer + 1    ; put into msb of source pointer
    lda #$26                    ; this is lsb of address of 20th line
    sta dstScreenPointer        ; put into lsb of dest pointer
    lda #$07                    ; do the same for msb of adress of 20th line
    sta dstScreenPointer + 1    ; put into msb of dest pointer
    jsr printString              ; print

    ; Print Copyright
    lda #<intro3string          ; the assembly is the same as above,
    sta srcStringPointer        ; just change string to be printed
    lda #>intro3string          ; and line (21th line)
    sta srcStringPointer + 1
    lda #$58
    sta dstScreenPointer
    lda #$07
    sta dstScreenPointer + 1
    jsr printString

    rts


