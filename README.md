# snake6502

*snake6502* is a snake-like game clone for Commodore home computers, written for fun because «I always wanted to code something for a computer of my retrocomputers collection – actually, this is the main reason I collect them: to write programs».

## Compile
You need the [dasm](https://dasm-assembler.github.io/) macro assembler, then:
```
$ make
```
You can also make it output useful extra info with:
```
$ make debug
```


## Memory map
Address               | PRG   | Description
----------------------|-------|------------
```$0000 - $0001```   | no    | hardware
```$0002 - $00FF```   | no    | zero page pointers
```$0100 - $07FF```   | no    | *free ram*
```$0800 - $0FFF```   | yes   | data segment + BASIC autostart
```$1000 - $1FFF```   | yes   | SID tune
```$2000 - $27FF```   | yes   | custom char
```$2800 - $xxxx```   | yes   | program logic (only needed part used)
```$xxxx - $CDFF```   | no    | *free ram*
```$CE00 - $CEFF```   | no    | list X
```$CF00 - $CFFF```   | no    | list Y
```$D000 - $DFFF```   | no    | I/O
```$E000 - $FFFF```   | no    | Kernal

