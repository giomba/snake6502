#if VERBOSE = 1
LASTINIT SET .
#endif

; Currently statusIntro0 is the same as statusIntro1
; statusIntro1 has just been reserved for future use
statusIntro0:
statusIntro1:
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