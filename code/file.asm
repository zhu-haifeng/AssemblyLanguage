DATAS SEGMENT
	BUFF db 10,0,10 dup(0) ;���ݻ�����
	OUTREC db 10 dup(0) ;���ɸѡ����
	TURNS dw 0 ;��¼��ĸ����
	FILE_NAME db 'output1.txt',00H ;�ļ���
	CREATE_ERR db 0DH,0AH,'ERROR:Fail to create file!','$' ;�����ļ�����
	WRITE_ERR db 0DH,0AH,'ERROR:Fail to write file!','$' ;д�ļ�����
	SUCC DB 0DH,0AH,'SUCEED!','$'
	WHANDLE dw ? ;�����ļ����
DATAS ENDS
CODES SEGMENT
	ASSUME CS:CODES,DS:DATAS
START:
	MOV AX,DATAS
	MOV DS,AX
	LEA DX,BUFF
	MOV AH,0AH
	INT 21H ;����DOS��OAָ����ַ�������������
	XOR BX,BX
	XOR SI,SI
	MOV CL,BUFF[BX+1]
	MOV CH,0 ;��ʼ������BX,SI,��ʵ��������ַ�������ѭ��������CX
CLASSIFY:
	MOV AL,BUFF[BX+2];�����ȡ��������ʵ���ַ������ֵ��ַ�
	CMP AL,41H
	JB NEXT
	CMP AL,5AH
	JBE SAVE
	CMP AL,61H
	JB NEXT
	CMP AL,7AH
	JBE SAVE
	JMP NEXT ;ͨ��ASCII���ж϶�����ַ��Ƿ�Ϊ��ĸ
SAVE:
	MOV OUTREC[SI],AL ;��������ĸ���ַ������������
	INC SI ;��ĸ����������
	INC TURNS ;������ĸ����������
NEXT:
	INC BX ;�������������ӣ���ȡ�ַ�������һ���ַ�
	LOOP CLASSIFY ;���������ַ���
	LEA DX,FILE_NAME
	MOV AH,3CH
	MOV CX,1
	INT 21H
	JC ERROR_C ;����DOS�жϴ����ļ�output1.txt������Ƿ�ɹ�
	MOV WHANDLE,AX ;���ļ����ű���
	MOV BX,WHANDLE
	LEA DX,OUTREC
	MOV CX,TURNS ;��CX��¼�����������Ҫ�������ĸ����
	MOV AH,40H
	INT 21H
	JC ERROR_W
	;����DOS�жϽ��������ĸ�䵽�������ļ��в�����Ƿ�ɹ�
	MOV BX,WHANDLE
	MOV AH,3EH
	INT 21H
	JMP EXIT ;�ر��ļ����˳�����
	LEA DX,SUCC
	MOV AH,09H
	INT 21H ;���������������Ϣ��ת���������
ERROR_C:
	LEA DX,CREATE_ERR
	MOV AH,09H
	INT 21H
	JMP EXIT
ERROR_W:
	LEA DX,WRITE_ERR
	MOV AH,09H
	INT 21H ;���������������Ϣ��ת���������
EXIT:
	MOV AH,4CH
	INT 21H
	CODES ENDS
END START
