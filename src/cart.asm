    processor 6502

; SEGMENTS
    SEG.U zeropageSegment
    org $02
    SEG loaderSegment
    org $8000

; LOADER
    SEG loaderSegment
cartridge SUBROUTINE
    WORD .coldstart
    WORD .warmstart

    ; CBM80 in PETSCII (cartridge signature for autostart)
    BYTE #$c3,#$c2,#$cd,#$38,#$30

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
    sta srcPointer
    lda #>.lzpack
    sta srcPointer + 1

    ; address of output decompressed data
    lda #$00
    sta dstPointer
    lda #$10
    sta dstPointer + 1
    jsr inflate

    ; jump to program entry
    jmp $2800

    ; compressed pack
.lzpack:
    INCBIN "bin/snake.pack.lz"

    ; decompression util
    INCLUDE "lzgmini.asm"

    ECHO "8k CARTRIDGE SIZE:",(. - $8000),"=",[(. - $8000)d]
    ECHO "SPACE LEFT:",($9fff - .),"=",[($9fff - .)d]

    ; force filler for the *PROM
. = $9fff
    BYTE #$ff
