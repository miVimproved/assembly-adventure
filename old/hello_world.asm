section .bss
	; Variables go here

section .data
	hello_world: db "I know the password to the digipensteamkiosk Steam account!", 10    ; Hello world to print
	hello_world_len: equ $-hello_world     ; Length of hello world
	; Constants

section .text
	global _start

	_start:

	mov rax, 1                     ; System Write
	mov rdi, 1                     ; Standard Output
	mov rsi, hello_world           ; Mov the message to write into rsi
	mov rdx, hello_world_len       ; Move the length of the message into rdx
	syscall                        ; Kernal call

	; End the program
	mov rax, 60                    ; sys_exit
	mov rdi, 0                     ; Basically return what's in rdi
	syscall                        ; Kernal call

