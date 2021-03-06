	ORG 	00H
	LJMP	INIT
	ORG 	30H
	DB		03FH,006H,05BH,04FH,066H,06DH,07DH,007H,07FH,06FH,077H,07CH,039H,05EH,079H,071H
	;0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
	DAT0 	EQU 	30H;要显示的八位数
	DAT1 	EQU 	31H
	DAT2 	EQU 	32H
	DAT3 	EQU 	33H
	DAT4 	EQU 	34H
	DAT5 	EQU 	35H
	DAT6 	EQU 	36H
	DAT7 	EQU 	37H 
	LSA 	EQU	 	P2.2
	LSB 	EQU 	P2.3
	LSC 	EQU 	P2.4
	GPIO_DIG EQU	P0
;*************;
; 	主程序	  ；
;*************;
INIT:
	MOV 	DAT0,#03FH
	MOV		DAT1,#006H
	MOV 	DAT2,#05BH
	MOV 	DAT3,#04FH
	MOV 	DAT4,#066H
	MOV 	DAT5,#06DH
	MOV 	DAT6,#07DH
	MOV 	DAT7,#007H
MAIN:
	CLR 	LSA			; 显示第一位
	CLR 	LSB
	CLR		LSC	
	MOV 	GPIO_DIG,DAT0
	ACALL 	DELAY			;显示持续时间
	MOV 	GPIO_DIG,#000H	;消隐
	SETB 	LSA			; 显示第二位
	CLR 	LSB
	CLR		LSC
	MOV 	GPIO_DIG,DAT1
	ACALL 	DELAY		;显示持续时间
	MOV 	GPIO_DIG,#000H
	CLR 	LSA			;显示第三位
	SETB 	LSB
	CLR		LSC	
	MOV 	GPIO_DIG,DAT2
	ACALL 	DELAY		;显示持续时间
	MOV 	GPIO_DIG,#00H
	SETB 	LSA			;显示第四位
	SETB 	LSB
	CLR		LSC
	MOV 	GPIO_DIG,DAT3
	ACALL 	DELAY		;显示持续时间
	MOV 	GPIO_DIG,#00H	
	CLR 	LSA			;显示第五位
	CLR 	LSB
	SETB	LSC
	MOV 	GPIO_DIG,DAT4
	ACALL 	DELAY		;显示持续时间
 	MOV 	GPIO_DIG,#00H
	SETB 	LSA			;显示第六位
	CLR 	LSB
	SETB	LSC	
	MOV 	GPIO_DIG,DAT5
	ACALL 	DELAY 		;显示持续时间
	MOV 	GPIO_DIG,#00H
	CLR 	LSA			;显示第七位
	SETB 	LSB
	SETB	LSC	
	MOV 	GPIO_DIG,DAT6
	ACALL 	DELAY 		;显示持续时间
	MOV 	GPIO_DIG,#00H
	SETB 	LSA			;显示第七位
	SETB 	LSB
	SETB	LSC	
	MOV 	GPIO_DIG,DAT7
	ACALL 	DELAY 		;显示持续时间
	MOV 	GPIO_DIG,#00H
	LJMP 	MAIN
	 	
;*************;
; 延时程序	  ；
;*************;
DELAY:
	MOV 	R7,#0FFH
	DJNZ 	R7,$
	RET

	END
		
