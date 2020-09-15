#if VERBOSE = 1
LASTINIT SET .
#endif

; Subroutines
; ----------------------------------------------------------------------

; Clear screen -- easy
clearScreen SUBROUTINE
    ldx #$ff
.loop:
    lda #$00
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    lda #$05
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    dex
    cpx #$ff
    bne .loop

; Do some math to calculate tile address in video memory
; using x,y coordinates
; Formula:  addr = $400 + y * SCREEN_W + x
calcTileMem SUBROUTINE
    ; Save registers
    pha
    txa
    pha
    tya
    pha

    ; Set tileMem to $400
    lda #$00
    sta tileMem
    lda #$04
    sta tileMem + 1

    ldy calcTileY       ; Get head Y coordinate
calcTileMult:
    tya
    beq calcTileEnd     ; if Y is equal to zero, nothing to do, just skip moltiplication, else...
    dey                 ; decrement Y
    clc
    lda #SCREEN_W       ; A = screen width = 40
    adc tileMem         ; A = screen width + tileMem (low)
    sta tileMem         ; update tileMem (low)
    lda #0              ; do the same with higher byte: A = 0
    adc tileMem + 1     ; add (eventual) carry
    sta tileMem + 1     ; update tileMem (high)
    jmp calcTileMult    ; do again until Y == 0
calcTileEnd:            ; now multiplication is ended, so add X
    lda calcTileX
    adc tileMem
    sta tileMem
    lda #0
    adc tileMem + 1
    sta tileMem + 1

    ; Restore old registers
    pla
    tay
    pla
    tax
    pla

    rts

; Print a byte in hexadecimal
; A input register for byte to print
; Y input register for printing colum (on first line)
printByte SUBROUTINE
    ; Copy parameter also in X
    tax

    lsr ; Take most significant nibble
    lsr
    lsr
    lsr
    ora #$40        ; add 64 (see font)
    sta $400,y      ; print msb char

    txa             ; Take least significant nibble (use previous copy)
    and #$0f
    ora #$40        ; add 64 (see font)
    sta $401,y      ; print lsb char

    rts

printString SUBROUTINE
; Print string
; Input parameters:
;   srcStringPointer    pointer to string to be printed (source)
;   dstScreenPointer    pointer to text video memory on screen where to print (dest)
; Output results:
;   Y                   leaves string length in reg Y
    ldy #0
.loop:
    lda (srcStringPointer),y    ; get char from string
    beq .end                    ; if zero, then end (string must be null-terminated)
    cmp #$20                    ; is space?
    bne .checkP1
    lda #$0
    jmp .print
.checkP1:
    cmp #$28                    ; is char '(' ?
    bne .checkP2
    lda #$1b
    jmp .print
.checkP2:
    cmp #$29                    ; is char ')' ?
    bne .checkP3
    lda #$1c
    jmp .print
.checkP3
    cmp #$2e                    ; is char '.' ?
    bne .checkNumber
    lda #$1d
    jmp .print
.checkNumber:                   ; is char a number?
    cmp #$2f
    bcc .nextCheck
    cmp #$3a
    bcs .nextCheck
    sec
    sbc #$30
    clc
    adc #$40
    jmp .print
.nextCheck:

.isLetter:
    ; defaults to an uppercase letter of ASCII set
    sec
    sbc #$40
.print:
    sta (dstScreenPointer),y    ; put screen code to screen
    iny                         ; next char in string
    jmp .loop
.end:
    rts

; Increment a pointer in the zeropage
; Input parameters:
;   nextPointerPointer  pointer to the pointer in zeropage
;   regX                value to increment
nextPointer:
    lda #0
    sta nextPointerPointer + 1

    txa

    clc
    ldy #0
    adc (nextPointerPointer),y
    sta (nextPointerPointer),y
    ldy #1
    lda (nextPointerPointer),y
    adc #0
    sta (nextPointerPointer),y

    rts

#if VERBOSE = 1
    ECHO "subroutines.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif