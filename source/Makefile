make:
	@./shmakefile.sh
	@./a.out
	@rm asm.o
	@rm -f asm.o a.out

keep:
	@./shmakefile.sh
	@./a.out

clean:
	@rm -f asm.o a.out

debug:
	@./shmakefile.sh
	@gdb ./a.out

reqs:
	sudo pacman -S nasm