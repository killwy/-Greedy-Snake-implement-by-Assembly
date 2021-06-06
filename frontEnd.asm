        .386
        .model flat,stdcall
        option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;include文件定义
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
;数据段
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
szCaptionMain db       '挑食蛇',0      ;标题名称
hBitmap HBITMAP ?
OutMessage db "按键%c",0ah,0
msg db "repaint!",10,0
cnt db 0
pimg dd ?
bckpath db "C:\Users\zjx\Desktop\mybck.bmp",0
hInst dd ?

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;绘制界面
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
draw proc 
    local hdcMem:HDC
    local rect:RECT
    ;加载图片
    invoke LoadImage,NULL,addr bckpath,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_CREATEDIBSECTION or LR_DEFAULTSIZE 
    mov hbmp,eax                        ;保存位图句柄
    invoke CreateCompatibleDC,hdcc      ;创建一个与指定设备兼容的内存设备上下文环境
    mov hdcMem,eax                      ;返回内存设备上下文环境的句柄
    invoke SelectObject,hdcMem,hbmp     ;把一个对象(位图、画笔、画刷等)选入指定的设备描述表。新的对象代替同一类型的老对象。
    invoke GetClientRect,ebx,addr rect  ;获取客户端的矩形对象，保存在rect里
    invoke BitBlt,hdcc,x,y,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY    ;在内存中将某页面上的一幅位图经过一定的变换转移到另一个页面上
    ;每画一次图让它偏移10个像素单位，之后用来模拟蛇的移动
    ;mov eax,x       
    ;add eax,10
    ;mov x,eax
    ;mov eax,y
    ;add eax,10
    ;mov y,eax
    invoke DeleteDC,hdcMem              ;删除设备描述表
    invoke DeleteObject,hbmp            ;删除位图对象
    ret
draw endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;窗口过程
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
                       mov hdcc,eax  ;hdcc用来保存BeginPaint返回的hdc
                       call draw
                       invoke printf,addr msg   ;打印repaint
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
              local    @stWndClass:WNDCLASSEX                           ;定义局部变量窗口类
              local    @stMsg:MSG                                       ;定义局部变量消息

              invoke   GetModuleHandle,NULL                             ;返回主调进程(此进程)的可执行文件的基地址
              mov      hInstance,eax                                    ;得到的句柄存入hInstance
              invoke   RtlZeroMemory,addr @stWndClass,sizeof @stWndClass;用零填充窗口类
              ;invoke   LoadIcon,hInstance,IDI_ICON1
              ;mov      hIcon,eax
              
;*******************************************************************************************
;注册窗口类
;*******************************************************************************************
              invoke   LoadCursor,0,IDC_ARROW                           ;载入系统自带的光标 
              mov      @stWndClass.hCursor,eax                          ;光标句柄送入窗口对应光标字段
              ;push     hIcon                                            
              ;pop      @stWndClass.hIconSm                              ;图标句柄送入相应字段
              push     hInstance                
              pop      @stWndClass.hInstance                            ;实例的句柄送入相应字段
              mov      @stWndClass.cbSize,sizeof WNDCLASSEX             ;设置窗口类的大小
              mov      @stWndClass.style,CS_HREDRAW or CS_VREDRAW       ;设置窗口样式
              mov      @stWndClass.lpfnWndProc,offset _ProcWinMain      ;指定回调函数
              mov      @stWndClass.hbrBackground,COLOR_WINDOW+1         ;背景颜色
              mov      @stWndClass.lpszClassName,offset szClassName     ;设置窗口类名
              ;mov      @stWndClass.hIconSm,
              invoke   RegisterClassEx,addr @stWndClass                 ;注册窗口类
;*******************************************************************************************
;建立并显示窗口
;*******************************************************************************************
              invoke   CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,\ 
                       offset szCaptionMain,WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT\
                       ,BACK_WIDTH+100,BACK_HEIGHT+100,NULL,NULL,hInstance,NULL    ;创建window                         ;
              mov      hWinMain,eax                                      ;保存窗口的句柄
              invoke GetDC,eax                                           ;获取设备上下文
              mov  hWindowHdc,eax                                        ;保存设备上下文
              invoke   ShowWindow,hWinMain,SW_SHOWNORMAL                 ;显示窗口
              invoke   UpdateWindow,hWinMain                             ;更新窗口
;*******************************************************************************************
;消息循环
;*******************************************************************************************
              .while      TRUE
              invoke     PeekMessage, addr @stMsg, NULL, 0, 0, PM_REMOVE
              .if           eax
                .break     .if @stMsg.message == WM_QUIT
                invoke     TranslateMessage, addr @stMsg
                invoke     DispatchMessage, addr @stMsg
              .else                                                         ;<做其他工作>
                invoke Sleep,500                                            ;休眠0.5秒
                invoke InvalidateRect,hWinMain,NULL,FALSE                    ;擦除原图使之失效，并重发WM_PAINT
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
