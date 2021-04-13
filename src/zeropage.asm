; Zero page utility pointers
; ----------------------------------------------------------------------
; Where is the snake head in video memory? Do math to calculate address
; using pointer at tileMem,tileMem+1
tileMem DS 2

; Pointer to string
srcStringPointer DS 2
; Pointer to screen position where to print intro string
dstScreenPointer DS 2

; Pointer to level struct
levelPointer DS 2

; Pointer to video memory used in the level loading routine
levelVideoPointer DS 2
levelColorPointer DS 2

; Pointer for Pointer in the NextPointer routine
nextPointerPointer DS 2

; Pointer to string for strlen routine
strlenString DS 2

; Generic src/dst copy pointers
srcPointer DS 2
dstPointer DS 2

; Interrupt counter
counter DS 2

; Note: Locations $90-$FF in zeropage are used by kernal


