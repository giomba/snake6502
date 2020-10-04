.POSIX:

ASM=$(wildcard src/*.asm)
RES=res.bin/amour.sid res.bin/levels.bin res.bin/unlzg.bin

.PHONY: debug env clean

bin/snake.bin: bin/snake.pack.lz
	dasm src/cart.asm -DVERBOSE=$(VERBOSE) -f3 -sbuild/cart.symbols.txt -obin/snake.bin

bin/snake.pack: env $(ASM) $(RES) bin/explodefont
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=$(DEBUG) -DVERBOSE=$(VERBOSE) -DCARTRIDGE=$(CARTRIDGE) -f3 -sbuild/pack.symbols.txt -obin/snake.pack

bin/snake.pack.lz: bin/snake.pack liblzg/src/tools/lzg
	liblzg/src/tools/lzg bin/snake.pack > bin/snake.pack.lz

liblzg/src/tools/lzg:
	cd liblzg/src && make

clean:
	rm -rf {build,bin,res.bin}

env:
	mkdir -p {build,bin,res.bin}

bin/explodefont: util/explodefont.cpp
	g++ -o bin/explodefont util/explodefont.cpp

res.bin/amour.sid:
	cp res.org/amour.sid res.bin/amour.sid

res.bin/levels.bin: bin/level res.org/levels.txt
	bin/level < res.org/levels.txt > res.bin/levels.bin

res.bin/unlzg.bin:
	cp res.org/unlzg.bin res.bin/unlzg.bin

bin/level: util/rlevel.cpp
	g++ -o bin/level util/rlevel.cpp


