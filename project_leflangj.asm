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
getString MACRO bufferaddr, buffertyp, bufsize, prompt
; Gets an input string to return the input in buffer.
; Avoid passing arguments in edx, ecx, eax.
;--------------------------------------
	push	edx
	push	ecx
	push	eax

	mov		edx, prompt
	call	WriteString

	mov		edx, bufferaddr
	mov		ecx, buffertyp
	call	ReadString

	mov		[bufsize], eax

	pop		eax
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
sum_input		DWORD	?
input_buffer	BYTE	12 DUP(?)
input_size		BYTE	?
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
	push	OFFSET input_size
	push	OFFSET input_buffer
	push	OFFSET program_inperr
	push	OFFSET program_prompt
	push	SIZEOF user_input
	push	OFFSET user_input
	call	ReadVal

	mov		edx, OFFSET program_disp1
	call	WriteString
	call	CrLf

	call	WriteVal

	mov		edx, OFFSET program_disp2
	call	WriteString

	push	OFFSET user_input
	push	sum_input
	call	Sum

	call	CrLf

	mov		edx, OFFSET program_disp3
	call	WriteString

	push	ARRAYSIZE
	push	sum_input
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
;	input size	ebp+12
;	prompt		ebp+16
;	error		ebp+20
;	buffer @	ebp+24
;	input_size	ebp+28
;	buffer size	ebp+32
; Registers changed:
; Returns: None
;--------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp + 20]
	mov		edi, [ebp + 8]

Input:
	; Check if we are finished
	mov		eax, [ebp + 12]
	add		eax, [ebp + 8]
	cmp		edi, eax
	jg		Finish

	; Get the user input
	getString esi, [ebp + 32], [ebp + 28], [ebp + 16]

	; Setup to process the input
	xor		eax, eax
	xor		ebx, ebx
	mov		bl, 1

	; Prepare the loop
	std
	mov		ecx, [ebp + 28]

L1:			; LOOP: For each char in the string
	; load the last value
	lodsb

	; Skip the null
	cmp		al, 0
	je		L1

	; Check for a negative sign
	cmp		al, 45
	jne		Cont

	; Two's compliment
	mov		eax, [edi]
	xor		eax, 0
	add		eax, 1

	; Store the value and we are ready for the next input
	mov		[edi], eax
	add		edi, 4
	jmp		Input

Cont:		; Check to make sure the input is an integer value
	cmp		al, 48
	jl		Inval

	cmp		al, 57
	jg		Inval

	; Store it
	sub		al, 48
	mul		bl
	stosb

	; 10 times the current multiplier
	mov		ah, al
	mov		al, bl
	mov		bl, 10
	mul		bl
	mov		bl, al
	mov		al, ah

	; loop until the current input is transfered
	loop	L1

	; Go to the next number in the array
	add		edi, 4
	jmp		Input

Inval:		; Invalid input
	mov		edx, [ebp + 20]
	call	WriteString

	call	CrLf
	jmp		Input

Finish:
	pop		ebp
	ret		28
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
