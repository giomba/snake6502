.POSIX:

ASM=$(wildcard src/*.asm)
RES=$(wildcard res/*)

.PHONY: debug env clean

bin/snake.prg: $(ASM) $(RES) | env
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=0 -obin/snake.prg

clean:
	rm -rf {build,bin}

env:
	mkdir -p {build,bin}

debug: $(ASM) $(RES) | env
	g++ -o bin/explodefont util/explodefont.cpp
	dasm src/main.asm -Isrc/ -DSYSTEM=64 -DDEBUG=1 -sbuild/symbols.txt -obin/snake.prg

