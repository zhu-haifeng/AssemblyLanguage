;-----------------------往某个方向画一个点
DRAW MACRO K
	PUSH CX
	PUSH DX
	MOV DX,END_Y
	MOV CX,END_X	;行列
	INT 10H
	INC END_&K
	POP DX
	POP CX
ENDM
DATAS SEGMENT
    DATAS SEGMENT
    W DW 10             ;台阶长度        
    H DW 6              ;台阶高度
    TURNS DW 30         ;台阶数      调用video中断    等待接收一个字符  写像素中断
    START_X DW 20       ;起始X位置    MOV AH,0          MOV AH,0        MOV AH,0CH
    START_Y DW 20       ;起始Y位置    MOV AL,4          INT 16          INT 10H
    END_X DW 0          ;结束X位置    INT 10H
    END_Y DW 0          ;结束Y位置
DATAS ENDS

DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
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
	MOV AL,04		;图形四色
	INT 10H
INPUT:
	XOR AL,AL
	MOV AH,0		;BIOS键盘中断1，读入一个字符
	INT 16H
	MOV CX,W
	MOV AH,0CH
	MOV AL,1		;颜色
	
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

