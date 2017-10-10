;*******************************************************
;		简易电子琴实验说明
;实验目的：	1.掌握蜂鸣器的使用
;		2.掌握蜂鸣器的不同发音的方法
;实验内容：	1.通过单片机，令1-7号键由低到高发出1-7的音阶

K1		BIT	P1.0			;按键1
K2		BIT	P1.1			;按键2
K3		BIT	P1.2			;按键3
K4		BIT	P1.3			;按键4
K5		BIT	P1.4			;按键5
K6		BIT	P1.7			;按键6
K7		BIT	P1.6			;按键7
Buzzer		BIT	P1.5			;蜂鸣器
M1		EQU	17
M2		EQU	16
M3		EQU	15
M4		EQU	14
M5		EQU	13
M6		EQU	12
M7		EQU	11

		ORG	0000H
		LJMP	START

		ORG	0100H
START:		MOV	SP,#60H
MAIN:		MOV	P1,#0FFH		;P1口初始化
		LCALL	Demo			;播放一段演示音乐
MAIN_1:		JB	K1,MAIN_2		;判断1号键是否按下，否则检测2号键
		LCALL	Sound1			;发音子程序
MAIN_2:		JB	K2,MAIN_3		;判断2号键是否按下，否则检测3号键
		LCALL	Sound2			;发音子程序
MAIN_3:		JB	K3,MAIN_4		;判断2号键是否按下，否则检测4号键
		LCALL	Sound3			;发音子程序
MAIN_4:		JB	K4,MAIN_5		;判断4号键是否按下，否则检测5号键
		LCALL	Sound4			;发音子程序
MAIN_5:		JB	K5,MAIN_6		;判断5号键是否按下，否则检测6号键
		LCALL	Sound5			;发音子程序
MAIN_6:		JB	K6,MAIN_7		;判断6号键是否按下，否则检测7号键
		LCALL	Sound6			;发音子程序
MAIN_7:		JB	K7,MAIN_73		;判断7号键是否按下，否则跳回检测1号键
		LCALL	Sound7			;发音子程序
MAIN_73:	SJMP	MAIN_1			;返回从1号键开始扫描

;播放演示音乐
Demo:		MOV	DPTR,#Music
Demo_1:		CLR	A
		MOVC	A,@A+DPTR
		INC	DPTR
		JZ	Demo_Ret
		LCALL	SoundMCU		;放音子程序
		JMP	Demo_1
Demo_Ret:	RET

;乐曲:),0-结果标志
Music:		DB	M1,M2,M3,M4,M5,M6,M7,M7,M7,M6,M5,M4,M3,M2,M1
		DB	M1,M2,M1,M2,M3,M2,M3,M4,M3,M4,M5,M4,M5,M6,M5
		DB	M6,M7,M6,M7,M7,M6,M6,M6,0

;程序控制发音
SoundMCU:	MOV	R5,#40H			;控制放音时间
		MOV	R7,A
		ACALL	Time
		MOV	R6,A
SoundMCU_0:	PUSH	06H
SoundMCU_1:	ACALL	MusicalScale
		DJNZ	R6,SoundMCU_1
		POP	06H
		DJNZ	R5,SoundMCU_0
		RET
;计算时长
Time:		MOV	B,#0FFH
		XCH	A,B
		DIV	AB
		XCH	A,B
		CJNE	A,#8,$+3
		JC	Time_1
		INC	B
Time_1:		XCH	A,B
		RET

MusicalScale:	MOV	A,R7
MusicalScale1:	CLR	Buzzer			;1号键发音
		LCALL	Delay			;延时
		DJNZ	ACC,MusicalScale1
		MOV	A,R7
MusicalScale2:	SETB	Buzzer
		LCALL	Delay			;延时
		DJNZ	ACC,MusicalScale2
		RET
;1号键发音
Sound1:		MOV	R7,#M1			;发音频率，越大频率越低
Sound1_1:	ACALL	MusicalScale
		JNB	K1,Sound1_1
		RET
;2号键发音
Sound2:		MOV	R7,#M2			;发音频率，越大频率越低
Sound2_1:	ACALL	MusicalScale
		JNB	K2,Sound2_1
		RET
;3号键发音
Sound3:		MOV	R7,#M3
Sound3_1:	ACALL	MusicalScale
		JNB	K3,Sound3_1
		RET
;4号键发音
Sound4:		MOV	R7,#M4
Sound4_1:	ACALL	MusicalScale
		JNB	K4,Sound4_1
		RET
;5号键发音
Sound5:		MOV	R7,#M5
Sound5_1:	ACALL	MusicalScale
		JNB	K5,Sound5_1
		RET
;6号键发音
Sound6:		MOV	R7,#M6
Sound6_1:	ACALL	MusicalScale
		JNB	K6,Sound6_1
		RET
;7号键发音
Sound7:		MOV	R7,#M7			;发音频率，越大频率越低
Sound7_1:	ACALL	MusicalScale
		JNB	K7,Sound7_1
		RET
;延时
Delay:		NOP
		RET

		END
