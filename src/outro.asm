    SEG programSegment
; Wait for some delay
statusDelay SUBROUTINE
    ldy delay           ; load outroDelay and decrement
    dey
    sty delay
    cpy #0
    beq .end
    rts
.end:
    lda delayStatus
    sta status
    rts
