.POSIX:

ASM=$(wildcard src/*.asm)
RES=res.bin/amour.sid res.bin/levels.bin

.PHONY: debug env clean

bin/snake.prg: env $(ASM) $(RES)
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=0 -obin/snake.prg

clean:
	rm -rf {build,bin,res.bin}

env:
	mkdir -p {build,bin,res.bin}

debug: $(ASM) $(RES)
	g++ -o bin/explodefont util/explodefont.cpp
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=1 -sbuild/symbols.txt -obin/snake.prg

res.bin/amour.sid:
	cp res.org/amour.sid res.bin/amour.sid

res.bin/levels.bin: bin/level res.org/levels.txt
	bin/level < res.org/levels.txt > res.bin/levels.bin

bin/level: util/rlevel.cpp
	g++ -o bin/level util/rlevel.cpp


