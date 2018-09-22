; Intro reset
; ----------------------------------------------------------------------
introreset:
    jsr multicolorOff

    ; Clear screen
    ldx #$ff
    lda #$20
introresetCLS:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    dex
    cpx #$ff
    bne introresetCLS

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
    sta printIntroString        ; put into lsb of source pointer
    lda #>intro2string          ; do the same for msb of string address
    sta printIntroString + 1    ; put into msb of source pointer
    lda #$26                    ; this is lsb of address of 20th line
    sta introScreenStart        ; put into lsb of dest pointer
    lda #$07                    ; do the same for msb of adress of 20th line
    sta introScreenStart + 1    ; put into msb of dest pointer
    jsr printIntro              ; print

    ; Print Copyright
    lda #<intro3string          ; the assembly is the same as above,
    sta printIntroString        ; just change string to be printed
    lda #>intro3string          ; and line (21th line)
    sta printIntroString + 1
    lda #$58
    sta introScreenStart
    lda #$07
    sta introScreenStart + 1
    jsr printIntro

    rts


