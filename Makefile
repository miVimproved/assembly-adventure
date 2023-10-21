make:
	@./shmakefile.sh
	@rm asm.o
	@rm -f asm.o a.out

keep:
	@./shmakefile.sh

clean:
	@rm -f asm.o a.out
