TITLE Portfolio Project     (program6_leflangj.asm)

; Author: James Leflang
; Last Modified: 05/30/2020
; OSU email address: leflangj@oregonstate.edu
; Course number/section: CS-271-400
; Project Number: 6               Due Date: 06/07/2020
; Description:

INCLUDE Irvine32.inc

ARRAYSIZE EQU 10

.data

user_input		DWORD	ARRAYSIZE DUP(?)
program_title	BYTE	\
"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10, 0
program_auth	BYTE	"Written byte: James Leflang", 13, 10, 0
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

	mov		edx, OFFSET program_prompt
	call	WriteString

	call	WriteVal


	mov		edx, OFFSET program_disp1
	call	WriteString
	call	CrLf

	call	DisplayString

	mov		edx, OFFSET program_disp2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET program_disp3
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET program_goodbye
	call	WriteString

	exit	; exit to operating system
main ENDP

;--------------------------------------
getString MACRO
;
;--------------------------------------


ENDM

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
DisplayString PROC
;
;--------------------------------------


	ret
DisplayString ENDP

;--------------------------------------
ReadVal PROC
;
;--------------------------------------


	ret
ReadVal ENDP

;--------------------------------------
WriteVal PROC
;
;--------------------------------------



	ret
WriteVal ENDP

;--------------------------------------
Sum PROC
;
;--------------------------------------



	ret
Sum ENDP

END main
