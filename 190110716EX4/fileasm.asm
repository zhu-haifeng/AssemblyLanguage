DATAS SEGMENT
	BUFF	DB 10,0,10 DUP(0) ;数据缓存区
	OUTREC 	DB 10 DUP(0) ;存放筛选后结果
	TURNS 	DW 0 ;记录字母个数
	FILE_NAME 	DB 'output1.txt',00H ;文件名
	CREATE_ERR 	DB 0DH,0AH,'ERROR:Fail to create file!','$' ;创建文件错误
	WRITE_ERR 	DB 0DH,0AH,'ERROR:Fail to write file!','$' ;写文件错误
	SUCCEED		DB 0DH,0AH,'SUCCEED!','$'
	WHANDLE DW ? ;文件代号
DATAS ENDS
CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS
START:
	MOV AX,DATAS
	MOV DS,AX
	LEA DX,BUFF
	MOV AH,0AH
	INT 21H		;入读字符串
	MOV BX,2
	XOR SI,SI	;初始化索引
	MOV CL,BUFF[1];字符数
	MOV CH,0 
;------------------------------------筛选字母
NEXT:
	MOV AL,BUFF[BX];扫描字符串字符
	CMP AL,'a'
	JB SKIP
	CMP AL,'z'
	JBE FOUNED	;小写字母
	CMP AL,'A'
	JB SKIP
	CMP AL,'Z'
	JBE FOUNED	;大写字母
	JMP SKIP 
FOUNED:
	MOV OUTREC[SI],AL ;存入是字母的字符到输出数组中
	INC SI 		
SKIP:
	INC BX 			;下一个字符
	LOOP NEXT
	
	MOV TURNS,SI	;计数
;------------------------------创建文件
	LEA DX,FILE_NAME
	MOV AH,3CH
	MOV CX,1
	INT 21H		
	
	JC ERR_C 	;创建失败
;-------------------------------写文件
	MOV WHANDLE,AX ;存文件代号
	MOV BX,WHANDLE
	MOV CX,TURNS 	;写入字节数
	LEA DX,OUTREC
	MOV AH,40H	
	INT 21H
	JC ERR_W
;-------------------------------关闭文件
	MOV BX,WHANDLE
	MOV AH,3EH	
	INT 21H
;-------------------------------操作完成
	LEA DX,SUCCEED
	MOV AH,09H
	INT 21H 
	JMP EXIT 
;--------------------------------创建报错
ERR_C:			
	LEA DX,CREATE_ERR
	MOV AH,09H
	INT 21H
	JMP EXIT
;-------------------------------写文件报错错
ERR_W:			
	LEA DX,WRITE_ERR
	MOV AH,09H
	INT 21H 
EXIT:
	MOV AH,4CH
	INT 21H
	CODES ENDS
END START

