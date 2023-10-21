; Vim's Assembly Shenanigans!

section .data
	; Constants go here
	; The string that I can print
	hello_world: db "Hello, standard output!"
	hello_world_len: equ $-hello_world     ; Length of hello world

	newline: db 0x0a                       ; Newline character
	newline_len: equ $-newline             ; Length of the newline
                                               ; Gotten using the amount of data since that.
	std_err_message: db "This is going to stderr!", 0x0a
	std_err_len: equ $-std_err_message

	userin_msg: db "You did not put a V in?", 0x0a
	userin_msg_len: equ $-userin_msg



	; Syscalls
	sys_read: equ 0x00   ; I literally don't know what this does
	sys_write: equ 0x01  ; Writes to something, write to std_out to write to cout and std_err to write to cerr

	sys_exit: equ 0x3c

	; Other things
	std_io: equ 0x1 ; standard output
	std_err: equ 0x2 ; error output

section .bss
	userin: resb 100               ; User input array?
	userin_size: equ $-userin      ; User input array size?
	; Variables go here

section .text
	global _start

_start:

	; Print out Hello, World!
	mov rax, sys_write             ; System Write
	mov rdi, std_io                ; Standard Output
	mov rsi, hello_world           ; Mov the message to write into rsi
	mov rdx, hello_world_len       ; Move the length of the message into rdx
	syscall                        ; Kernal call

	; Print out the newline
	mov rax, sys_write
	mov rdi, std_io                ; printf("\n");
	mov rsi, newline
	mov rdx, newline_len
	syscall

	; Print out something to stderr
	mov rax, sys_write
	mov rdi, std_err
	mov rsi, std_err_message
	mov rdx, std_err_len
	syscall



	; Attempt to read something from cin

	mov rax, sys_read              ; Tell the system I want to read something
	mov rdi, std_io                ; does std_out work? Idk.
	mov rsi, userin                ; Where to put this in.
	mov rdx, userin_size           ; The size of where to put this
	syscall

	; Attempt to write that to the screen
	mov rax, sys_write
	mov rdi, std_io
	mov rsi, userin,
	mov rdx, 1                     ; Only take the first character
	; syscall ; Don't write anything rn


	; Check to see if the first character is a 'v'
	mov r9, "v"
	movzx r8, byte [userin]
	cmp r8, r9
	je skip
	
	; Write something to the screen if it was not a v
	mov rax, sys_write
	mov rdi, std_io
	mov rsi, userin_msg
	mov rdx, userin_msg_len
	syscall

skip:
	; End the program
	mov rax, sys_exit              ; sys_exit
	mov rdi, 0                     ; Basically return what's in rdi
	syscall                        ; Kernal call





