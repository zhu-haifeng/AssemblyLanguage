;-----------------------��ĳ������һ����
DRAW MACRO K
	PUSH CX
	PUSH DX
	MOV DX,END_Y
	MOV CX,END_X	;����
	INT 10H
	INC END_&K
	POP DX
	POP CX
ENDM
DATAS SEGMENT
    DATAS SEGMENT
    W DW 10             ;̨�׳���        
    H DW 6              ;̨�׸߶�
    TURNS DW 30         ;̨����      ����video�ж�    �ȴ�����һ���ַ�  д�����ж�
    START_X DW 20       ;��ʼXλ��    MOV AH,0          MOV AH,0        MOV AH,0CH
    START_Y DW 20       ;��ʼYλ��    MOV AL,4          INT 16          INT 10H
    END_X DW 0          ;����Xλ��    INT 10H
    END_Y DW 0          ;����Yλ��
DATAS ENDS

DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	MOV AX,START_X
	MOV END_X,AX
	MOV AX,START_Y
	MOV END_Y,AX
	
	MOV AH,0
	MOV AL,04		;ͼ����ɫ
	INT 10H
INPUT:
	XOR AL,AL
	MOV AH,0		;BIOS�����ж�1������һ���ַ�
	INT 16H
	MOV CX,W
	MOV AH,0CH
	MOV AL,1		;��ɫ
	
XDIRECTION:
	DRAW X
	LOOP XDIRECTION
	
	MOV CX,H
YDERECTION:
	DRAW Y
	LOOP YDERECTION
	
	DEC TURNS
	JNZ INPUT
	
	MOV AH,4CH
	INT 21H
	
CODES ENDS
    END START

