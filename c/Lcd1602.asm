 	ORG 	000H
	LJMP 	INIT
	ORG 	0030H
	DB "P","e","c","h","i","n"," ","S","c","i","e","n","c","e" 	
	LCDE 	EQU 	P2.7
	RW 		EQU 	P2.5
	RS 		EQU 	P2.6
	GPIO_LCD EQU 	P0


INIT:
	ACALL 	LCD1602_Init ;初始化1602
MAIN:
	MOV 	R7,#081H	 ;设置写指针
	ACALL 	LCD_WriteCom
	MOV 	A,#00H		;要读取第一字母
	MOV 	DPTR,#0030H
	MOVC 	A,@A+DPTR	;读取“P”
	MOV 	R7,A 		;给函数传递一个数据
	ACALL	LCD_WriteData
	MOV 	A,#01H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#02H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#03H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#04H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#05H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#06H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#07H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#08H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#09H
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#00AH
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#0BH
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#0CH
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	MOV 	A,#0DH
	MOVC 	A,@A+DPTR
	MOV 	R7,A
	ACALL 	LCD_WriteData
	AJMP 	$			;原地跳转
;*********************;
; 1602初始化程序	  ；
;*********************;
LCD1602_Init: 	
	MOV 	R7,#038H	;传递给LCD_WriteCom函数的值放在R7
	ACALL 	LCD_WriteCom;设置显示模式
	MOV 	R7,#00CH 	;设置显示开，光标关闭。
	ACALL 	LCD_WriteCom
	MOV 	R7,#006H 	;设置地址指针写后加1，而且整屏不移动
	ACALL 	LCD_WriteCom
	MOV 	R7,#001H	;显示清屏
	ACALL 	LCD_WriteCom
	MOV 	R7,#081H	;设置起始指针
	ACALL 	LCD_WriteCom
	RET					;子函数返回
;*********************;
; 1602写命令程序	  ；
;*********************;
LCD_WriteCom:		  ;用R7接收传递一个8位数据
	CLR 	LCDE
	CLR 	RS
	CLR 	RW
	MOV 	GPIO_LCD,R7
	ACALL 	DELAY
	SETB 	LCDE
	ACALL 	DELAY
	CLR 	LCDE
	RET
;*********************;
; 1602写数据程序	  ；
;*********************;
LCD_WriteData:		  ;用R7接收传递一个8位数据
	CLR 	LCDE
	SETB 	RS
	CLR 	RW
	MOV 	GPIO_LCD,R7
	ACALL 	DELAY
	SETB 	LCDE
	ACALL 	DELAY
	CLR 	LCDE
	RET
;*************;
; 延时程序	  ；
;*************;
DELAY:
	MOV 	R6,#0FFH
	DJNZ 	R6,$
	RET

END
	