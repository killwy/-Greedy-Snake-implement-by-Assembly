

.386
.model flat,stdcall
option casemap:none

;externdef blockRow:ABS,blockCol:ABS,blockSize:ABS,MAX_LENGTH:ABS

; ================== �� �����ݽṹ =====================
	SNAKE STRUCT
		px dword ?					;X������׵�ַ
		py dword ?					;Y������׵�ַ
		srcHead dword ?				;���ͷ��ͼƬ�ĵ�ַ
		srcBody dword ?				;�������ͼƬ�ĵ�ַ
		len dword ? 				;����
		direction dword ?			;���� 0:��  1����  2����   3����
	SNAKE ENDS
; =================== �� �����ݽṹ ====================
	EGG STRUCT
		x dword ?					;x����
		y dword ?					;y����
		srcColor dword ?			;��egg��ͼƬ��ַ
		visible dword ?				;���Ƿ�ɼ�
	EGG ENDS


	

	.data 
	
	; =================  �������  ========================
	blockRow equ 20					;���ӵ�����
	blockCol equ 20					;���ӵ�����
	blockSize equ 10				;���ӵĴ�С���߳���

	MAX_LENGTH equ 120				;�ߵ���󳤶�
	

	.code
