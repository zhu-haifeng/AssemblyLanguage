DATAS SEGMENT
	BUFF	DB 10,0,10 DUP(0) ;���ݻ�����
	OUTREC 	DB 10 DUP(0) ;���ɸѡ����
	TURNS 	DW 0 ;��¼��ĸ����
	FILE_NAME 	DB 'output1.txt',00H ;�ļ���
	CREATE_ERR 	DB 0DH,0AH,'ERROR:Fail to create file!','$' ;�����ļ�����
	WRITE_ERR 	DB 0DH,0AH,'ERROR:Fail to write file!','$' ;д�ļ�����
	SUCCEED		DB 0DH,0AH,'SUCCEED!','$'
	WHANDLE DW ? ;�ļ�����
DATAS ENDS
CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS
START:
	MOV AX,DATAS
	MOV DS,AX
	LEA DX,BUFF
	MOV AH,0AH
	INT 21H		;����ַ���
	MOV BX,2
	XOR SI,SI	;��ʼ������
	MOV CL,BUFF[1];�ַ���
	MOV CH,0 
;------------------------------------ɸѡ��ĸ
NEXT:
	MOV AL,BUFF[BX];ɨ���ַ����ַ�
	CMP AL,'a'
	JB SKIP
	CMP AL,'z'
	JBE FOUNED	;Сд��ĸ
	CMP AL,'A'
	JB SKIP
	CMP AL,'Z'
	JBE FOUNED	;��д��ĸ
	JMP SKIP 
FOUNED:
	MOV OUTREC[SI],AL ;��������ĸ���ַ������������
	INC SI 		
SKIP:
	INC BX 			;��һ���ַ�
	LOOP NEXT
	
	MOV TURNS,SI	;����
;------------------------------�����ļ�
	LEA DX,FILE_NAME
	MOV AH,3CH
	MOV CX,1
	INT 21H		
	
	JC ERR_C 	;����ʧ��
;-------------------------------д�ļ�
	MOV WHANDLE,AX ;���ļ�����
	MOV BX,WHANDLE
	MOV CX,TURNS 	;д���ֽ���
	LEA DX,OUTREC
	MOV AH,40H	
	INT 21H
	JC ERR_W
;-------------------------------�ر��ļ�
	MOV BX,WHANDLE
	MOV AH,3EH	
	INT 21H
;-------------------------------�������
	LEA DX,SUCCEED
	MOV AH,09H
	INT 21H 
	JMP EXIT 
;--------------------------------��������
ERR_C:			
	LEA DX,CREATE_ERR
	MOV AH,09H
	INT 21H
	JMP EXIT
;-------------------------------д�ļ������
ERR_W:			
	LEA DX,WRITE_ERR
	MOV AH,09H
	INT 21H 
EXIT:
	MOV AH,4CH
	INT 21H
	CODES ENDS
END START

