#if VERBOSE = 1
LASTINIT SET .
#endif

introreset SUBROUTINE
    jsr multicolorOff

    jsr clearScreen

    ; Set screen colors
    lda #0
    sta $d020   ; overscan
    sta $d021   ; center

    lda #14
    sta introYscroll

    ; for "GLGPROGRAMS" at the beginning
    ldx #$78
    stx dstPointer
    ldy #$04
    sty dstPointer + 1

    ; GLGPROGRAMS color
    ldy #$00
    lda #$02
.colorLoop:
    sta $d800,y
    sta $d900,y
    sta $da00,y
    sta $db00,y
    dey
    bne .colorLoop

    ; first raster interrupt line, for moustaches
    lda #68+19
    sta moustacheLine

    rts

statusIntro0 SUBROUTINE
    lda introYscroll

.enter:
    inc moustacheLine

    lda $d011
    and #$07
    cmp #$07
    beq .nextline
    inc $d011
    jsr setupMoustacheInterrupt
    rts
.nextline:
    lda $d011
    and #$f8
    sta $d011

    ldy #0
    lda #$80
.clearLineLoop:
    sta (dstPointer),y
    iny
    cpy #40
    bne .clearLineLoop

    clc
    lda dstPointer
    adc #40
    sta dstPointer
    lda dstPointer + 1
    adc #0
    sta dstPointer + 1

    ldy #$00
.glgLoop:
    lda GLGProgramsText,y
    sta (dstPointer),y
    iny
    cpy #200
    bne .glgLoop

    dec introYscroll
    beq .next

    jsr setupMoustacheInterrupt

    rts

.next:
    lda #ST_INTRO1
    sta status
    rts

setupMoustacheInterrupt SUBROUTINE
    ; Store in $314 address of our custom interrupt handler
    ldx #<.moustacheInterruptH
    ldy #>.moustacheInterruptH
    stx $314
    sty $315

    ; Set raster beam to trigger interrupt at row
    lda moustacheLine
    sta $d012

    rts

.moustacheInterruptH:
    ; +36
    dec $d019   ; +42, EOI
    lda #$02    ; +44, color
    sta $d020   ; +48, color
    nop         ; +50, timing
    nop         ; +52, timing
    nop         ; +54, timing
    bit $02     ; +57, timing
    lda #$00    ; +59, color
    sta $d020   ; +63, color

    ; second line, +0
    inc $0800   ; + 6, timing
    inc $0800   ; +12, timing
    inc $0800   ; +18, timing
    inc $0800   ; +24, timing
    inc $0800   ; +30, timing
    inc $0800   ; +36, timing
    inc $0800   ; +42, timing
    lda #$02    ; +44, color
    sta $d020   ; +48, color
    inc $0800   ; +54, timing
    bit $02     ; +57, timing
    lda #$00    ; +59, color
    sta $d020   ; +63, color

    ; set raster beam low
    ldx #<.moustacheInterruptL
    ldy #>.moustacheInterruptL
    stx $314
    sty $315
    clc
    lda moustacheLine
    adc #23
    sta $d012

    jmp $ea31

.moustacheInterruptL:
    ; +36
    dec $d019   ; +42, EOI
    inc $0800   ; +48, timing
    inc $0800   ; +54, timing
    lda #$02    ; +56, color
    bit $0800   ; +60, timing
    bit $02     ; +63, timing

    ; newline
    sta $d020   ; + 4, color
    lda #$00    ; + 6, timing
    inc $0800   ; +12, timing
    inc $0800   ; +18, timing
    nop         ; +20, timing
    sta $d020   ; +24, color
    lda #$02    ; +26, color
    bit $0800   ; +30, timing
    inc $0800   ; +36, timing
    inc $0800   ; +42, timing
    inc $0800   ; +48, timing
    inc $0800   ; +54, timing
    inc $0800   ; +60, timing
    bit $02     ; +63, timing

    ; newline
    sta $d020   ; + 4, color
    lda #$00    ; + 6, color
    inc $0800   ; +12, timing
    inc $0800   ; +18, timing
    sta $d020   ; +22, color

    ldx #<irq
    ldy #>irq
    stx $314
    sty $315
    lda #$00
    sta $d012

    jmp $ea31

GLGProgramsText:
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f0,#$f4,#$80,#$80,#$80,#$f0,#$f4,#$80,#$80,#$f0,#$f4,#$f1,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f5,#$80,#$80,#$f5,#$80,#$f5,#$80,#$80,#$80,#$f5,#$80,#$f5,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f1,#$80,#$80,#$80,#$f0,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f5,#$80,#$f5,#$f5,#$80,#$f5,#$80,#$f5,#$80,#$fd,#$f4,#$f3,#$f0,#$f0,#$f1,#$f0,#$f1,#$f0,#$f0,#$fc,#$f0,#$fb,#$f1,#$f2,#$f1,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f2,#$f4,#$fc,#$f2,#$f4,#$f2,#$f4,#$fc,#$80,#$f5,#$80,#$80,#$f5,#$f2,#$f3,#$f2,#$fc,#$f5,#$f2,#$f3,#$f5,#$f5,#$f5,#$f4,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$fa,#$f4,#$f4,#$f4,#$f4,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80

statusIntro1 SUBROUTINE
    lda $d011
    and #$07
    cmp #$04
    beq .next
    inc $d011
    inc moustacheLine

    jsr setupMoustacheInterrupt

    rts

.next:
    jsr setupMoustacheInterrupt

    lda counter
    cmp #$80
    bne .end
    lda counter + 1
    cmp #$00
    bne .end

    ldy #$0
    lda #$07
.colorLoop:
    sta $d940,y
    iny
    cpy #200
    bne .colorLoop

    lda #ST_INTRO2
    sta status

.end:
    rts

statusIntro2 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "RETROFFICINA"
    lda #<introStringA1
    sta srcStringPointer
    lda #>introStringA1
    sta srcStringPointer + 1
    lda #$48
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$08
    bne .end
    lda counter + 1
    cmp #$01
    bne .end
    lda #ST_INTRO3
    sta status

.end:
    rts

statusIntro3 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "AND"
    lda #<introStringA2
    sta srcStringPointer
    lda #>introStringA2
    sta srcStringPointer + 1
    lda #$a5
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$86
    bne .end
    lda counter + 1
    cmp #$01
    bne .end
    lda #ST_INTRO4
    sta status

.end:
    rts

statusIntro4 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "GIOMBA"
    lda #<introStringA3
    sta srcStringPointer
    lda #>introStringA3
    sta srcStringPointer + 1
    lda #$f9
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$08
    bne .end
    lda counter + 1
    cmp #$02
    bne .end

    lda #$80
    ldy #$0
.loop:
    sta $540,y
    iny
    cpy #200
    bne .loop

    lda #ST_INTRO5
    sta status

.end:
    rts

statusIntro5 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "PRESENT"
    lda #<introStringA4
    sta srcStringPointer
    lda #>introStringA4
    sta srcStringPointer + 1
    lda #$50
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$80
    bne .end
    lda counter + 1
    cmp #$02
    bne .end

    lda #ST_INTRO6
    sta status

.end:
    rts

statusIntro6 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "A COMMODORE 64"
    lda #<introStringA5
    sta srcStringPointer
    lda #>introStringA5
    sta srcStringPointer + 1
    lda #$9d
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$08
    bne .end
    lda counter + 1
    cmp #$03
    bne .end

    lda #ST_INTRO7
    sta status

.end:
    rts

statusIntro7 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; "VIDEOGAME"
    lda #<introStringA6
    sta srcStringPointer
    lda #>introStringA6
    sta srcStringPointer + 1
    lda #$ef
    sta dstScreenPointer
    lda #$05
    sta dstScreenPointer + 1
    jsr printString

    lda counter
    cmp #$80
    bne .end
    lda counter + 1
    cmp #$03
    bne .end

    lda #ST_INTRO8
    sta status

.end:
    rts

statusIntro8 SUBROUTINE
    jsr setupMoustacheInterrupt

    ; blank wait
    lda counter
    cmp #$16
    bne .end
    lda counter + 1
    cmp #$04
    bne .end

    lda #ST_MENURESET
    sta status

.end:
    rts

statusMenuReset SUBROUTINE
    jsr multicolorOff

    ; Copy shade colors from costant table to color RAM for 2nd and 4th line of text
    ldx #39
.colorShadeLoop:
    lda colorshade,x
    sta $d828,x     ; 2nd line
    sta $d878,x     ; 4th line
    dex
    cpx #$ff
    bne .colorShadeLoop

    lda #$05
    ldy #$0
.lastlineColorLoop:
    sta $db98,y
    iny
    cpy #80
    bne .lastlineColorLoop

    ; Print website
    lda #<intro2string          ; lsb of string address
    sta srcStringPointer        ; put into lsb of source pointer
    lda #>intro2string          ; do the same for msb of string address
    sta srcStringPointer + 1    ; put into msb of source pointer
    lda #$9e                    ; this is lsb of address of 23th line
    sta dstScreenPointer        ; put into lsb of dest pointer
    lda #$07                    ; do the same for msb of adress of 20th line
    sta dstScreenPointer + 1    ; put into msb of dest pointer
    jsr printString              ; print

    ; Print Copyright
    lda #<intro3string          ; the assembly is the same as above,
    sta srcStringPointer        ; just change string to be printed
    lda #>intro3string          ; and line (24th line)
    sta srcStringPointer + 1
    lda #$ce
    sta dstScreenPointer
    lda #$07
    sta dstScreenPointer + 1
    jsr printString

    jsr setupMoustacheInterrupt     ; never forget the magic moustaches

    lda #ST_MENU
    sta status
    rts

statusMenu SUBROUTINE
    jsr setupMoustacheInterrupt     ; never forget to draw the moustaches
    ; Decrement interrupt divider for the intro
    ldx introCounter
    dex
    stx introCounter
    cpx #0
    beq status1do   ; if divider is 0, then do status1do ...
    rts             ; ... else just do nothing and return
status1do:
    ; Reset introCounter
    ldx #5
    stx introCounter

    ; I want to print strings at different columns to make them
    ; bounce across the screen, so take last introX and add introXinc,
    ; then print string at that point. If introX is too far right, then
    ; set introXinc as #$ff (equals -1) so next time introX will be
    ; decremented by 1. And then, if introX is too far left, then
    ; set introXinc as #$01 so next time will be moved to right again.
    lda introX
    clc
    adc introXinc       ; this is #$01 or #$0ff, so actually it is +1 or -1
    sta introX
    cmp #19             ; am I too far right?
    beq status1setSX    ; if yes, set SX (left)
    cmp #0              ; am I too far left?
    beq status1setDX    ; if yes, set DX (right)
    jmp status1okset    ; else do nothing (aka, next time re-use current
                        ; increment value)
status1setDX:
    lda #$01            ; set introXinc as +1
    sta introXinc
    jmp status1okset
status1setSX:
    lda #$ff            ; set introXinc as -1
    sta introXinc
    jmp status1okset

status1okset:
    ; Print "SNAKE BY GIOMBA" (see above for pointer details)
    lda #<intro0string
    sta srcStringPointer
    lda #>intro0string
    sta srcStringPointer + 1
    ; $0428 is 2nd line (previously filled with color shades by reset routine)
    lda #$28
    clc
    adc introX                  ; just add X, to make it look like it has moved
    sta dstScreenPointer
    lda #$04
    sta dstScreenPointer + 1
    jsr printString

    ; Print "PRESS SPACE TO PLAY"
    lda #<intro1string
    sta srcStringPointer
    lda #>intro1string
    sta srcStringPointer + 1
    ; $0478 is 4th line (previously filled with color shades by reset routine)
    ; add #19, then sub introX will make it move to other way of 2nd line
    lda #$78
    clc
    adc #19         ; add #19
    sec
    sbc introX      ; sub introX
    sta dstScreenPointer
    lda #$04
    sta dstScreenPointer + 1
    jsr printString

    ; Some considerations on speed:
    ; yes, maybe I should have put the string chars once in screen text memory
    ; and then move it left and right. Should re-think about this.
    ; For now, just return.
    rts

#if VERBOSE = 1
    ECHO "intro1.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif