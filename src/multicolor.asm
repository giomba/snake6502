		processor 6502

multicolor SUBROUTINE

; Prepare data struct for MultiColor mode
; ----------------------------------------------------------------------
multicolorInit:
	; Make font higher half the inverse of lower one
	; TODO: merge these edits with actual font binary
	ldx #$00
.tggsCopy
	dex
	lda tggsFont,x
	eor #$ff
	sta $2400,x
	lda tggsFont + $100,x
	eor #$ff
	sta $2500,x
	lda tggsFont + $200,x
	eor #$ff
	sta $2600,x
	lda tggsFont + $300,x
	eor #$ff
	sta $2700,x
	cpx #$0
	bne .tggsCopy

	; Tell VIC-II to use:
	; - screen text memory at	$400	= $400 * 1
	; - characters ROM at		$2000	= $400 * 8
	lda #$18
	sta $d018

	rts

; Activate multicolor mode
; ----------------------------------------------------------------------
multicolorOn:
	; Set colors
	lda #$0
	sta $d021	; 00 is black
	lda #$a
	sta $d022	; 01 is gray
	lda #$d
	sta $d023	; 10 is green
				; and of course
				; 11 is the colour specified in color RAM

	lda $d016
	ora #$10
	sta $d016

	rts

; Deactivate multicolor mode
; ----------------------------------------------------------------------
multicolorOff:
	lda $d016
	and #$ef
	sta $d016
	rts
