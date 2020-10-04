    processor 6502

    SEG cartridgeSegment
    org $8000

cartridge SUBROUTINE
    WORD .coldstart
    WORD .warmstart

    ; CBM80 in PETSCII (cartridge signature for autostart)
    BYTE #$c3,#$c2,#$cd,#$38,#$30

.unlzg:
    INCBIN "res.bin/unlzg.bin"

.lzpack:
    INCBIN "bin/snake.pack.lz"

.coldstart:
    sei
    stx $d016
    jsr $fda3
    jsr $fd50
    jsr $fd15
    jsr $ff5b
    cli

.warmstart:
    ; address of input compressed data
    lda #<.lzpack
    sta 26
    lda #>.lzpack
    sta 27

    ; address of output decompressed data
    lda #$00
    sta 28
    lda #$10
    sta 29
    jsr .unlzg

    ; jump to program entry
    jmp $2800


#if VERBOSE = 1
    ECHO "8k CARTRIDGE SIZE:",(. - $8000),"=",[(. - $8000)d]
    ECHO "SPACE LEFT:",($9fff - .),"=",[($9fff - .)d]
#endif

    ; force filler for the *PROM
. = $9fff
    BYTE #$ff

