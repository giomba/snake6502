		processor 6502

multicolor SUBROUTINE

; Prepare data struct for MultiColor mode
; ----------------------------------------------------------------------
multicolorInit:
	; Deactivate interrupt
	; This is needed to avoid calls from I/O while dealing with bank
	; switching (I/O addresses are the same)
	sei

	; Put char ROM in CPU address space
	; It becomes visible at $d000
	; This overrides I/O
;	lda $1
;	and #$fb
;	sta $1

	; Copy ROM original content from $d000 to $3800
;	ldx #0
;.copyLoop:
;	lda $d000,x
;	sta $3800,x
;	lda $d100,x
;	sta $3900,x
;	lda $d200,x
;	sta $3a00,x
;	lda $d300,x
;	sta $3b00,x
;	lda $d400,x
;	sta $3c00,x
;	lda $d500,x
;	sta $3d00,x
;	lda $d600,x
;	sta $3e00,x
;	lda $d700,x
;	sta $3f00,x
;	inx
;	bne .copyLoop

	; Copy The GGS Font and
	; make higher half the inverse of lower one
	ldx #$00
.tggsCopy
	dex
	lda .tggsFont,x
	sta $3800,x
	eor #$ff
	sta $3c00,x
	lda .tggsFont + $100,x
	sta $3900,x
	eor #$ff
	sta $3d00,x
	lda .tggsFont + $200,x
	sta $3a00,x
	eor #$ff
	sta $3e00,x
	lda .tggsFont + $300,x
	sta $3b00,x
	eor #$ff
	sta $3f00,x
	cpx #$0
	bne .tggsCopy

	; Edit character definitions in RAM (using previous defined table)
	ldx #$8
.editLoop:
	dex
	lda .multicolorSnakeTile,x
	sta $3800 + SNAKE_TILE * 8,x
	lda .multicolorFoodTile,x
	sta $3800 + FOOD_TILE * 8,x
;	lda .multicolorOtherTile,x
;	sta $3800 + SOME_TILE * 8,x
;	...
	cpx #$0
	bne .editLoop

	; Put ROM away from CPU address space, and re-enable I/O
;	lda $1
;	ora #$4
;	sta $1

; Set foreground color in [8-F] to all locations to enable multicolor mode for every single char
;	ldx #0
;	lda #$d
;colorLoop:
;	sta $d800,x
;	sta $d900,x
;	sta $da00,x
;	sta $db00,x
;	inx
;	bne colorLoop

	; Tell VIC-II to read characters from $3800 = 0xe * 0x400
	lda $d018
	ora #$0e
	sta $d018

	; Re-enable interrupts and return
	cli
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
.tggsFont
	INCBIN "tggs.font"
