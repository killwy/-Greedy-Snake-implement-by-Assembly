	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc

	.code 

	
; ================== �ж����Ƿ��������Լ������� =============================
;������snakeAddr :dword �ߵĵ�ַ  
;����ֵ��eax 0��û������  eax 1: ������	
	isHeadMeetBody proc,
		snakeAddr :dword
		
		local headX:dword
		local headY:dword

		mov ebx,snakeAddr

		mov edi,dword ptr [ebx]	  ; px
		mov esi,dword ptr [ebx+4] ; py

		mov eax,dword ptr [edi]
		mov dword ptr headX,eax
		mov eax,dword ptr [esi]
		mov dword ptr headY,eax
		mov ecx,dword ptr [ebx+8] ; len
		dec ecx
		xor ebx,ebx
		xor eax,eax
check:	
		inc ebx
		mov eax,dword ptr [edi+4*ebx]
		mov ecx,dword ptr [esi+4*ebx]
		cmp eax,dword ptr headX
		jne isLoop
		cmp ecx,dword ptr headY
		jne isLoop
		jmp haveMeet
isLoop:	
		cmp ebx,ecx
		jl check

		mov eax,0	;û������
		jmp exit
haveMeet:
		mov eax,1   ;������
		jmp exit

exit:
	ret
	isHeadMeetBody endp

	end