; Subroutines
; ----------------------------------------------------------------------
; Do some math to calculate tile address in video memory
; using x,y coordinates
; Formula:  addr = $400 + y * SCREEN_W + x
calcTileMem:
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
printByte:
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

; Print null-terminated string on status bar
; address of string is given in input using memory location printStatusString
printStatus:
    ldy #0
printStatusLoop:
    lda (printStatusString),y
    beq printStatusEnd
    cmp #$20
    bne printStatusSkipSpace
    lda #$40 ; space + $40
printStatusSkipSpace:
    sec
    sbc #$40    ; convert from standard ASCII to Commodore screen code
    sta $413,y
    iny
    jmp printStatusLoop
printStatusEnd:
    rts

; Print string for intro
; Input parameters:
;   printIntroString    pointer to string to be printed (source)
;   introScreenStart    pointer to text video memory on screen where to print (dest)
printIntro:
    ldy #0
printIntroLoop:
    lda (printIntroString),y    ; get char from string
    beq printIntroEnd           ; if zero, then end (string must be null-terminated)
    cmp #$20                    ; is space?
    bne printIntroCheckPunct
    lda #$0
    jmp printIntroEndCheck
printIntroCheckPunct:
    cmp #$40                    ; is char greater or equal to #$40 = #64 = `@' ?
    bcc printIntroEndCheck      ; if not, it is less, thus it must be
                                ; a full stop, comma, colon or something
                                ; that actually has the same value in both
                                ; true ASCII and in PET screen codes
                                ; otherwise, it is greater than `@`, so must
                                ; subtract 64 because CBM and its encodings
                                ; are simply a big shit
                                ; TODO -- actually must be fixed with new charset
    sec
    sbc #$40

printIntroEndCheck:
    sta (introScreenStart),y    ; put screen code to screen
    iny                         ; next char in string
    jmp printIntroLoop
printIntroEnd:
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

