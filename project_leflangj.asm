TITLE Portfolio Project     (program6_leflangj.asm)

; Author: James Leflang
; Last Modified: 05/30/2020
; OSU email address: leflangj@oregonstate.edu
; Course number/section: CS-271-400
; Project Number: 6               Due Date: 06/07/2020
; Description:

INCLUDE Irvine32.inc

ARRAYSIZE EQU 10

;--------------------------------------
getString MACRO bufferaddr:REQ, buffertyp:REQ
; Gets an input string to return the input in buffer.
; Avoid passing arguments in edx, ecx.
;--------------------------------------
	push	edx
	push	ecx

	mov		edx, bufferaddr
	mov		ecx, buffertyp
	call	ReadString

	pop		ecx
	pop		edx

ENDM

;--------------------------------------
displayString MACRO
;
;--------------------------------------



ENDM

.data

user_input		DWORD	ARRAYSIZE DUP(?)
sum				DWORD	?
input_buffer	BYTE	12 DUP(?)
program_title	BYTE	\
"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10, 0
program_auth	BYTE	"Written by: James Leflang", 13, 10, 0
program_instr1	BYTE	"Please provide 10 signed decimal integers.", 0
program_instr2	BYTE	\
"Each number needs to be small enough to fit inside a 32 bit register.", 0
program_instr3	BYTE	\
"After you have finished inputting the raw numbers I will display a list", 0
program_instr4	BYTE	"of the integers, their sum, and their average value.",0
program_prompt	BYTE	"Please enter an signed number: ", 0
program_inperr	BYTE	\
"ERROR: You did not enter a signed number or your number was too big.",13,10,0
program_retry	BYTE	"Please try again: ", 0
program_disp1	BYTE	"You entered the following numbers:", 13, 10, 0
program_disp2	BYTE	"The sum of these numbers is: ", 0
program_disp3	BYTE	"The rounded average is: ", 0
program_goodbye	BYTE	"Thanks for playing!", 13, 10, 0


.code
main PROC

	mov		edx, OFFSET program_title
	call	WriteString

	mov		edx, OFFSET program_auth
	call	WriteString

	call	CrLf

	push	OFFSET program_instr4
	push	OFFSET program_instr3
	push	OFFSET program_instr2
	push	OFFSET program_instr1
	call	Instruct

	call	CrLf

	push	SIZEOF input_buffer
	push	OFFSET input_buffer
	push	OFFSET program_prompt
	push	ARRAYSIZE
	push	OFFSET user_input
	call	ReadVal

	mov		edx, OFFSET program_disp1
	call	WriteString
	call	CrLf

	call	WriteVal

	mov		edx, OFFSET program_disp2
	call	WriteString

	push	OFFSET user_input
	push	sum
	call	Sum

	call	CrLf

	mov		edx, OFFSET program_disp3
	call	WriteString

	push	ARRAYSIZE
	push	sum
	call	Avg

	call	CrLf

	mov		edx, OFFSET program_goodbye
	call	WriteString

	exit	; exit to operating system
main ENDP

;--------------------------------------
Instruct PROC
; Give instructions to the user program and detail the functions.
; Preconditions: All strings must be on the stack
; Postconditions: None
; Stack State:
;	old ebp		ebp
;	ret @		ebp+4
;	instr1		ebp+8
;	instr2		ebp+12
;	instr3		ebp+16
;	instr4		ebp+20
; Registers Changed: esi, ecx, edx
; Returns: None
;--------------------------------------

	push	ebp
	mov		ebp, esp

	mov		ecx, 4
	mov		esi, ebp
	add		esi, 8

L1:	mov		edx, [esi]
	call	WriteString
	call	CrLf

	add		esi, 4
	
	loop	L1

	pop		ebp
	ret		16
Instruct ENDP

;--------------------------------------
ReadVal PROC
; Read and validate the user input using getString macro.
; Preconditions: The input array address and length must be on the stack.
; Postconditions:
; Stack State:
;	old ebp		ebp
;	ret @		ebp+4
;	input @		ebp+8
;	input len	ebp+12
;	prompt		ebp+16
;	buffer @	ebp+20
;	buffer size	ebp+24
; Registers changed:
; Returns: None
;--------------------------------------

	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp + 12]

Input:

	mov		edx, [ebp + 16]
	call	WriteString

	mov		esi, [ebp + 20]
	mov		edi, [ebp + 8]
	mov		edx, [ebp + 24]

	getString esi, edx

	xor		eax, eax

	push	ecx
	mov		ecx, [ebp + 28]
	dec		ecx

	cld
	lodsb
	

	cmp		al, 48
	jl		OutRange

	cmp		al, 57
	jg		OutRange

	sub		al, 48
	movzx	edx, al
	mul		eax, 10
	add		eax, edx
	rep		movsb

	pop		ecx

	call	CrLf
	loop	Input

	pop		ebp
	ret		20
ReadVal ENDP

;--------------------------------------
WriteVal PROC
;
;--------------------------------------



	displayString


	ret
WriteVal ENDP

;--------------------------------------
Sum PROC
;
;--------------------------------------



	ret
Sum ENDP

;--------------------------------------
Avg PROC
;
;--------------------------------------



	ret
Avg ENDP

END main
