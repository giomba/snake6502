.POSIX:

ASM=$(wildcard src/*.asm)
RES=res.bin/amour.sid res.bin/levels.bin

ifeq "$(CARTRIDGE)" "1"
	FORMAT:=3
else
	FORMAT:=1
endif

.PHONY: debug env clean

bin/snake.prg: env $(ASM) $(RES) bin/explodefont
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=$(DEBUG) -DVERBOSE=$(VERBOSE) -DCARTRIDGE=$(CARTRIDGE) -f$(FORMAT) -sbuild/symbols.txt -obin/snake.prg

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

bin/level: util/rlevel.cpp
	g++ -o bin/level util/rlevel.cpp


