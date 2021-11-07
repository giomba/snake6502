    processor 6502

    SEG.U zeropageSegment
    org $02

    SEG loaderSegment
    org $801
autostartRoutine SUBROUTINE
    ; this is at $801
    ; and it MUST be exactly at this location in order to autostart
	; 10 SYS2060 ($80c) BASIC autostart
    BYTE #$0b,#$08,#$0a,#$00,#$9e,#$32,#$30,#$36,#$31,#$00,#$00,#$00

    ; this is at (2061 dec)=($80d)
    ; and it MUST be exactly after the above BASIC statement
. = $80d
    ; load pack from tape
    lda #(packFileNameEnd - packFileName)      ; filename length
    ldx #<packFileName                         ; filename string address
    ldy #>packFileName
    jsr $ffbd                                  ; setnam

    lda #$01                                   ; file nr
    ldx $ba                                    ; last used device nr
    ldy #$01                                   ; load to address stored in file
    jsr $ffba                                  ; setlfs

    lda #$0                                    ; load to memory
    jsr $ffd5                                  ; load

    ; address of input compressed data
    lda #$00
    sta srcPointer
    lda #$80
    sta srcPointer + 1

    ; address of output decompressed data
    lda #$00
    sta dstPointer
    lda #$10
    sta dstPointer + 1

    jsr inflate

    jmp $2800

    ; decompression util
    INCLUDE "lzgmini.asm"

;   DATA
; -------------------------------------
    SEG loaderSegment
packFileName:
    BYTE "PACKLZ"
packFileNameEnd:


