;-------------------------------------------����һ������INPUT
INPUTNUM MACRO
	LEA DX,BUFF
	MOV AH,0AH
	INT 21H
	XOR BX,BX
	XOR CX,CX
	XOR DX,DX
	MOV CL,CNT
ADDTOSUM:
	SHL DX,1	;ԭ��*2
	MOV AX,DX	;AX=ԭ��*2
	SHL DX,1	
	SHL DX,1	;DX=ԭ��*8
	ADD DX,AX	;DX=ԭ��*10
	XOR AX,AX
	MOV AL,NUMSTR[BX]
	SUB AL,30H
	ADD DX,AX
	INC BX
	LOOP ADDTOSUM
	MOV INPUT,DL

	
ENDM
;-------------------------------------------���лس�
CALF MACRO
	PUSH DX
	MOV DL,0AH
	MOV AH,2
	INT 21H
	MOV DL,13
	MOV AH,2
	INT 21H;
	POP DX
ENDM
;-----------------------------------------------
DATAS SEGMENT
    FIB DW 22 DUP(?)
  	I DB ?
    K DW 10
    INPUT DB ? ;
    BUFF DB 5;
    CNT DB ?;
    NUMSTR DB 5 DUP(?)
DATAS ENDS

STACKS SEGMENT
	DW 20 DUP(?)
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    XOR BX,BX;		;��0��ʼ����
    MOV CX,20;
    CALL CALCULATE;
    
    ;�˴��������δ���
    XOR BX,BX
    MOV CX,22
    MOV K,10
;AGAIN:
;	PUSH CX
 ;   CALL TRANSTOK
  ;  CALF
;
 ;   ADD BX,2
  ;  POP CX
   ; LOOP AGAIN
    
    INPUTNUM
    
    ;
    CALF
    CALF
    XOR BX,BX
    MOV BL,INPUT
    SHL BX,1
    CALL TRANSTOK
    
    MOV AH,4CH
    INT 21H
;----------------------------------------------����20��������
CALCULATE PROC
NEXT:
	ADD BX,2
	CMP BX,2
	JZ ONE
	CMP BX,4
	JZ ONE
	JMP OTHER
	
ONE:
	MOV FIB[BX],1
	LOOP NEXT
OTHER:
	MOV AX,FIB[BX-4]
	ADD AX,FIB[BX-2]
	MOV FIB[BX],AX
	LOOP NEXT
	RET
CALCULATE ENDP
;-----------------------------------------------ת��k���������
TRANSTOK PROC
	MOV AX,FIB[BX]
	XOR CX,CX
CLASSIFY:
	XOR DX,DX	;����
	DIV K
	ADD DX,30H
	CMP DX,3AH
	JL	PUS
	ADD DX,7H
PUS:
	PUSH DX
	INC CH
	
	CMP AX,0
	JNZ CLASSIFY
DISPLAY:
	
	POP DX
	MOV AH,02H
	INT 21H
	DEC CH
	JNZ DISPLAY
	
	RET
TRANSTOK ENDP
CODES ENDS
    END START



