        .386
        .model flat,stdcall
        option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;include�ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include       windows.inc

includelib    Msimg32.lib
include       gdi32.inc
includelib    gdi32.lib
include       gdiplus.inc
includelib    gdiplus.lib
include       user32.inc
includelib    user32.lib
include       kernel32.inc
includelib    kernel32.lib
include  msvcrt.inc
includelib msvcrt.lib
printf    PROTO C : dword,:vararg
IDI_ICON1 equ 101
BACK_HEIGHT EQU 720
BACK_WIDTH EQU 1280
IDB_BITMAP1 equ 104

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .data
GpInput       GdiplusStartupInput<1,0,0,0>
x    dd 0
y    dd 0
                .data?
hInstance     dd       ?
hWinMain      dd       ?
hToken        dd       ?
hWindowHdc HDC ?
hIcon         dd       ?
;hDcBack       dd       ?
hbmp      DD       ?
hdcc          dd        ?
                .const
szClassName   db       'MyClass',0
szCaptionMain db       '��ʳ��',0      ;��������
hBitmap HBITMAP ?
OutMessage db "����%c",0ah,0
msg db "repaint!",10,0
cnt db 0
pimg dd ?
bckpath db "C:\Users\zjx\Desktop\mybck.bmp",0
hInst dd ?

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ƽ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
draw proc 
    local hdcMem:HDC
    local rect:RECT
    ;����ͼƬ
    invoke LoadImage,NULL,addr bckpath,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
    mov hbmp,eax                        ;����λͼ���
    invoke CreateCompatibleDC,hdcc      ;����һ����ָ���豸���ݵ��ڴ��豸�����Ļ���
    mov hdcMem,eax                      ;�����ڴ��豸�����Ļ����ľ��
    invoke SelectObject,hdcMem,hbmp     ;��һ������(λͼ�����ʡ���ˢ��)ѡ��ָ�����豸�������µĶ������ͬһ���͵��϶���
    invoke GetClientRect,ebx,addr rect  ;��ȡ�ͻ��˵ľ��ζ��󣬱�����rect��
    invoke BitBlt,hdcc,x,y,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;���ڴ��н�ĳҳ���ϵ�һ��λͼ����һ���ı任ת�Ƶ���һ��ҳ����
    ;ÿ��һ��ͼ����ƫ��10�����ص�λ��֮������ģ���ߵ��ƶ�
    mov eax,x       
    add eax,10
    mov x,eax
    mov eax,y
    add eax,10
    mov y,eax
    invoke DeleteDC,hdcMem              ;ɾ���豸������
    invoke DeleteObject,hbmp            ;ɾ��λͼ����
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
		LOCAL hbitmap:dword
        LOCAL strRect:RECT
		LOCAL paint:dword
		LOCAL hdcmem:dword
	    LOCAL ps:PAINTSTRUCT
		LOCAL hdc:dword
          mov eax,uMsg
;*******************************************************************************************
              .if eax == WM_KEYDOWN
                   mov ebx, wParam
                   invoke printf,addr OutMessage, ebx
             
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
              local    @stWndClass:WNDCLASSEX                           ;����ֲ�����������
              local    @stMsg:MSG                                       ;����ֲ�������Ϣ

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
                       ,BACK_WIDTH+100,BACK_HEIGHT+100,NULL,NULL,hInstance,NULL    ;����window                         ;
              mov      hWinMain,eax                                      ;���洰�ڵľ��
              invoke GetDC,eax                                           ;��ȡ�豸������
              mov  hWindowHdc,eax                                        ;�����豸������
              invoke   ShowWindow,hWinMain,SW_SHOWNORMAL                 ;��ʾ����
              invoke   UpdateWindow,hWinMain                             ;���´���
;*******************************************************************************************
;��Ϣѭ��
;*******************************************************************************************
              .while      TRUE
              invoke     PeekMessage, addr @stMsg, NULL, 0, 0, PM_REMOVE
              .if           eax
                .break     .if @stMsg.message == WM_QUIT
                invoke     TranslateMessage, addr @stMsg
                invoke     DispatchMessage, addr @stMsg
              .else                                                         ;<����������>
                invoke Sleep,500                                            ;����0.5��
                invoke InvalidateRect,hWinMain,NULL,TRUE                    ;����ԭͼʹ֮ʧЧ�����ط�WM_PAINT
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