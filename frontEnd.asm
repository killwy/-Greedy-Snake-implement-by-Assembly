.386
.model flat,stdcall
option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;include�ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include       windows.inc
include       StructAndRule.inc
include       kernel32.inc
includelib    Msimg32.lib
include       gdi32.inc
includelib    gdi32.lib
include       gdiplus.inc
includelib    gdiplus.lib
include       user32.inc
includelib    user32.lib
include       kernel32.inc
includelib    kernel32.lib
include       msvcrt.inc
includelib msvcrt.lib
printf    PROTO C : dword,:vararg
IDI_ICON1 equ 101
BACK_HEIGHT EQU 500
BACK_WIDTH EQU 500
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data
GpInput       GdiplusStartupInput<1,0,0,0>
x    dd 0
y    dd 0
snake SNAKE <> 
eggs EGG eggCount dup(<>)

szMsg byte 'x=%d , y=%d ',0ah,0
.data?
hInstance     dd        ?
hWinMain      dd        ?
hToken        dd        ?
hWindowHdc    HDC       ?
hIcon         dd        ?
hbmp_bg       DD        ?
hbmp_head     dd        ?
hbmp_body     dd        ?
hdcc          dd        ?


.const
szClassName   db       'MyClass',0
szCaptionMain db       '��ʳ��',0      ;��������
OutMessage db "����%c",0ah,0
msg db "repaint!",10,0
headrightpath db ".\resrc\headright.bmp",0
	headleftpath db ".\resrc\headleft.bmp",0
	headuppath db ".\resrc\headup.bmp",0
	headdownpath db ".\resrc\headdown.bmp",0
	bodypath db ".\resrc\body.bmp",0
	egg1path db ".\resrc\egg1.bmp",0
	egg2path db ".\resrc\egg2.bmp",0
	egg3path db ".\resrc\egg3.bmp",0
	egg4path db ".\resrc\egg4.bmp",0
	egg5path db ".\resrc\egg5.bmp",0
	egg6path db ".\resrc\egg6.bmp",0
	egg7path db ".\resrc\egg7.bmp",0
	bckpath db ".\resrc\mybck.bmp",0


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ƽ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
drawsnk proc uses ebx ecx edx esi edi

    local hdcMem:HDC
    local rect:RECT
    local cnt:dword
    mov esi,0
    mov edi,0
    invoke LoadImage,NULL,snake.srcHead,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
    mov hbmp_head,eax                                                   ;����λͼ���
    invoke CreateCompatibleDC,hdcc                                      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
    mov hdcMem,eax
    invoke SelectObject,hdcMem,hbmp_head                                ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
    invoke GetClientRect,hWinMain,addr rect                             ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
    mov ebx,snake.px
    mov edx,snake.py
    invoke BitBlt,hdcc,dword ptr [ebx],dword ptr [edx],rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
    invoke DeleteDC,hdcMem
    invoke DeleteDC,hdcMem                                              ;ɾ���豸������
    invoke DeleteObject,hbmp_head
    mov esi,1
    .while esi<snake.len
        
        invoke LoadImage,NULL,snake.srcBody,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
        mov hbmp_head,eax                                                   ;����λͼ���
        invoke CreateCompatibleDC,hdcc                                      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
        mov hdcMem,eax
        invoke SelectObject,hdcMem,hbmp_head                                ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
        invoke GetClientRect,hWinMain,addr rect                             ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
        mov ebx,snake.px
        mov edx,snake.py
        invoke BitBlt,hdcc,dword ptr [ebx+4*esi],dword ptr [edx+4*esi],rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
        invoke DeleteDC,hdcMem
        invoke DeleteDC,hdcMem                                              ;ɾ���豸������
        invoke DeleteObject,hbmp_head
        inc esi
    .endw
    ret
drawsnk endp

drawegg proc uses ebx ecx edx esi edi

    local hdcMem:HDC
    local rect:RECT
    mov esi,0
    mov edi,0
    mov esi,0
    .while esi<eggCount*16
        mov eax,(EGG ptr eggs[esi]).visible
        .if eax==1
        invoke LoadImage,NULL,(EGG ptr eggs[esi]).srcColor,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
        mov hbmp_head,eax                                                   ;����λͼ���
        invoke CreateCompatibleDC,hdcc                                      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
        mov hdcMem,eax
        invoke SelectObject,hdcMem,hbmp_head                                ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
        invoke GetClientRect,hWinMain,addr rect                             ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
        invoke BitBlt,hdcc,(EGG ptr eggs[esi]).x,(EGG ptr eggs[esi]).y,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
        invoke DeleteDC,hdcMem
        invoke DeleteObject,hbmp_head
        .endif
        add esi,16
        .endw
    ret
drawegg endp

draw proc 
    local hdcMem:HDC
    local rect:RECT
    ;����ͼƬ
    invoke LoadImage,NULL,addr bckpath,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
    mov hbmp_bg,eax                                                     ;����λͼ���
    invoke CreateCompatibleDC,hdcc                                      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
    mov hdcMem,eax                                                      ;�����ڴ��豸�����Ļ����ľ��
    invoke SelectObject,hdcMem,hbmp_bg                                  ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
    invoke GetClientRect,hWinMain,addr rect                                  ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
    invoke BitBlt,hdcc,0,0,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
    
    ;invoke LoadImage,NULL,addr headrightpath,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
    ;mov hbmp_head,eax                                                   ;����λͼ���
    ;invoke CreateCompatibleDC,hdcc                                      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
    ;mov hdcMem,eax
    ;invoke SelectObject,hdcMem,hbmp_head                                ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
    ;invoke GetClientRect,hWinMain,addr rect                             ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
    ;invoke BitBlt,hdcc,x,y,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
    ;ÿ��һ��ͼ����ƫ��10�����ص�λ��֮������ģ���ߵ��ƶ�
    call drawsnk
    call drawegg
    ;mov eax,x       
    ;add eax,1
    ;mov x,eax
    ;mov eax,y
    ;add eax,10
    ;mov y,eax
    ;invoke DeleteDC,hdcMem              ;ɾ���豸������
    invoke DeleteObject,hbmp_bg            ;ɾ��λͼ����
    ;invoke DeleteObject,hbmp_head
    ret
draw endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ڹ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain  proc     uses ebx edi esi,hWnd,uMsg,wParam,lParam
        local    @gdip
        local    @hBrush
        local hdcMem:HDC
        local rect:RECT
        LOCAL strRect:RECT
		LOCAL paint:dword
		LOCAL hdcmem:dword
	    LOCAL ps:PAINTSTRUCT
		LOCAL hdc:dword
          mov eax,uMsg
;*******************************************************************************************
              .if eax == WM_KEYDOWN
                   mov ebx, wParam
                   mov snake.direction,ebx
                  
                   invoke printf,addr OutMessage, ebx
                   ;.if snake.direction

              .endif

;*******************************************************************************************
              .if  eax ==  WM_PAINT
                   mov     ebx,hWnd
                   invoke BeginPaint,ebx,addr ps
                  .if  ebx == hWinMain
                       mov hdcc,eax  ;hdcc��������BeginPaint���ص�hdc
                       call draw
                       invoke printf,addr msg   ;��ӡrepaint
                   .endif
                   invoke EndPaint,ebx,addr ps
;********************************************************************************************
            .elseif  eax ==  WM_CLOSE
                invoke  DestroyWindow,hWinMain
                invoke  PostQuitMessage,NULL
;*******************************************************************************************
            .else    
                invoke DefWindowProc,hWnd,uMsg,wParam,lParam
            ret
            .endif
;********************************************************************************************
              xor      eax,eax
              ;call draw
          ret

_ProcWinMain  endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain      proc
              local longer:dword
              local eggIndex:dword
              local    @stWndClass:WNDCLASSEX                           ;����ֲ�����������
              local    @stMsg:MSG                                       ;����ֲ�������Ϣ

              mov longer,0
              invoke initialSnake,addr snake                             ;���߽��г�ʼ��
              invoke genRandPos,addr snake
              mov edi,eax
              invoke setEgg,addr eggs,0,dword ptr [edi],dword ptr [edi+4],addr egg1path,1
              invoke setEgg,addr eggs,1,dword ptr [edi+8],dword ptr [edi+12],addr egg2path,1
              invoke setEgg,addr eggs,2,dword ptr [edi+16],dword ptr [edi+20],addr egg3path,1
              invoke setEgg,addr eggs,3,dword ptr [edi+24],dword ptr [edi+28],addr egg4path,1
              invoke setEgg,addr eggs,4,dword ptr [edi+32],dword ptr [edi+36],addr egg5path,1


              invoke   GetModuleHandle,NULL                             ;������������(�˽���)�Ŀ�ִ���ļ��Ļ���ַ
              mov      hInstance,eax                                    ;�õ��ľ������hInstance
              invoke   RtlZeroMemory,addr @stWndClass,sizeof @stWndClass;������䴰����
              invoke   LoadIcon,hInstance,IDI_ICON1
              mov      hIcon,eax
              
;*******************************************************************************************
;ע�ᴰ����
;*******************************************************************************************
              invoke   LoadCursor,0,IDC_ARROW                           ;����ϵͳ�Դ��Ĺ�� 
              mov      @stWndClass.hCursor,eax                          ;��������봰�ڶ�Ӧ����ֶ�
              push     hIcon                                            
              pop      @stWndClass.hIconSm                              ;ͼ����������Ӧ�ֶ�
              push     hInstance                
              pop      @stWndClass.hInstance                            ;ʵ���ľ��������Ӧ�ֶ�
              mov      @stWndClass.cbSize,sizeof WNDCLASSEX             ;���ô�����Ĵ�С
              mov      @stWndClass.style,CS_HREDRAW or CS_VREDRAW       ;���ô�����ʽ
              mov      @stWndClass.lpfnWndProc,offset _ProcWinMain      ;ָ���ص�����
              mov      @stWndClass.hbrBackground,COLOR_WINDOW+1         ;������ɫ
              mov      @stWndClass.lpszClassName,offset szClassName     ;���ô�������
              ;mov      @stWndClass.hIconSm,
              invoke   RegisterClassEx,addr @stWndClass                 ;ע�ᴰ����
;*******************************************************************************************
;��������ʾ����
;*******************************************************************************************
              invoke   CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,\ 
                       offset szCaptionMain,WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT\
                       ,BACK_WIDTH+20,BACK_HEIGHT+45,NULL,NULL,hInstance,NULL    ;����window                         ;
              mov      hWinMain,eax                                      ;���洰�ڵľ��
              invoke GetDC,eax                                           ;��ȡ�豸������
              mov  hWindowHdc,eax                                        ;�����豸������
              invoke   ShowWindow,hWinMain,SW_SHOWNORMAL                 ;��ʾ����
              invoke   UpdateWindow,hWinMain                             ;���´���
;*******************************************************************************************
;��Ϣѭ��
;*******************************************************************************************
              ;local snake:SNAKE
              
              
              .while      TRUE
              invoke     PeekMessage, addr @stMsg, NULL, 0, 0, PM_REMOVE
              .if           eax
                .break     .if @stMsg.message == WM_QUIT
                invoke     TranslateMessage, addr @stMsg
                invoke     DispatchMessage, addr @stMsg
              .else                                                          ;<����������>
                invoke Sleep,200                                              ;����0.05��
                ;�ж�
playGame:
		push ebx
		invoke checkAllEgg,addr snake,addr eggs
		cmp eax,-1
		je noEat
		cmp eax,0
		je rightEat
		jmp wrongEat
move:
		invoke moveSnake ,addr snake,longer
		mov dword ptr longer,0
		invoke isHeadMeetBody,addr snake
		cmp eax,1
		je selfKill
		invoke isMeetWall,addr snake
		cmp eax,1
		je selfKill
		jmp keepOn
wrongEat:
		mov eggIndex,eax
		invoke setEgg,addr eggs,eggIndex,-1,-1,-1,0	;���õ���visible����Ϊ0
		jmp move
noEat:
		jmp move
rightEat:
		mov dword ptr longer,1 ; �Ե���ȷ�ĵ�����ӳ�
		invoke updateEggs,addr eggs,addr snake
		jmp move
reset:
		cmp ebx,eggCount
		jge resetFinish
		;inc ebx
		jmp reset
resetFinish:
		jmp move

selfKill:
		
keepOn:



                invoke InvalidateRect,hWinMain,NULL,FALSE                    ;����ԭͼʹ֮ʧЧ�����ط�WM_PAINT
                ;invoke UpdateWindow,hWinMain
                ;invoke PostMessage,hWinMain,WM_PAINT,0,0
              .endif
              .endw
              ret
_WinMain      endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
          invoke   GdiplusStartup,offset hToken,offset GpInput,NULL
          call     _WinMain
          invoke   GdiplusShutdown,hToken
          invoke   ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end      start