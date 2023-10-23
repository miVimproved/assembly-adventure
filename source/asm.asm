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

	userin_msg: db "You did not put a v in?", 0x0a
	userin_msg_len: equ $-userin_msg

	msg_got_v: db "Thank you!", 0xa
	msg_got_v_len: equ $-msg_got_v

	msg_v_tell: db "Please enter a 'v' in.", 0x0a, "> "
	msg_v_tell_len: equ $-msg_v_tell



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

_start_old:

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

	; Print out a few newlines
	mov rax, sys_write
	mov rdi, std_io
	mov rsi, newline
	mov rdx, newline_len
	syscall
	syscall                       ; I know I can do this, but most of the time I don't just so I can have more practice with mov
	
_start:


	; Print out the enter a v message.

	mov rsi, msg_v_tell
	mov rdx, msg_v_tell_len
	call print


	; Attempt to read something from cin
	mov rsi, userin                ; Where to put this in.
	mov rdx, userin_size
	call getin


	; Attempt to write that to the screen
	mov rsi, userin,
	mov rdx, 1                     ; Only take the first character
	; call print


	; Check to see if the first character is a 'v'
	movzx r8, byte [userin]
	cmp r8, "v"
	
	mov r9, userin_msg
	mov r10, userin_msg_len
	cmovnz rsi, r9
	cmovnz rdx, r10
	
	mov r9, msg_got_v
	mov r10, msg_got_v_len
	cmovz rsi, r9
	cmovz rdx, r10

	call print ; print out that thingie

	; End the program
	mov rax, sys_exit              ; sys_exit
	mov rdi, 0                     ; Basically return what's in rdi
	syscall                        ; Kernal call






print:  ; assumes that rsi and rdx are set already
	mov rdi, std_io

print_noset:
	mov rax, sys_write
	syscall
	ret


pusherr:
	mov rdi, std_err
	call print_noset
	ret

getin:
	mov rdi, std_io
	mov rax, sys_read
	syscall
	ret


