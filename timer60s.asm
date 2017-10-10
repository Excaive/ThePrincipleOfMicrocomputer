SHOW	MACRO	B	;show ASCII B
        MOV	AH,02H
	MOV	DL,B
	INT	21H
ENDM

STIME	MACRO		;show time xx:xx:xx
	MOV	SI,OFFSET TIME
	SHOW	0DH
	SHOW	[SI]
	SHOW	[SI+01H]
ENDM

ADD1S	MACRO		;+1s
	MOV	SI,OFFSET TIME
	INC	BYTE PTR[SI+01H]

	CMP	BYTE PTR[SI+01H],3AH
	JB	C1
	MOV	BYTE PTR[SI+01H],30H
	INC	BYTE PTR[SI]

	CMP	BYTE PTR[SI],36H
	JB	C1
	MOV	BYTE PTR[SI],30H
	MOV	BYTE PTR[SI+01H],30H

C1:	NOP
ENDM

DELAY	MACRO		;delay 1s
	MOV	AX,0002DH
	MOV	BX,07FFFH

D1:	DEC	BX
	JNZ	D1

	MOV	BX,07FFFH
	DEC	AX
	JNZ	D1
ENDM

DATA    SEGMENT
TIME    DB      30H,30H
DATA    ENDS

STACK   SEGMENT PARA STACK 'STACK'
STA     DB      20 DUP(?)
TOP     EQU     LENGTH STA
STACK   ENDS

CODE    SEGMENT 
        ASSUME  CS:CODE,DS:DATA,SS:STACK

START:  MOV     AX,DATA
        MOV     DS,AX
        MOV     AX,STACK
        MOV     SS,AX
        MOV     AX,TOP
        MOV     SP,AX

MLOOP:	STIME	
	DELAY
	ADD1S

	JMP	MLOOP

        MOV     AX,4C00H
        INT     21H

CODE    ENDS
END     START