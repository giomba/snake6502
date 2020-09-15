# snake6502

![Gameplay screenshot](scrot/gameplay.png)

*snake6502* is a snake-like game clone for Commodore home computers, written for fun because «I always wanted to code something for a computer of my retrocomputers collection – actually, this is the main reason I collect them: to write programs».

Download the [binary .prg](dist/snake.prg).

Current development status [here](https://git.giomba.it/giomba/snake6502).

## Compile
You need the GNU compiler collection and the [dasm](https://dasm-assembler.github.io/) macro assembler, then:
```
$ make
```
You can also define the following environment variables:

```$ DEBUG=1 make```        build with debugging artifacts

```$ VERBOSE=1 make```      output useful info during compilation

```$ CARTRIDGE=1 make```    produces an 8K bin ready to be burnt to an *PROM

## Developer docs
### Memory map
Address               | PRG   | Description
----------------------|-------|------------
```$0000 - $0001```   | no    | hardware
```$0002 - $00FF```   | no    | zero page pointers
```$0100 - $07FF```   | no    | *free ram*
```$0800 - $0FFF```   | yes   | autostart (BASIC or cartridge) + Low Program Segment
```$1000 - $1FFF```   | yes   | SID tune + Middle Program Segment
```$2000 - $27FF```   | yes   | custom char
```$2800 - $xxxx```   | yes   | High Program Segment (only needed part used)
```$xxxx - $CCFF```   | no    | *free ram*
```$CD00 - $CDFF```   | no    | data segment (not-initialized vars)
```$CE00 - $CEFF```   | no    | list X
```$CF00 - $CFFF```   | no    | list Y
```$D000 - $DFFF```   | no    | I/O
```$E000 - $FFFF```   | no    | Kernal

Note: program (code) segments have been put in all possible free spots in order to squeeze the game into an 8K cartridge.

### Custom charset
Index           | Description
----------------|-------------
```$00 - $1F``` |   A-Z (space first)
```$20 - $3F``` |   A-Z, reversed (space first)
```$40 - $4F``` |   hex digits
```$50 - $5F``` |   hex digits, reversed
```$60 -    ``` |   game tiles

### Cartridge
Cartridge version is at $8000 and simply copies itself back at $800.

Cartridge version can not be built with DEBUG=1 flag due to size constraints.

