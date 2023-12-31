; Vim's Assembly Shenanigans!

section .data ; Constants go here
	; Helpful strings
	help_newline: db 0x0a, 0x00
	help_clear_screen: db `\033[2J\033[H`, 0x00 ; Lowercase J and Lowercase H is the funni

	; Strings in "Enter a v"
	msg_ask_for_v: db "Welcome to 1 letter Hangman!", 0x0a, "Please enter a 'v'.", 0x0a, "> ", 0x00
	msg_not_v: db "The blood is on your hands.", 0x00
	msg_got_v: db "Congratulations! YOU WIN!", 0x00
	msg_tayasmfatpamg: db "Thank a you a so much for a to playing a my game!", 0x00
	


	; Syscalls
	sys_read: equ 0x00   ; I literally don't know what this does
	sys_write: equ 0x01  ; Writes to something, write to std_out to write to cout and std_err to write to cerr

	sys_exit: equ 0x3c

	; Other things
	std_io: equ 0x1 ; standard io
	std_err: equ 0x2 ; error output

section .bss ; Variables go here
	; Temporary buffer to do things with
	temp_buffer: resb 64
	temp_buffer_len: equ $-temp_buffer

	userin: resb 1                ; User input array
	userin_len: equ $-userin      ; User input array size

section .text ; Code goes here
	global _start


; Macros defined here

; puts_newline - Puts a newline
%macro puts_newline 0
	mov rsi, help_newline
	call print
%endmacro

; putsl - Put Screen with a Line
%macro putsl 1
	mov rsi, %1
	call print
	mov rsi, help_newline
	call print
%endmacro

; puts - Put Screen
%macro puts 1
	mov rsi, %1
	call print
%endmacro

; cin - Gets user input and then flushes the input buffer
%macro cin 2
	; Get the user input
	mov rsi, $1
	mov rdx, $2
	call getin
%endmacro

; push - pushes to stack
%macro push 2-*
	%rep %0
		push %1
	%rotate 1
	%endrep
%endmacro

; pop - pops from stack
%macro pop 2-*
	%rep %0
	%rotate -1
		pop %1
	%endrep
%endmacro

_start:

	; Doesn't work yet, I don't know why
	puts help_clear_screen

	; Print out the enter a v message.
	puts msg_ask_for_v

	; Attempt to read something from cin
	;cin userin, userin_len
	mov rsi, userin
	mov rdx, userin_len
	call getin

	; call flush_cin

	; Check to see if the first character is a 'v'
	movzx r8, byte [userin]
	cmp r8, "v"

	; Move the correct "got" message in
	mov rsi, msg_got_v

	; I have to do this R.I.P
	mov r9, msg_not_v
	cmovnz rsi, r9

	call print ; print out that thingie

	%rep 2
	puts_newline
	%endrep

	putsl msg_tayasmfatpamg

	; End the program
	mov rax, sys_exit              ; sys_exit
	mov rdi, 0                     ; Basically return what's in rdi
	syscall                        ; Kernal call


print:  ; assumes that rsi and rdx are set already
	mov rdi, std_io

print_noset:
	call strlen
	mov rdx, rax
	mov rax, sys_write
	syscall
	ret


pusherr:
	mov rdi, std_err
	call print_noset
	ret

getin:
	mov rax, sys_read
	mov rdi, std_io
	syscall
	ret

strlen: ; Input string is in rsi, return value is in rax
	push r14, r15

	mov rax, 0  ; Clear rax
	mov r14, rsi ; Load the string address into r14 

	jmp strlen__loop

strlen__loop_one:
	add rax, 1

strlen__loop:
	; Load the next character into r15
	movzx r15, byte [r14+rax]

	cmp r15, 0x00 ; Check r15 with the null character
	jne strlen__loop_one ; Jump back to there if it's not a zero

	pop r14, r15

	ret

flush_cin:
	ret
