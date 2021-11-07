; Zero page utility pointers
; ----------------------------------------------------------------------
    SEG zeropageSegment
; Pointer to level struct
levelPointer DS 2

; Pointer for Pointer in the NextPointer routine
nextPointerPointer DS 2

; Pointer to string for strlen routine
strlenString DS 2

; Interrupt counter
counter DS 2

; Note: Locations $90-$FF in zeropage are used by kernal


