	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc
	include windows.inc
	include kernel32.inc
	include user32.inc

	GlobalAlloc PROTO :DWORD,:DWORD
	.data
	;headrightpath db ".\resrc\headright.bmp",0
	;headleftpath db ".\resrc\headleft.bmp",0
	;headuppath db ".\resrc\headup.bmp",0
	;headdownpath db ".\resrc\headdown.bmp",0
	;bodypath db ".\resrc\body.bmp",0
	;eggpath db ".\resrc\egg.bmp",0
	;bckpath db ".\resrc\mybck.bmp",0
	
	.code 

		
; =============== ��ʼ�� �� ========================
; ������snakeAddr :dword  �ߵĵ�ַ  
; ȫ�ֱ�����blockSize��MAX_LENGTH
;����ֵ��eax:0 ��ʼ��ʧ�ܣ��ڴ����ʧ�ܣ� 1���ɹ�
	initialSnake proc,
		snakeAddr :dword,
		x0 : dword,
		y0 : dword,
		x1 : dword,
		y1 : dword,
		headPathAddr : dword
	


		mov edi,snakeAddr
		mov dword ptr [edi+8],2						;��ʼ��len
		cmp dword ptr [edi],0
		jne notAllocPX
		;�������� ��ʼ���ڵ�λ�� (10,10) (9,10)
		invoke GlobalAlloc,GMEM_ZEROINIT,MAX_LENGTH*4
		mov ebx,eax
		cmp eax,0
		jz iniErro
		mov dword ptr [edi] ,eax						;��ʼ��px
notAllocPX:
		mov eax,dword ptr [edi]
		mov eax,x0
		mov ecx,blockSize
		mul ecx
		sub eax,xoffset
		mov dword ptr [ebx],eax							;x0
		mov eax,x1
		mov ecx,blockSize
		mul ecx
		sub eax,xoffset
		mov dword ptr [ebx+4],eax						;x1

		cmp dword ptr [edi+4],0
		jne notAllocPY
		invoke GlobalAlloc,GMEM_ZEROINIT,MAX_LENGTH*4
		mov ebx,eax
		cmp eax,0
		jz iniErro
		mov dword ptr [edi+4],eax						;��ʼ��py
notAllocPY:
		mov eax,dword ptr [edi+4]
		mov eax,y0
		mov ecx,blockSize
		mul ecx
		mov dword ptr [ebx],eax							 ;y0
		mov eax,y1
		mov ecx,blockSize
		mul ecx
		mov dword ptr [ebx+4],eax						; y1

		mov dword ptr [edi+12],RIGHT				;��ʼ��direction

		mov eax,headPathAddr
		mov dword ptr [edi+16],eax		;��ʼ��srcHead
		mov dword ptr [edi+20],offset bodypath					;��ʼ��srcBody
		jmp exit
	iniErro:
		xor eax,eax
		jmp exit
	exit:
		mov eax,1
		 
		ret
	initialSnake endp

	end