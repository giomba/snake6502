; ENTRY OF PROGRAM
; ----------------------------------------------------------------------
start:
    ; Clear screen, initialize keyboard, restore interrupts
    jsr $ff81

    ; Disable all interrupts
    sei

    ; Turn off CIA interrupts and (possibly) flush the pending queue
    ldy #$7f
    sty $dc0d
    sty $dd0d
    lda $dc0d
    lda $dd0d

    ; Set Interrupt Request Mask as we want IRQ by raster beam
    lda #$1
    sta $d01a

    ; Store in $314 address of our custom interrupt handler
    ldx #<irq   ; least significant byte
    ldy #>irq   ; most significant byte
    stx $314
    sty $315

    ; Set raster beam to trigger interrupt at row zero
    lda #$00
    sta $d012

    ; Bit#0 of $d011 is used as bit#9 of $d012, and must be zero
    lda $d011
    and #$7f
    sta $d011

    ; Initialize player for first song
    lda #0
    jsr sidtune

    ; Initialize MultiColor mode
    jsr multicolorInit

    ; Zero-fill zeropage variables
    lda #$0
    ldx #$90
zeroFillZeroPage:
    dex
    sta $0,x
    cpx #$2
    bne zeroFillZeroPage

    ; Set status as first-time intro playing
    lda #ST_INTRO0
    sta status

    ; Enable interrupts
    cli

    ; Reset screen (and other parameters) to play intro
    jsr introreset

intro0running:              ; Cycle here until SPACE or `Q` is pressed
    jsr $ffe4               ; GETIN
    cmp #$20                ; Is it SPACE?
    beq intro0end           ; if yes, go to intro0end and start game (see)
    cmp #$51                ; Is it Q?
    bne intro0running       ; If not, keep looping here,
    jmp $fce2               ; else, reset the computer

    ; Intro is finished, now it's time to start the proper game
intro0end:
    ; Set init variables of the game
    jsr gamereset

    ; Set status as level select
    ; (then it will enter in status play)
    lda #ST_LEVEL_TITLE
    sta status

endless:
    ; Loop waiting for gameover
    lda status
    cmp #ST_END     ; is status equal to end ?
    bne endless     ; if not, just wait looping here, else...

    jsr introreset  ; reset variables for intro
    lda #ST_INTRO0
    sta status      ; put machine into play intro status
    jmp intro0running   ; and go there waiting for keypress

; Interrupt Handler
; ----------------------------------------------------------------------
irq:
    ; Things that must be done every interrupt (50Hz)
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Acknoweledge IRQ
    dec $d019

    ; Save registers in stack
    pha
    txa
    pha
    tya
    pha

#if DEBUG = 1
    ; Change background to visually see the ISR timing
    lda #2
    sta $d020
#endif

    ; Check status and call appropriate sub-routine
    ; Sort of switch-case
    lda status
    cmp #ST_INTRO0
    bne checkStatusIntro1
    jsr statusIntro0
    jmp checkEndStatus
checkStatusIntro1:
    cmp #ST_INTRO1
    bne checkStatusPlay
    jsr statusIntro1
    jmp checkEndStatus
checkStatusPlay:
    cmp #ST_PLAY
    bne checkStatusDelay
    jsr statusPlay
    jmp checkEndStatus
checkStatusDelay:
    cmp #ST_DELAY
    bne checkStatusLevelTitle
    jsr statusDelay
    jmp checkEndStatus
checkStatusLevelTitle:
    cmp #ST_LEVEL_TITLE
    bne checkStatusLevelLoad
    jsr statusLevelTitle
    jmp checkEndStatus
checkStatusLevelLoad:
    cmp #ST_LEVEL_LOAD
    bne checkEndStatus
    jsr statusLevelLoad
    jmp checkEndStatus
checkEndStatus:

#if DEBUG = 1
    ; Change background to show how much time does music take for each interrupt
    lda #1
    sta $d020
#endif

    ; Play music
    jsr sidtune + 3
    jsr sidtune + 3
    jsr sidtune + 3
    jsr sidtune + 3
    jsr sidtune + 3

    ; Increase random value
    inc random

#if DEBUG = 1
    ; Change background back again to visally see ISR timing
    lda #11
    sta $d020
#endif

    ; Restore registers from stack
    pla
    tay
    pla
    tax
    pla

    ; Go to original system routine
    jmp $ea31


