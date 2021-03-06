DATAS SEGMENT
    ;此处输入数据段代码 
    NUMBER DW 60,15,8,26,3,22,36,17,80,56
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
    SUB BX,BX	;存当前起始地址
    SUB DI,DI	;存当前最大数地址
    SUB SI,SI	;存变址
    LEA CX,COUNT;末地止
OUTNEXT:
	MOV SI,BX
	ADD SI,2
	MOV AX,NUMBER[BX]
	MOV DI,BX
INNEXT:	
	CMP NUMBER[SI],AX
	JA SKIP			;大于跳过
	MOV DI,SI
	MOV AX,NUMBER[SI]
SKIP:
	ADD SI,2
	CMP SI,CX
	JL INNEXT
	MOV DX,NUMBER[BX]
	MOV NUMBER[BI],DX
	MOV NUMBER[BX],AX
	ADD BX,2
	CMP BX,CX
	JL OUTNEXT
	

	

    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


