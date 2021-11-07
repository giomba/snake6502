    SEG zeropageSegment
ptrDstStart WORD
ptrDstEnd WORD

    MACRO MEMSET
        SEG programSegment
        clc
        lda <{1}
        sta ptrDstStart
        adc <({3} + 1)
        sta ptrDstEnd
        lda >{1}
        sta ptrDstStart + 1
        adc >({3} + 1)
        sta ptrDstEnd + 1
        lda {2}
        ldy #0
.loop:
        sta (ptrDstStart),y
        inc ptrDstStart
        bne .skipInc
        inc ptrDstStart + 1
.skipInc:
        ldx ptrDstStart
        cpx ptrDstEnd
        bne .loop
        ldx ptrDstStart + 1
        cpx ptrDstEnd + 1
        bne .loop
    ENDM
