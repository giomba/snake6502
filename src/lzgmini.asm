	SEG zeropageSegment
srcPointer WORD
dstPointer WORD
inEnd WORD
offset WORD
length BYTE
symbol BYTE
marker1 BYTE
marker2 BYTE
marker3 BYTE
marker4 BYTE
copy WORD

	SEG loaderSegment
inflate SUBROUTINE
    clc
    ldy #10
    lda (srcPointer),y
    adc srcPointer
	sta	inEnd
	dey
	lda	(srcPointer),y
	adc	srcPointer + 1
	sta	inEnd + 1
	clc
	lda	inEnd
	adc	#16
	sta	inEnd
	lda	inEnd + 1
	adc	#0
	sta	inEnd + 1

	; Get the marker symbols
	ldy	#16
	lda	(srcPointer),y
	sta	marker1
	iny
	lda	(srcPointer),y
	sta	marker2
	iny
	lda	(srcPointer),y
	sta	marker3
	iny
	lda	(srcPointer),y
	sta	marker4

	; Skip header + marker symbols (16 + 4 bytes)
	clc
	lda	srcPointer
	adc	#20
	sta	srcPointer
	lda	srcPointer + 1
	adc	#0
	sta	srcPointer + 1

	; Main decompression loop
	ldy	#0				; Make sure that Y is zero
.mainloop:
	lda	srcPointer		; done?
	cmp	inEnd
	bne	.notdone
	lda	srcPointer + 1
	cmp	inEnd + 1
	bne	.notdone
	rts
.notdone:
	lda	(srcPointer),y				; A = symbol
	sta	symbol
    sta $d020
	inc	srcPointer
	bne	.noinc1
	inc	srcPointer + 1
.noinc1:
	cmp	marker1			; Marker1?
	beq	.domarker1
	cmp	marker2			; Marker2?
	beq	.domarker2
	cmp	marker3			; Marker3?
	beq	.domarker3
	cmp	marker4			; Marker4?
	beq	.domarker4
.literal:
	lda	symbol
	sta	(dstPointer),y			; Plain copy
	inc	dstPointer
	bne	.mainloop
	inc	dstPointer + 1
	bne	.mainloop

.domarker1:
	jmp	.domarker1b

	; marker4 - "Near copy (incl. RLE)"
.domarker4:
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc3
	inc	srcPointer + 1
.noinc3:
	cmp	#0
	beq	.literal				; Single occurance of the marker symbol (rare)
	tax
	lsr
	lsr
	lsr
	lsr
	lsr
	sta	offset
	inc	offset
	lda	#0
	sta	offset + 1			; offset = (b >> 5) + 1
	txa
	and	#$1f
	tax
	lda	.LZG_LENGTH_DECODE_LUT,x
	sta	length				; length = .LZG_LENGTH_DECODE_LUT[b & 0x1f]
	jmp	.docopy

	; marker3 - "Short copy"
.domarker3:
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc4
	inc	srcPointer + 1
.noinc4:
	cmp	#0
	beq	.literal				; Single occurance of the marker symbol (rare)
	tax
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc	#3
	sta	length				; length = (b >> 6) + 3
	txa
	and	#$3f
	adc	#8
	sta	offset
	lda	#0
	sta	offset + 1			; offset = (b & 0x3f) + 8
	beq	.docopy

	; marker2 - "Medium copy"
.domarker2:
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc5
	inc	srcPointer + 1
.noinc5:
	cmp	#0
	beq	.literal				; Single occurance of the marker symbol (rare)
	tax
	lsr
	lsr
	lsr
	lsr
	lsr
	sta	offset + 1
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc6
	inc	srcPointer + 1
.noinc6:
	clc
	adc	#8
	sta	offset
	bcc	.noinc7
	inc	offset + 1			; offset = (((b & 0xe0) << 3) | b2) + 8
.noinc7:
	txa
	and	#$1f
	tax
	lda	.LZG_LENGTH_DECODE_LUT,x
	sta	length				; length = .LZG_LENGTH_DECODE_LUT[b & 0x1f]
	bne	.docopy

.literal2:
	jmp	.literal

	; marker1 - "Distant copy"
.domarker1b:
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc8
	inc	srcPointer + 1
.noinc8:
	cmp	#0
	beq	.literal2			; Single occurance of the marker symbol (rare)
	and	#$1f
	tax
	lda	.LZG_LENGTH_DECODE_LUT,x
	sta	length				; length = .LZG_LENGTH_DECODE_LUT[b & 0x1f]
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc9
	inc	srcPointer + 1
.noinc9:
	sta	offset + 1
	lda	(srcPointer),y
	inc	srcPointer
	bne	.noinc10
	inc	srcPointer + 1
.noinc10:
	clc
	adc	#$08
	sta	offset
	lda	offset + 1
	adc	#$08
	sta	offset + 1			; offset = ((b2 << 8) | (*src++)) + 2056

	; Copy corresponding data from history window
.docopy:
	sec
	lda	dstPointer
	sbc	offset
	sta	copy
	lda	dstPointer + 1
	sbc	offset + 1
	sta	copy + 1
.loop1:
    lda	(copy),y
	sta	(dstPointer),y
	iny
	cpy	length
	bne	.loop1
	ldy	#0				; Make sure that Y is zero

	clc
	lda	dstPointer
	adc	length
	sta	dstPointer
	bcc	.noinc11
	inc	dstPointer + 1
.noinc11:
	jmp	.mainloop

; Lookup Table for decoding the copy length parameter
.LZG_LENGTH_DECODE_LUT
	BYTE    2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,35,48,72,128




