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

	; Alter character definitions in RAM (using previous defined table)
	; TODO: merge these edits with actual font binary
	ldx #$8
.editLoop:
	dex
	lda .multicolorSnakeTile,x
	sta tggsFont + SNAKE_TILE * 8,x
	lda .multicolorFoodTile,x
	sta tggsFont + FOOD_TILE * 8,x
;	lda .multicolorOtherTile,x
;	sta tggsFont + SOME_TILE * 8,x
;	...
	cpx #$0
	bne .editLoop

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
	lda #9
	sta $d021	; 00 is brown
	lda #2
	sta $d022	; 01 is red
	lda #13
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

; Costants
; ----------------------------------------------------------------------
.multicolorCommodoreTile:
	BYTE #$00,#$30,#$cc,#$ca,#$c0,#$c5,#$cc,#$30
.multicolorSnakeTile:
	BYTE #$00,#$28,#$ab,#$ab,#$ab,#$ab,#$28,#$00
.multicolorFoodTile:
	BYTE #%00010101
	BYTE #%10010101
	BYTE #%10010101
	BYTE #%10010101
	BYTE #%10101000
	BYTE #%00100000
	BYTE #%00100000
	BYTE #%10000000

