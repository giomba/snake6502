.POSIX:

ASM=$(wildcard src/*.asm)
RES=res.bin/amour2.sid res.bin/levels.bin res.bin/unlzg.bin

.PHONY: debug env clean all

all: bin/snake6502.bin bin/snake6502.d64

bin/snake6502.bin: bin/snake.pack.lz
	dasm src/cart.asm -Isrc/ -f3 -T1 -sbuild/cart.symbols.txt -obin/snake6502.bin

bin/snake6502.d64: bin/loader.prg
	c1541 -format "snake6502,01" d64 bin/snake6502.d64
	c1541 -attach bin/snake6502.d64 -write bin/loader.prg loader
	c1541 -attach bin/snake6502.d64 -write bin/snake.pack.lz.prg packlz

bin/loader.prg: bin/snake.pack.lz.prg
	dasm src/loader.asm -Isrc/ -f1 -sbuild/loader.sybols.txt -obin/loader.prg

bin/snake.prg: bin/snake.pack
	dasm src/prg.asm -Isrc/ -f1 -T1 -sbuild/prg.symbols.txt -obin/snake.prg

bin/snake.pack: env $(ASM) $(RES) bin/explodefont
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=$(DEBUG) -f3 -T1 -sbuild/pack.symbols.txt -obin/snake.pack

bin/snake.pack.lz: bin/snake.pack liblzg/src/tools/lzg
	liblzg/src/tools/lzg bin/snake.pack > bin/snake.pack.lz

bin/snake.pack.lz.prg: bin/snake.pack.lz
	echo -n -e "\x00\x80" > bin/snake.pack.lz.prg
	cat bin/snake.pack.lz >> bin/snake.pack.lz.prg

liblzg/src/tools/lzg:
	cd liblzg/src && make

clean:
	rm -rf {build,bin,res.bin}

env:
	mkdir -p {build,bin,res.bin}

bin/explodefont: util/explodefont.cpp
	g++ -o bin/explodefont util/explodefont.cpp

res.bin/amour2.sid:
	cp res.org/amour2.sid res.bin/amour2.sid

res.bin/levels.bin: bin/level res.org/levels.txt
	bin/level < res.org/levels.txt > res.bin/levels.bin

res.bin/unlzg.bin:
	cp res.org/unlzg.bin res.bin/unlzg.bin

bin/level: util/rlevel.cpp
	g++ -o bin/level util/rlevel.cpp


