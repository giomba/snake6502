#if VERBOSE = 1
LASTINIT SET .
#endif

cartridge SUBROUTINE

    WORD #$8009
    WORD #$801a

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
    ; Copy cartridge content into proper memory location
    ldx #$20
    lda #$0
    tay
    sta srcPointer
    sta dstPointer
    lda #>cartridgeStart
    sta srcPointer + 1
    lda #$08
    sta dstPointer + 1
.loop:
    lda (srcPointer),y
    sta (dstPointer),y
    iny
    bne .loop
    inc srcPointer + 1
    inc dstPointer + 1
    dex
    bne .loop

    jmp start

#if VERBOSE = 1
    ECHO "cart.asm @ ",LASTINIT,"len:",(. - LASTINIT)
#endif