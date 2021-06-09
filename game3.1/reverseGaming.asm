	.386
	.model flat,stdcall
	option casemap:none
		
	include StructAndRule.inc

	.code 

	reverseSnake proc,
		snakeAddr:dword
		
		

		mov edi,snakeAddr
		
		mov esi,dword ptr [edi+0] ;px
		xor ebx,ebx
reverseX:
		mov edx,dword ptr [edi+8] ;len
		dec edx
		sub edx,ebx
		cmp ebx,edx
		jge finishX
		mov eax,dword ptr[esi+edx*4]
		xchg dword ptr[esi+ebx*4],eax
		mov dword ptr[esi+edx*4],eax
		inc ebx
		jmp reverseX
finishX:
		mov esi,dword ptr [edi+4] ;py
		xor ebx,ebx

reverseY:				
		mov edx,dword ptr [edi+8] ;len
		dec edx
		sub edx,ebx
		cmp ebx,edx
		jge finishY
		mov eax,dword ptr[esi+edx*4]
		xchg dword ptr[esi+ebx*4],eax
		mov dword ptr[esi+edx*4],eax
		inc ebx
		jmp reverseY
finishY:
		; ����0��1�жϷ���
		mov ebx,snakeAddr
		mov edi,dword ptr [ebx+0] ;px
		mov esi,dword ptr [ebx+4] ;py

		mov eax,dword ptr [edi]	  ; x0
		mov ecx,dword ptr [edi+4] ; x1
		cmp eax,ecx
		je XSame
		cmp eax,ecx
		jg XZeroBigger
		jmp XOneBigger
XSame:
		mov eax,dword ptr [esi]	  ; y0
		mov ecx,dword ptr [esi+4] ; y1
		cmp eax,ecx
		jg YZeroBigger
		jmp YOneBigger

		
XZeroBigger:	;����
		mov ebx,snakeAddr
		mov dword ptr[ebx+12],RIGHT
		mov dword ptr[ebx+16],offset headrightpath

		jmp exit
XOneBigger:		;����
		mov ebx,snakeAddr
		mov dword ptr[ebx+12],LEFT
		mov dword ptr[ebx+16],offset headleftpath
		jmp exit
YZeroBigger:	;����
		mov ebx,snakeAddr
		mov dword ptr[ebx+12],DOWN
		mov dword ptr[ebx+16],offset headdownpath
		jmp exit
YOneBigger:		;����
		mov ebx,snakeAddr
		mov dword ptr[ebx+12],UP
		mov dword ptr[ebx+16],offset headuppath
		jmp exit

exit:
		ret
	reverseSnake endp


	reverseGaming proc,
		snakeAddr:dword,
		eggsAddr:dword

		local longer:dword
		local eggIndex:dword

		mov longer,0
		mov eggIndex,0
		
playGame:
		invoke checkAllEgg,snakeAddr,eggsAddr
		cmp eax,-1
		je noEat
		cmp eax,0
		je rightEat
		jmp wrongEat
move:
		invoke moveSnake ,snakeAddr,longer
		mov dword ptr longer,0
		
judge:
		invoke isHeadMeetBody,snakeAddr
		cmp eax,1
		je selfKill
		invoke isMeetWall,snakeAddr
		cmp eax,1
		je selfKill
		jmp keepOn
wrongEat:
		mov eggIndex,eax
		invoke setEgg,eggsAddr,eggIndex,-1,-1,-1,0	;���õ���visible����Ϊ0
		jmp move
noEat:
		jmp move
rightEat:
		mov dword ptr longer,1 ; �Ե���ȷ�ĵ�����ӳ�
		invoke updateEggs,eggsAddr,snakeAddr
		invoke reverseSnake,snakeAddr
		jmp move
reset:
		cmp ebx,eggCount
		jge resetFinish
		;inc ebx
		jmp reset
resetFinish:
		jmp move

selfKill:
		xor eax,eax
		jmp exit
keepOn:
		mov eax,1
		jmp exit	
exit:
		ret
	reverseGaming endp

	end
