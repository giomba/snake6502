; Zero page utilities
; ----------------------------------------------------------------------
; Where is the snake head in video memory? Do math to calculate address
; using pointer at tileMem,tileMem+1
tileMem DS 2

; Pointer to status string
printStatusString DS 2

; Pointer to intro string
printIntroString DS 2
; Pointer to screen position where to print intro string ($fb-$fc)
introScreenStart DS 2

#if DEBUG = 1
    ; Locations $90-$FF in zeropage are used by kernal
    ECHO "End of zeropage variables. Space left: ",($90 - .)
#endif


