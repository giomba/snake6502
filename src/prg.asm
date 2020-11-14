    processor 6502

    SEG.U
    org $02
    INCLUDE "zeropage.asm"

    SEG autostart
    org $801
autostartRoutine SUBROUTINE
    ; this is at $801
    ; and it MUST be exactly at this location in order to autostart
	; 10 SYS2060 ($80c) BASIC autostart
    BYTE #$0b,#$08,#$0a,#$00,#$9e,#$32,#$30,#$36,#$31,#$00,#$00,#$00

    ; this is at (2061 dec)=($80d)
    ; and it MUST be exactly after the above BASIC statement
. = $80d
    jmp $2800

. = $1000
    INCBIN "../bin/snake.pack"

#if VERBOSE = 1
    ECHO "PRG SIZE:",(. - $801 + 2),"=",[(. - $801 + 2)d]
#endif

