	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc

	.code 


	
; ================== ������еĵ� ===========================================
; ������snakeAddr �ߵ�ַ	eggsAddr ���ṹ�����ַ		
; ȫ�ֱ�����eggCount
; ����ֵ��eax  -1���Ե��˴���ĵ�   �������Ե��ĵ��ı��
	checkAllEgg proc ,
		snakeAddr :dword,
		eggsAddr :dword
		
		local headX:dword
		local headY:dword
			
		mov edi,snakeAddr
		mov esi,eggsAddr


		mov eax, dword ptr[edi]
		mov headX,eax
		mov eax, dword ptr[edi+4]
		mov headY,eax

		xor ebx,ebx
searchEgg:
		cmp ebx,eggCount
		jge searchFinish
		shl ebx,4   ;4ȡ����EGG�ṹ�Ĵ�С

		cmp dword ptr[esi+ebx+12],1 ;�ж�visible == 1 ��
		jne noVisible

		mov eax,dword ptr[esi+ebx] 
		mov edx,dword ptr[esi+ebx+4]
		shr ebx,4
		inc ebx
		
		mov ecx,headX
		cmp eax,dword ptr [ecx]
		jne searchEgg
		mov ecx,headY
		cmp edx,dword ptr [ecx]
		jne searchEgg

		dec ebx
		mov eax,ebx  ;���سԵ��ĵ����
		jmp exit

noVisible:
		shr ebx,4
		inc ebx
		jmp searchEgg

searchFinish:
		mov eax,-1		;û�гԵ�
		jmp exit
exit:
		ret
	checkAllEgg endp

	end
