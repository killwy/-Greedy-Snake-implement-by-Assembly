.386
.model flat,stdcall
option casemap:none

	include DataStructure.inc
	scanf PROTO C :ptr sbyte ,:vararg
	printf PROTO C :dword ,:vararg

.data

	szEggInfo byte "egg[%d]:x=[%d],y=[%d],srcColor=[%d],visible=[%d]",0ah,0
	szSnakeInfo byte "snake:  direction=%d,len=%d",0ah,0
	szNodeInfo byte "x[%d]=%d , y[%d]=%d ",0ah,0
	szEnter byte " ",0ah,0
	
	eggCount equ 5					;��������
	snake SNAKE<>					;��
	eggs EGG eggCount dup(<>)		;egg����

	array1 dword MAX_LENGTH dup(0)	;����һ���ڴ棬snake.px ָ��õ�ַ
	array2 dword MAX_LENGTH dup(0)	;����һ���ڴ棬snake.py ָ��õ�ַ


	.code

	
	; =============== ��ʼ�� �� ========================
; ������  ȫ�ֱ�����snake,array1��array2
;����ֵ����
	initialSnake proc 
	
		;��ʼ����
		mov dword ptr snake.len,2
		;��ʼ�ڵ�λ��
		mov dword ptr [array1],10
		mov dword ptr [array2],10
		mov dword ptr [array1+4],9
		mov dword ptr [array2+4],10
		lea eax,array1
		mov snake.px ,eax
		lea eax,array2
		mov snake.py,eax
		;��ʼ����
		mov dword ptr snake.direction,3
	ret
	initialSnake endp

; ================ ��ӡ ��  �����Ϣ��������̨��========================
;������index:dword �����±�   ȫ�ֱ�����eggs
;����ֵ����
	printEgg proc ,
		index :dword
		
		local destEgg:EGG
		push edi
		push ebx
		push eax
		mov edi,index
		shl edi,4
		mov eax,dword ptr[eggs+edi]
		mov dword ptr destEgg.x,eax
		mov eax,dword ptr[eggs+edi+4]
		mov dword ptr destEgg.y,eax
		mov eax,dword ptr[eggs+edi+8]
		mov dword ptr destEgg.srcColor,eax
		mov eax,dword ptr[eggs+edi+12]
		mov dword ptr destEgg.visible,eax
		pop eax
		pop ebx
		pop edi
		invoke printf,offset szEggInfo,index,destEgg.x,destEgg.y,destEgg.srcColor,destEgg.visible
		ret 
	printEgg endp

; ====================== ���õ����� ===========================================
; ������5��dword �� index   ,    newX  ,    newY  , newColor  , newVisible
;				 �������±꣬�µ�X���꣬�µ�Y���꣬�µ���ɫ  ���Ƿ���ʾ
; ��Ϊ-1����ʾ�����Բ���		ȫ�ֱ�����eggs��eggCount
;����ֵ����
	setEgg proc ,
		 index :dword,newX :dword,newY :dword,newColor :dword,newVisible :dword
		
		mov edi,index
		cmp edi,dword ptr eggCount
		jge tag4
		cmp edi,0
		jl tag4
		shl edi,4   ;4ȡ����EGG�ṹ�Ĵ�С

		mov eax,dword ptr newX
		cmp eax,-1
		je tag1
		mov dword ptr[eggs+edi],eax
tag1:		
		mov eax,dword ptr newY
		cmp eax,-1
		je tag2
		mov dword ptr[eggs+edi+4],eax
tag2:
		mov eax,dword ptr newColor
		cmp eax,-1
		je tag3
		mov dword ptr[eggs+edi+8],eax
tag3:
		mov eax,dword ptr newVisible
		cmp eax,-1
		je tag4
		mov dword ptr[eggs+edi+12],eax
tag4:

		ret
	setEgg endp

; =================== ��ӡ �� �����Ϣ��������̨��===========================
; ȫ�ֱ���  snake
	printSnake proc 
		
		invoke printf,offset szEnter
		invoke printf,offset szSnakeInfo,snake.direction,snake.len
		xor ebx,ebx
		mov esi,dword ptr [snake.px] 
		mov edi,dword ptr [snake.py]	
keepOn:
		
		mov eax,dword ptr [esi+4*ebx]
		
		mov edx,dword ptr [edi+4*ebx]
		invoke printf,offset szNodeInfo,ebx,eax,ebx,edx
		inc ebx
		cmp ebx,dword ptr snake.len
		jl keepOn
		
	ret
	 printSnake endp					

; ================== �ж����Ƿ��������Լ������� =============================
;��������   ����ֵ��eax 0��û������  eax 1: ������	 ȫ�ֱ�����snake
		isHeadMeetBody proc 
		
		local headX:dword
		local headY:dword

		mov edi,dword ptr [snake.px]
		mov esi,dword ptr [snake.py]

		mov eax,dword ptr [edi]
		mov dword ptr headX,eax
		mov eax,dword ptr [esi]
		mov dword ptr headY,eax
		mov ecx,dword ptr snake.len
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

; ==================  ���ƶ�  ===============================================
; ��������   longer:dword �����Ƿ�Ҫ���� 1���� 0����	ȫ�ֱ�����snake
; ����ֵ�� ��
	moveSnake proc ,
		longer : dword
		

		cmp dword ptr snake.len,1
		jle updateHead		
		cmp dword ptr longer,0 
		je noLonger
		inc snake.len
noLonger:
		mov ebx,snake.len
		mov edi,snake.px 
		mov esi,snake.py   
updateBody:
		dec ebx
		mov eax,dword ptr [edi+4*ebx-4]
		mov ecx,dword ptr [esi+4*ebx-4]
		mov dword ptr[edi+4*ebx],eax
		mov dword ptr[esi+4*ebx],ecx
		cmp ebx,1
		jg updateBody
updateHead:
		mov edx,dword ptr snake.direction
		cmp edx,0
		je Up
		cmp edx,1
		je Down
		cmp edx,2
		je Left
		cmp edx,3
		je Right
		jmp errDirection
Up:
		mov ebx,snake.py
		dec dword ptr [ebx]
		jmp exit
Down:	
		mov ebx,snake.py
		inc dword ptr[ebx]
		jmp exit
Left:
		mov ebx,snake.px
		dec dword ptr[ebx]
		jmp exit
Right:
		mov ebx,snake.px
		inc dword ptr [ebx]
		jmp exit
errDirection:
		jmp exit

exit:  

	ret
	moveSnake endp

; ================== ������еĵ� ===========================================
; ��������			ȫ�ֱ�����snack��eggs��eggCount
; ����ֵ��eax  1:�Ե�����ȷ�ĵ�   0��û�гԵ���   -1���Ե��˴���ĵ�
	CheckAllEgg proc 
		
		
		local headX:dword
		local headY:dword
	
		mov edi, snake.px
		mov eax, dword ptr[edi]
		mov headX,eax
		mov edi, snake.py
		mov eax, dword ptr[edi]
		mov headY,eax
		

		xor ebx,ebx
searchEgg:
		cmp ebx,eggCount
		jge searchFinish
		shl ebx,4   ;4ȡ����EGG�ṹ�Ĵ�С
		mov eax,dword ptr[eggs+ebx] 
		mov edx,dword ptr[eggs+ebx+4]
		inc ebx

		cmp eax,dword ptr headX
		jne searchEgg
		cmp edx,dword ptr headY
		jne searchEgg

		dec ebx
		cmp ebx,0
		je rightOne
		mov eax,-1		;�Ե��˴���ĵ�	
		jmp exit

rightOne:
		mov eax,1		;�Ե�����ȷ�ĵ�
		jmp exit	

searchFinish:
		mov eax,0		;û�гԵ�
		jmp exit
exit:
		ret
	CheckAllEgg endp

