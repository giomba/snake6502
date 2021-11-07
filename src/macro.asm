    SEG zeropageSegment
; Generic src/dst copy pointers
srcPointer WORD
dstPointer WORD
dstPointerEnd WORD

    SEG programSegment
    MACRO MEMSET
    IF {1} != "D"
        clc
        lda <{1}
        sta dstPointer
        adc <{3}
        sta dstPointerEnd
        lda >{1}
        sta dstPointer + 1
        adc >{3}
        sta dstPointerEnd + 1
    ELSE
        clc
        lda dstPointer
        adc <{3}
        sta dstPointerEnd
        lda dstPointer + 1
        adc >{3}
        sta dstPointerEnd + 1
    ENDIF
        lda {2}
        ldy #0
.loop:
        sta (dstPointer),y
        inc dstPointer
        bne .skipInc
        inc dstPointer + 1
.skipInc:
        ldx dstPointer
        cpx dstPointerEnd
        bne .loop
        ldx dstPointer + 1
        cpx dstPointerEnd + 1
        bne .loop
    ENDM

    SEG zeroPageSegment

    SEG programSegment
    MACRO MEMCPY
    IF {1} != "D"
        clc
        lda <{1}
        sta dstPointer
        adc <{3}
        sta dstPointerEnd
        lda >{1}
        sta dstPointer + 1
        adc >{3}
        sta dstPointerEnd + 1
    ELSE
        clc
        lda dstPointer
        adc <{3}
        sta dstPointerEnd
        lda dstPointer + 1
        adc >{3}
        sta dstPointerEnd + 1
    ENDIF

    lda <{2}
    sta srcPointer
    lda >{2}
    sta srcPointer + 1

    ldy #$0
.loop:
    lda (srcPointer),y
    sta (dstPointer),y

    inc dstPointer
    bne .skipIncDst
    inc dstPointer + 1
.skipIncDst:
    inc srcPointer
    bne .skipIncSrc
    inc srcPointer + 1
.skipIncSrc:

    ldx dstPointer
    cpx dstPointerEnd
    bne .loop
    ldx dstPointer + 1
    cpx dstPointerEnd + 1
    bne .loop
    ENDM

    SEG programSegment
    MACRO MOV_WORD_MEM
    lda {2}
    sta {1}
    lda {2} + 1
    sta {1} + 1
    ENDM
