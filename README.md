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
Interesting targets:

* ```make bin/snake.bin``` produces .bin, ready to be burnt on an 8K EEPROM for making a cartridge (default)
* ```make bin/snake.prg``` produces .prg for the emulator, ready to be used on tape/disk
* ```make tape/disk``` (fastloader, to be done)

You can also define the following environment variables:

```$ DEBUG=1 make```        build with debugging artifacts

```$ VERBOSE=1 make```      output useful info during compilation

## Developer docs
### Package
The whole program is assembled into a ```snake.pack``` binary blob with the following structure.

Absolute    | Offset      | Description
------------|-------------|------------
```$1000``` | ```$0000``` | load address
```$2800``` | ```$1800``` | entry point (start address)

### Memory map
Address               | PRG   | Description
----------------------|-------|------------
```$0000 - $0001```   | no    | hardware
```$0002 - $00FF```   | no    | zero page pointers
```$0100 - $01FF```   | no    | stack page
```$0200 - $07FF```   | no    | *free ram*
```$1000 - $1FFF```   | yes   | SID tune
```$2000 - $27FF```   | yes   | custom char
```$2800 - $xxxx```   | yes   | Program segment (only needed part used)
```$xxxx - $CCFF```   | no    | *free ram*
```$CD00 - $CDFF```   | no    | data segment (not-initialized vars)
```$CE00 - $CEFF```   | no    | list X
```$CF00 - $CFFF```   | no    | list Y
```$D000 - $DFFF```   | no    | I/O
```$E000 - $FFFF```   | no    | Kernal

### Compression
```snake.pack``` is compressed into ```snake.pack.lz``` using [liblzg](https://github.com/mbitsnbites/liblzg), to save space in order to fit the game in a *PROM.

### Decompression
```cart.asm``` is located at ```$8000``` (standard org address for C64 cartridges), and contains the decompression routine and the ```snake.pack.lz```. It decompresses ```snake.pack.lz``` back to ```$1000```, and jumps to its entry point at ```$2800```.

### Miscellanea
#### Custom charset
Index           | Description
----------------|-------------
```$00 - $1F``` |   A-Z (space first)
```$20 - $3F``` |   A-Z, reversed (space first)
```$40 - $4F``` |   hex digits
```$50 - $5F``` |   hex digits, reversed
```$60 -    ``` |   game tiles

