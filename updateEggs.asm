	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc

	.code 
	
; ============== ˢ�����е������� =====================
; ������ ����������飬�����µ���������꣬����Visible=1��srcColor����
; ������ eggsAddr ������ĵ�ַ   snakeAddr �ߵ�ַ
; ȫ�ֱ����� eggCount
; ����ֵ�� ��
	updateEggs proc,
		eggsAddr :dword,
		snakeAddr :dword

		invoke genRandPos,snakeAddr
		mov edi,eax
		xor ebx,ebx
reset:
		cmp ebx,eggCount
		jge resetFinish
		invoke setEgg,eggsAddr,ebx,dword ptr[edi+8*ebx],dword ptr[edi+8*ebx+4],-1,1
		inc ebx
		jmp reset
resetFinish:
		ret 
	updateEggs endp

	end