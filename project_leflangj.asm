TITLE Portfolio Project     (program6_leflangj.asm)

; Author: James Leflang
; Last Modified: 05/30/2020
; OSU email address: leflangj@oregonstate.edu
; Course number/section: CS-271-400
; Project Number: 6               Due Date: 06/07/2020
; Description: This program takes the 10 signed integers as input from the user
;	and manually translates the ASCII to integers and outputs the integers' sum
;	and average as ASCII.

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
displayString MACRO outputVal
; Takes a value and outputs it as a string to console.
; Avoid passing arguements in edx
;--------------------------------------
	push	edx

	mov		edx, outputVal
	call	WriteString

	pop		edx
ENDM

.data

user_input		DWORD	ARRAYSIZE DUP(0)
sum_input		DWORD	?
buffer			BYTE	64 DUP(0)
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
program_space	BYTE	"  ", 0


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

	push	LENGTHOF buffer
	push	OFFSET input_size
	push	OFFSET buffer
	push	OFFSET program_inperr
	push	OFFSET program_prompt
	push	SIZEOF user_input
	push	OFFSET user_input
	call	ReadVal

	call	CrLf

	mov		edx, OFFSET program_disp1
	call	WriteString

	push	OFFSET program_space
	push	OFFSET buffer
	push	ARRAYSIZE
	push	OFFSET user_input
	call	WriteVal

	call	CrLf
	call	CrLf

	mov		edx, OFFSET program_disp2
	call	WriteString

	push	OFFSET buffer
	push	OFFSET sum_input
	push	ARRAYSIZE
	push	OFFSET user_input
	call	Sum

	call	CrLf

	mov		edx, OFFSET program_disp3
	call	WriteString

	push	OFFSET buffer
	push	sum_input
	push	ARRAYSIZE
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
LOCAL signFlag:BYTE
; Read and validate the user input using getString macro.
; Preconditions: The input array address and length must be on the stack.
; Postconditions: Stack is clean and buffer+input_size are sanitized.
; Stack State:
;	signFlag	ebp-4
;	old ebp		ebp
;	ret @		ebp+4
;	input @		ebp+8
;	input size	ebp+12
;	prompt		ebp+16
;	error		ebp+20
;	buffer @	ebp+24
;	input_size	ebp+28
;	buffer len	ebp+32
; Registers changed: eax, ebx, ecx, esi, edi
; Returns: None
;--------------------------------------

	mov		esi, [ebp + 24]
	mov		edi, [ebp + 8]
	mov		signFlag, 0

Input:
	; Check if we are finished
	mov		eax, [ebp + 12]
	add		eax, [ebp + 8]
	cmp		edi, eax
	jge		Finish

	; Get the user input
	getString esi, [ebp + 32], [ebp + 28], [ebp + 16]

	; Setup to process the input
	xor		eax, eax
	xor		ebx, ebx
	mov		ax, 1

	; Prepare the loop
	cld
	mov		ebx, 1
	mov		ecx, [ebp + 28]
	sub		ecx, 1
	cmp		ecx, 0
	jz		L1

	cmp		ecx, 11
	jg		Inval

	mov		ebx, 10

Mut:
	mul		ebx
	loop	Mut

	mov		ebx, eax
	mov		ecx, [ebp + 28]

	xor		eax, eax

L1:			; LOOP: For each char in the string
	; load the last value
	lodsb

	; End at the null
	cmp		al, 0
	je		Next

	; if there is a plus sign, still valid but need go to next
	cmp		al, 43
	je		L1
	
	; Check for a negative sign
	cmp		al, 45
	jne		Cont

	mov		signFlag, 1

	; Two's Complement
	mov		eax, [edi]
	xor		eax, 0
	add		eax, 1
	jmp		L1

Cont:		; Check to make sure the input is an integer value
	cmp		al, 48
	jl		Inval

	cmp		al, 57
	jg		Inval

	; Store it
	sub		al, 48
	mul		ebx
	mov		edx, [edi]
	add		eax, edx

	cmp		signFlag, 1
	je		isNegative
	
	cmp		eax, 7FFFFFFFh
	jo		Inval
	jle		Val

isNegative:
	cmp		eax, 80000000h
	jo		Inval

Val:
	mov		[edi], eax

	xor		edx, edx

	; Divide by 10
	mov		eax, ebx
	mov		ebx, 10
	cdq
	div		ebx
	mov		ebx, eax

	xor		eax, eax

	; loop until the current input is transfered
	loop	L1

Next:		; Go to the next number in the array
	mov		esi, [ebp + 24]
	add		edi, 4
	jmp		Input

Inval:		; Invalid input
	mov		edx, [ebp + 20]
	call	WriteString

	call	CrLf
	jmp		Input

Finish:
	; Sanitize the buffer and input_size
	mov		edi, [ebp + 24]
	mov		ecx, [ebp + 32]

L2:	mov		BYTE PTR [edi], 0
	add		edi, 1

	loop	L2

	mov		esi, [ebp + 28]
	mov		esi, 0

	ret		28
ReadVal ENDP

;--------------------------------------
WriteVal PROC
LOCAL	curVal:DWORD
; Output the user input using the WriteVal macro.
; Preconditions: The input array address and length must be on the stack.
; Postconditions: Stack is clean
; Stack State:
;	curVal		ebp-4
;	old ebp		ebp
;	ret @		ebp+4
;	input @		ebp+8
;	input len	ebp+12
;	buffer @	ebp+16
;	space		ebp+20
; Registers changed: eax, ebx, ecx, edx, esi, edi
; Returns: None
;--------------------------------------

	; Setup
	mov		ecx, [ebp + 12]
	mov		esi, [ebp + 8]
	mov		edi, [ebp + 16]
	mov		curVal, 0

	cld
	
L1:			; LOOP: for all numbers in the array
	mov		eax, [esi]
	mov		curVal, eax

	; Check if negative
	test	eax, 0
	jns		isPos

	; Two's Complement
	xor		eax, eax
	add		eax, 1

	; Add a minus sign
	mov		ebx, eax
	xor		eax, eax
	mov		al, 45
	stosb

	mov		eax, ebx
	mov		curVal, eax

isPos:		; Just a positive number
	; Setup
	mov		ebx, 10
	cmp		eax, 10
	jle		OneDigit

L2:			; Divide by 10
	cdq
	div		ebx
	cmp		eax, 10
	jl		Accum

	; If the quotient is larger than 10,
	;	then go in multiples of 10 until less than 10
	mov		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, eax
	mov		eax, curVal
	jmp		L2

Accum:		; Store the ASCII value
	add		al, 48
	stosb

	; move the remainder
	mov		eax, edx
	mov		curVal, eax

	; If it is more than 10 then we continue
	cmp		eax, 10
	jge		isPos

	; Only the one's place is left
OneDigit:
	add		al, 48
	stosb

	; Write the value out
	mov		edi, [ebp + 16]
	displayString edi

	mov		edx, [ebp + 20]
	call	WriteString

	; Got to the next value in the array
	add		esi, 4
	loop	L1

	ret		16
WriteVal ENDP

;--------------------------------------
Sum PROC
LOCAL	curVal:DWORD
; Sum the numbers and display the sum.
; Preconditions: The input array address and length must be on the stack.
; Postconditions: Stack is clean
; Stack State:
;	curVal		ebp-4
;	old ebp		ebp
;	ret @		ebp+4
;	input @		ebp+8
;	input len	ebp+12
;	sum @		ebp+16
;	buffer @	ebp+20
; Registers changed: eax, ebx, ecx, edx, esi, edi
; Returns: None
;--------------------------------------

	xor		eax, eax

	mov		ecx, [ebp + 12]
	mov		esi, [ebp + 8]
	mov		edi, [ebp + 16]

L1:			; Sum all the numbers
	mov		ebx, [esi]
	add		eax, ebx
	add		esi, 4
	loop	L1

	; Prepare to display
	mov		curVal, eax
	mov		[edi], eax
	mov		esi, edi
	mov		edi, [ebp + 20]

	cld

	; Check if negative
	test	eax, 0
	jns		isPos

	; Two's Complement
	xor		eax, eax
	add		eax, 1

	; Add a minus sign
	mov		ebx, eax
	xor		eax, eax
	mov		al, 45
	stosb

	mov		eax, ebx
	mov		curVal, eax

isPos:		; Just a positive number
	; Setup
	mov		ebx, 10
	cmp		eax, 10
	jle		OneDigit

L2:			; Divide by 10
	cdq
	div		ebx
	cmp		eax, 10
	jl		Accum

	; If the quotient is larger than 10,
	;	then go in multiples of 10 until less than 10
	mov		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, eax
	mov		eax, curVal
	jmp		L2

Accum:		; Store the ASCII value
	add		al, 48
	stosb

	; move the remainder
	mov		eax, edx
	mov		curVal, eax

	; If it is more than 10 then we continue
	cmp		eax, 10
	jge		isPos

	; Only the one's place is left
OneDigit:
	add		al, 48
	stosb

	; Write the value out
	mov		edi, [ebp + 20]

	displayString edi

	ret		16
Sum ENDP

;--------------------------------------
Avg PROC
LOCAL	curVal:DWORD
; Display the sum.
; Preconditions: The sum and the array length must be on the stack.
; Postconditions: Stack is clean
; Stack State:
;	curVal		ebp-4
;	old ebp		ebp
;	ret @		ebp+4
;	input len	ebp+8
;	sum			ebp+12
;	buffer @	ebp+16
; Registers changed: eax, ebx, ecx, edx, esi, edi
; Returns: None
;--------------------------------------

	xor		eax, eax
	; Grab the sum and the array length and divide
	mov		ebx, [ebp + 8]
	mov		eax, [ebp + 12]

	cdq
	div		ebx

	; Prepare the print out
	cld
	mov		edi, [ebp + 16]
	xor		ebx, ebx

	mov		curVal, eax

	; Check if negative
	test	eax, 0
	jns		isPos

	; Two's Complement
	xor		eax, eax
	add		eax, 1

	; Add a minus sign
	mov		ebx, eax
	xor		eax, eax
	mov		al, 45
	stosb

	mov		eax, ebx
	mov		curVal, eax

isPos:		; Just a positive number
	; Setup
	mov		ebx, 10
	cmp		eax, 10
	jle		OneDigit

L2:			; Divide by 10
	cdq
	div		ebx
	cmp		eax, 10
	jl		Accum

	; If the quotient is larger than 10,
	;	then go in multiples of 10 until less than 10
	mov		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, eax
	mov		eax, curVal
	jmp		L2

Accum:		; Store the ASCII value
	add		al, 48
	stosb

	; move the remainder
	mov		eax, edx
	mov		curVal, eax

	; If it is more than 10 then we continue
	cmp		eax, 10
	jge		isPos

	; Only the one's place is left
OneDigit:
	add		al, 48
	stosb

	; Write the value out
	mov		[edi], eax

	displayString edi

	ret		12
Avg ENDP

END main
