    SEG zeropageSegment
introDestPtr WORD

    SEG programSegment
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
    stx introDestPtr
    ldy #$04
    sty introDestPtr + 1

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
    ; arrives raster interrupt, move moustache one line below
    inc moustacheLine

    lda $d011       ; load current vertical offset from VIC-II
    and #$07
    cmp #$07
    beq .nextline   ; if 7, then it is next text line
    inc $d011       ; else setup moustache interrupt to trigger next raster line...
    jsr setupMoustacheInterrupt
    rts             ; ...and return: my job here is done

.nextline:
    lda $d011       ; reset raster offset to 0...
    and #$f8
    sta $d011

    MOV_WORD_MEM dstPointer, introDestPtr
    MEMSET "D", #$80, #40

    clc             ; ... move introDestPtr to next text line ...
    lda introDestPtr
    adc #40
    sta introDestPtr
    lda introDestPtr + 1
    adc #0
    sta introDestPtr + 1

    MOV_WORD_MEM dstPointer, introDestPtr
    MEMCPY "D", #GLGProgramsText, #200    ; ... and copy "GLG Programs" text to next text line

    dec introYscroll    ; remember that we are one line below
    beq .next           ; if we reached the end of the vertical scroll, advance status

    jsr setupMoustacheInterrupt ; else just continue with the moustache
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
    ; "higher" moustache interrupt (on the right of the screen)
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
    adc #23     ; "lower" moustache is 23 raster lines below higher one
    sta $d012

    jmp $ea31

.moustacheInterruptL:
    ; "lower" moustache interrupt (on the left of the screen)
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

    ldx #<irq   ; restore main raster interrupt handler
    ldy #>irq
    stx $314
    sty $315
    lda #$00
    sta $d012

    jmp $ea31

GLGProgramsText:    ; fancy PETSCII-looking brand name
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f0,#$f4,#$80,#$80,#$80,#$f0,#$f4,#$80,#$80,#$f0,#$f4,#$f1,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f5,#$80,#$80,#$f5,#$80,#$f5,#$80,#$80,#$80,#$f5,#$80,#$f5,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f1,#$80,#$80,#$80,#$f0,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f5,#$80,#$f5,#$f5,#$80,#$f5,#$80,#$f5,#$80,#$fd,#$f4,#$f3,#$f0,#$f0,#$f1,#$f0,#$f1,#$f0,#$f0,#$fc,#$f0,#$fb,#$f1,#$f2,#$f1,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f2,#$f4,#$fc,#$f2,#$f4,#$f2,#$f4,#$fc,#$80,#$f5,#$80,#$80,#$f5,#$f2,#$f3,#$f2,#$fc,#$f5,#$f2,#$f3,#$f5,#$f5,#$f5,#$f4,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80
    BYTE #$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$f4,#$fa,#$f4,#$f4,#$f4,#$f4,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$f3,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80,#$80

statusIntro1 SUBROUTINE
    ; continue moving moustaches down, up to 4 raster lines (middle of text)
    lda $d011
    and #$07
    cmp #$04
    beq .next   ; if interrupt is in the middle, don't move it anymore, and...
    inc $d011
    inc moustacheLine

    jsr setupMoustacheInterrupt

    rts

.next:
    jsr setupMoustacheInterrupt ; ... always remember to display moustache, anyhow ...

    lda counter         ; wait for song synchronization up to interrupt $0080
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

    MEMSET #$540, #$80, #200

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
    lda #$05
    ldy #$0
.lastlineColorLoop:
    sta $db98,y
    iny
    cpy #80
    bne .lastlineColorLoop

    ; Print Game Title: big "SNAKE"
    MEMSET #$d800, #$02, #280       ; color
    MEMCPY #$400, #SnakeText, #280  ; text

    ; Print website
    lda #<intro2string          ; lsb of string address
    sta srcStringPointer        ; put into lsb of source pointer
    lda #>intro2string          ; do the same for msb of string address
    sta srcStringPointer + 1    ; put into msb of source pointer
    lda #$9e                    ; this is lsb of address of 23th line
    sta dstScreenPointer        ; put into lsb of dest pointer
    lda #$07                    ; do the same for msb of adress of 20th line
    sta dstScreenPointer + 1    ; put into msb of dest pointer
    jsr printString             ; print

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

    ; boat-shaped horizontal line (rounded edges toward the top)
    ; this overwrites the "present" word from the intro
    lda #$f2        ; 3rd quadrant
    sta $540
    lda #$f3        ; 4th quadrant
    sta $567
    lda #$07        ; color for edges
    sta $540+$d800-$400
    sta $567+$d800-$400
    ldy #$1
.boatLineLoop:
    lda #$f4        ; horizontal line
    sta $540,y
    lda #$07
    sta $540+$d800-$400,y
    iny
    cpy #39
    bne .boatLineLoop

    lda #$05
    sta XCharOffset

    jsr setupMoustacheInterrupt     ; never forget the magic moustaches

    lda #ST_MENU
    sta status
    rts

SnakeText:
    HEX 80 80 80 80 80 80 80 80 f6 a0 a0 f9 80 f7 80 80 f6 80 f6 a0 a0 f7 80 f7 80 80 80 f6 a0 a0 f9 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 a0 80 80 80 80 a0 f7 80 a0 80 a0 80 80 a0 80 a0 f6 f7 80 a0 80 80 80 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 a0 80 80 80 80 a0 a0 f7 a0 80 a0 80 80 a0 80 a0 a0 f9 80 a0 80 80 80 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 f8 a0 a0 f7 80 a0 f8 a0 a0 80 a0 a0 a0 a0 80 a0 f9 80 80 a0 a0 80 80 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 80 80 80 a0 80 a0 80 f8 a0 80 a0 80 80 a0 80 a0 f7 80 80 a0 80 80 80 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 80 80 80 a0 80 a0 80 80 a0 80 a0 80 80 a0 80 a0 a0 f7 80 a0 80 80 80 80 80 80 80 80 80 80 80 80
    HEX 80 80 80 80 80 80 80 80 f6 a0 a0 f9 80 f8 80 80 f8 80 f9 80 80 f8 80 a0 f8 f9 80 f8 a0 a0 f7 80 80 80 80 80 80 80 80 80

;ParabolicSpaceChars:
;    HEX 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 01 00 00 00 00 00 01 00 00 00 00 00 01 00 00 00 00 01 00 00 00 00 01 00 00 00 00 00 01 00 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
;ParabolicSpaceScroll:
;    HEX 00 01 01 01 01 01 01 01 02 02 02 03 03 04 04 05 06 06 07 00 00 01 02 03 04 05 06 07 00 01 02 04 05 06 00 01 02 04 05 07 00 02 04 05 07 00 01 03 04 06 00 01 03 04 06 07 00 02 03 04 06 07 00 01 02 03 04 05 06 07 00 01 02 02 03 04 04 05 05 06 06 06 07 06 07 07 07 07 07 07 07

setupXScrollInterrupt SUBROUTINE
    ldx #<XScrollInterruptH
    ldy #>XScrollInterruptH
    stx $314
    sty $315

    ; Set raster beam to trigger interrupt at row
    lda #42
    sta $d012

    rts

XScrollInterruptH SUBROUTINE

    lda $d016
    and #$f8
    ora XScrollOffset
    sta $d016

    dec $d019

    ldx #<XScrollInterruptL
    ldy #>XScrollInterruptL
    stx $314
    sty $315
    lda #110
    sta $d012

    jmp $ea31

XScrollInterruptL SUBROUTINE
    lda $d016
    and #$f8
    sta $d016

    dec $d019

    ldx #<XScrollInterruptMoveAll
    ldy #>XScrollInterruptMoveAll
    stx $314
    sty $315
    lda #120
    sta $d012

    jmp $ea31

XScrollInterruptMoveAll SUBROUTINE
    dec $d019   ; EOI

    tsx
    dex

    lda XCharOffset
    asl
    asl
    asl
    sta $100,x
    lda $d016
    and #$07
    ora $100,x

    inx
    txs

    cmp #78
    bcs .isEdge
    cmp #3
    bcc .isEdge
    cmp #70
    bcs .isMiddle
    cmp #10
    bcc .isMiddle
    jmp .enter

.isMiddle:
    lda counter
    and #$01
    beq .enter
    jmp .next

.isEdge:
    lda counter
    and #$03
    beq .enter  ; ah, some good spaghetti code to accomodate for far branch
    jmp .next   ; bounce slower

.isCenter:
.enter:
    lda XScrollDirection
    and #$01
    bne .goRight
.goLeft:
    dec XScrollOffset
    lda XScrollOffset
    and #$07
    cmp #$07
    beq .continue1
    jmp .next
.continue1:
    lda #$07
    sta XScrollOffset
.moveEverythingLeft:
    dec XCharOffset
    ldy #0
.loop1:
    lda $401,y
    sta $400,y
    lda $429,y
    sta $428,y
    lda $451,y
    sta $450,y
    lda $479,y
    sta $478,y
    lda $4a1,y
    sta $4a0,y
    lda $4c9,y
    sta $4c8,y
    lda $4f1,y
    sta $4f0,y
    iny
    cpy #38
    bne .loop1

    lda XCharOffset
    cmp #0
    bne .next
    lda #$01
    sta XScrollDirection
    jmp .next

.goRight:
    inc XScrollOffset
    lda XScrollOffset
    and #$07
    cmp #$00
    bne .next
    lda #$00
    sta XScrollOffset
.moveEverythingRight:
    inc XCharOffset
    ldy #38
.loop2:
    lda $400,y
    sta $401,y
    lda $428,y
    sta $429,y
    lda $450,y
    sta $451,y
    lda $478,y
    sta $479,y
    lda $4a0,y
    sta $4a1,y
    lda $4c8,y
    sta $4c9,y
    lda $4f0,y
    sta $4f1,y
    dey
    bne .loop2

    lda XCharOffset
    cmp #10
    bne .next
    lda #$00
    sta XScrollOffset
    lda #$00
    sta XScrollDirection

.next:
    jsr setupMoustacheInterrupt

    jmp $ea31

statusMenu SUBROUTINE
    jsr setupXScrollInterrupt
    rts
