	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc
	include windows.inc
	include kernel32.inc
	include user32.inc

	GlobalAlloc PROTO :DWORD,:DWORD
	.code 

		
; =============== ��ʼ�� �� ========================
; ������snakeAddr :dword  �ߵĵ�ַ  
;����ֵ��eax:0 ��ʼ��ʧ�ܣ��ڴ����ʧ�ܣ� 1���ɹ�
	initialSnake proc,
		snakeAddr :dword
	
		mov edi,snakeAddr
		mov dword ptr [edi+8],2						;��ʼ��len
		;�������� ��ʼ���ڵ�λ�� (10,10) (9,10)
		invoke GlobalAlloc,GMEM_ZEROINIT,MAX_LENGTH*4
		cmp eax,0
		jz iniErro
		mov dword ptr [edi] ,eax						;��ʼ��px
		mov dword ptr [eax],10
		mov dword ptr [eax+4],9
		invoke GlobalAlloc,GMEM_ZEROINIT,MAX_LENGTH*4
		cmp eax,0
		jz iniErro
		mov dword ptr [edi+4],eax						;��ʼ��py
		mov dword ptr [eax],10
		mov dword ptr [eax+4],10

		mov dword ptr [edi+12],RIGHT				;��ʼ��direction

		mov dword ptr [edi+16],520					;��ʼ��srcHead
		mov dword ptr [edi+20],521					;��ʼ��srcBody
		jmp exit
	iniErro:
		xor eax,eax
		jmp exit
	exit:
		mov eax,1
		 
		ret
	initialSnake endp

	end