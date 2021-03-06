DATAS SEGMENT
    ;此处输入数据段代码 
    NUMBER DW 24,13,-5,-7,-101,28,46,77,100,3
    RESULT DW ?
    COUNT DW 10
    TEN DB 10 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    dw 100 dup(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV AX,STACKS
    MOV SS,AX
    MOV CX,COUNT
    SUB BX,BX
    SUB DX,DX		;存最大数
NEXT:
	MOV AX,NUMBER[BX]
	TEST AX,AX
	JS	SKIP		;负数
	TEST AX,0001H
	JZ SKIP			;奇数直接跳过
	CMP AX,DX
	JS SKIP			;不大于跳过
	MOV DX,AX
SKIP:
	ADD BX,2
	LOOP NEXT;
	
	MOV RESULT,DX
	MOV AX,RESULT
	SUB CX,CX
	
CLASSIFY:
	DIV TEN
	ADD AH,30H;
	PUSH AX			;ASCII码压栈
	MOV AH,0
	INC CH
	AND AL,AL
	JNZ CLASSIFY

	
DISPLAY:
	MOV CL,8
	POP DX
	SHR DX,CL
	MOV AH,02H
	INT 21H
	DEC CH
	;AND CH,CH
	JNZ DISPLAY
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

