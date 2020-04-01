; Decrement outroDelay, just to let player see her/his end screen
; with score
statusOutro:
    ldy outroDelay  ; load outroDelay and decrement
    dey
    sty outroDelay
    cpy #0
    beq statusOutroEnd
    rts
statusOutroEnd:
    ; Set status as ST_END: this way, the loop out of this interrupt,
    ; will know that we finished, and will play the intro again
    lda #ST_END
    sta status
    rts

