64:
	dasm snake.asm -DSYSTEM=64 -DDEBUG=0 -osnake.prg

debug:
	dasm snake.asm -DSYSTEM=64 -DDEBUG=1 -ssymbols.txt -osnake.prg

16:
	dasm snake.asm -DSYSTEM=16 -osnake.prg
