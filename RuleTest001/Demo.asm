	.386
	.model flat,stdcall
	option casemap:none

	includelib msvcrt.lib
	include msvcrt.inc
	;include DataStructure.inc
	include GameRule.inc

	.data
		
		szWrongEat byte '�Դ���',0ah,0
		szNoEat byte 'û�Ե�',0ah,0
		szRightEat byte '�Զ���',0ah,0
		szSelfKill byte '��ɱ��',0ah,0

	.code



	main proc
		
		local longer:dword

		mov dword ptr longer,0
		
		;invoke printf,offset szEggInfo,dword ptr index,dword ptr[edi+index*16],dword ptr[edi+index*16+4],dword ptr[edi+index*16+8],dword ptr[edi+index*16+12]
		invoke printf,offset szEggInfo,1,2,3,4,5

		invoke printEgg, 2
		invoke setEgg, 2,5,15,123,321
		invoke printEgg, 2
		invoke setEgg, 2,1245,1235,-1,31231
		invoke printEgg, 2
		
		;ģ��ʵ��
		;����0�ŵ�������Ϊ��20��10��
		invoke setEgg,0,20,10,999,666
		invoke printEgg,0
		;1�ŵ�������Ϊ��16��10��
		invoke setEgg,1,16,10,999,666
		invoke printEgg,1
		
		;��ʼ����ͷ����Ϊ��10��10��������Ϊ�ң�x������
		invoke initialSnake
		invoke printSnake
		mov ebx,100
		
playGame:
		push ebx
		invoke moveSnake ,longer
		invoke printSnake
		mov dword ptr longer,0
		invoke isHeadMeetBody
		cmp eax,1
		je selfKill
		invoke CheckAllEgg
		cmp eax,-1
		je wrongEat
		cmp eax,0
		je noEat
		cmp eax,1
		je rightEat
		jmp keepOn
wrongEat:
		invoke printf,offset szWrongEat
		jmp keepOn
noEat:
		invoke printf,offset szNoEat
		jmp keepOn
rightEat:
		invoke printf,offset szRightEat
		mov dword ptr longer,1 ; �Ե���ȷ�ĵ�����ӳ�
		jmp keepOn
keepOn: 
		pop ebx
		dec ebx
		cmp ebx,0
		jg playGame
		jmp exit
selfKill:
		invoke printf,offset szSelfKill
exit:

	ret 
	main endp



	end main