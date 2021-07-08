DATAS SEGMENT
	BUFF db 10,0,10 dup(0) ;数据缓存区
	OUTREC db 10 dup(0) ;存放筛选后结果
	TURNS dw 0 ;记录字母个数
	FILE_NAME db 'output1.txt',00H ;文件名
	CREATE_ERR db 0DH,0AH,'ERROR:Fail to create file!','$' ;创建文件错误
	WRITE_ERR db 0DH,0AH,'ERROR:Fail to write file!','$' ;写文件错误
	SUCC DB 0DH,0AH,'SUCEED!','$'
	WHANDLE dw ? ;保存文件句柄
DATAS ENDS
CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS
START:
	MOV AX,DATAS
	MOV DS,AX
	LEA DX,BUFF
	MOV AH,0AH
	INT 21H ;调用DOS的OA指令读字符串到缓冲区中
	XOR BX,BX
	XOR SI,SI
	MOV CL,BUFF[BX+1]
	MOV CH,0 ;初始化索引BX,SI,将实际输入的字符数输入循环计数器CX
CLASSIFY:
	MOV AL,BUFF[BX+2];逐个读取缓冲区中实际字符串部分的字符
	CMP AL,41H
	JB NEXT
	CMP AL,5AH
	JBE SAVE
	CMP AL,61H
	JB NEXT
	CMP AL,7AH
	JBE SAVE
	JMP NEXT ;通过ASCII码判断读入的字符是否为字母
SAVE:
	MOV OUTREC[SI],AL ;存入是字母的字符到输出数组中
	INC SI ;字母区索引增加
	INC TURNS ;增加字母个数计数器
NEXT:
	INC BX ;缓冲区索引增加，读取字符串中下一个字符
	LOOP CLASSIFY ;遍历整个字符串
	LEA DX,FILE_NAME
	MOV AH,3CH
	MOV CX,1
	INT 21H
	JC ERROR_C ;调用DOS中断创建文件output1.txt，检查是否成功
	MOV WHANDLE,AX ;将文件代号保存
	MOV BX,WHANDLE
	LEA DX,OUTREC
	MOV CX,TURNS ;用CX记录输出数组中需要存入的字母数量
	MOV AH,40H
	INT 21H
	JC ERROR_W
	;调用DOS中断将输出区字母输到创建的文件中并检查是否成功
	MOV BX,WHANDLE
	MOV AH,3EH
	INT 21H
	JMP EXIT ;关闭文件并退出程序
	LEA DX,SUCC
	MOV AH,09H
	INT 21H ;错误处理：输出错误信息，转入结束程序
ERROR_C:
	LEA DX,CREATE_ERR
	MOV AH,09H
	INT 21H
	JMP EXIT
ERROR_W:
	LEA DX,WRITE_ERR
	MOV AH,09H
	INT 21H ;错误处理：输出错误信息，转入结束程序
EXIT:
	MOV AH,4CH
	INT 21H
	CODES ENDS
END START
