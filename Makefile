64:
	dasm main.asm -DSYSTEM=64 -DDEBUG=0 -osnake.prg

debug:
	dasm main.asm -DSYSTEM=64 -DDEBUG=1 -ssymbols.txt -osnake.prg

16:
	dasm main.asm -DSYSTEM=16 -osnake.prg
