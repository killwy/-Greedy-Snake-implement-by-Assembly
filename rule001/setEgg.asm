

	.386
	.model flat,stdcall
	option casemap:none
	include StructAndRule.inc

	.code 


; ====================== ���õ����� ===========================================
; ������5��dword ��eggsAddr index   ,    newX  ,    newY  , newColor  , newVisible
;				 �������ַ �������±꣬�µ�X���꣬�µ�Y���꣬�µ���ɫ  ���Ƿ���ʾ
; ��Ϊ-1����ʾ�����Բ���		ȫ�ֱ�����eggCount
;����ֵ����
	setEgg proc ,
		 eggsAddr :dword,index :dword,newX :dword,newY :dword,newColor :dword,newVisible :dword
		pushad
		
		mov esi,eggsAddr

		mov edi,index
		cmp edi,dword ptr eggCount
		jge errIndex
		cmp edi,0
		jl errIndex
		shl edi,4   ;4ȡ����EGG�ṹ�Ĵ�С

		mov eax,dword ptr newX
		cmp eax,-1
		je tag1
		mov dword ptr[esi+edi],eax
tag1:		
		mov eax,dword ptr newY
		cmp eax,-1
		je tag2
		mov dword ptr[esi+edi+4],eax
tag2:
		mov eax,dword ptr newColor
		cmp eax,-1
		je tag3
		mov dword ptr[esi+edi+8],eax
tag3:
		mov eax,dword ptr newVisible
		cmp eax,-1
		je exit
		mov dword ptr[esi+edi+12],eax
errIndex:

exit:
		popad
		ret
	setEgg endp


	end
