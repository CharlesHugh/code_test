;*******************************************************
;		���׵�����ʵ��˵��
;ʵ��Ŀ�ģ�	1.���շ�������ʹ��
;		2.���շ������Ĳ�ͬ�����ķ���
;ʵ�����ݣ�	1.ͨ����Ƭ������1-7�ż��ɵ͵��߷���1-7������

K1		BIT	P1.0			;����1
K2		BIT	P1.1			;����2
K3		BIT	P1.2			;����3
K4		BIT	P1.3			;����4
K5		BIT	P1.4			;����5
K6		BIT	P1.7			;����6
K7		BIT	P1.6			;����7
Buzzer		BIT	P1.5			;������
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
MAIN:		MOV	P1,#0FFH		;P1�ڳ�ʼ��
		LCALL	Demo			;����һ����ʾ����
MAIN_1:		JB	K1,MAIN_2		;�ж�1�ż��Ƿ��£�������2�ż�
		LCALL	Sound1			;�����ӳ���
MAIN_2:		JB	K2,MAIN_3		;�ж�2�ż��Ƿ��£�������3�ż�
		LCALL	Sound2			;�����ӳ���
MAIN_3:		JB	K3,MAIN_4		;�ж�2�ż��Ƿ��£�������4�ż�
		LCALL	Sound3			;�����ӳ���
MAIN_4:		JB	K4,MAIN_5		;�ж�4�ż��Ƿ��£�������5�ż�
		LCALL	Sound4			;�����ӳ���
MAIN_5:		JB	K5,MAIN_6		;�ж�5�ż��Ƿ��£�������6�ż�
		LCALL	Sound5			;�����ӳ���
MAIN_6:		JB	K6,MAIN_7		;�ж�6�ż��Ƿ��£�������7�ż�
		LCALL	Sound6			;�����ӳ���
MAIN_7:		JB	K7,MAIN_73		;�ж�7�ż��Ƿ��£��������ؼ��1�ż�
		LCALL	Sound7			;�����ӳ���
MAIN_73:	SJMP	MAIN_1			;���ش�1�ż���ʼɨ��

;������ʾ����
Demo:		MOV	DPTR,#Music
Demo_1:		CLR	A
		MOVC	A,@A+DPTR
		INC	DPTR
		JZ	Demo_Ret
		LCALL	SoundMCU		;�����ӳ���
		JMP	Demo_1
Demo_Ret:	RET

;����:),0-�����־
Music:		DB	M1,M2,M3,M4,M5,M6,M7,M7,M7,M6,M5,M4,M3,M2,M1
		DB	M1,M2,M1,M2,M3,M2,M3,M4,M3,M4,M5,M4,M5,M6,M5
		DB	M6,M7,M6,M7,M7,M6,M6,M6,0

;������Ʒ���
SoundMCU:	MOV	R5,#40H			;���Ʒ���ʱ��
		MOV	R7,A
		ACALL	Time
		MOV	R6,A
SoundMCU_0:	PUSH	06H
SoundMCU_1:	ACALL	MusicalScale
		DJNZ	R6,SoundMCU_1
		POP	06H
		DJNZ	R5,SoundMCU_0
		RET
;����ʱ��
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
MusicalScale1:	CLR	Buzzer			;1�ż�����
		LCALL	Delay			;��ʱ
		DJNZ	ACC,MusicalScale1
		MOV	A,R7
MusicalScale2:	SETB	Buzzer
		LCALL	Delay			;��ʱ
		DJNZ	ACC,MusicalScale2
		RET
;1�ż�����
Sound1:		MOV	R7,#M1			;����Ƶ�ʣ�Խ��Ƶ��Խ��
Sound1_1:	ACALL	MusicalScale
		JNB	K1,Sound1_1
		RET
;2�ż�����
Sound2:		MOV	R7,#M2			;����Ƶ�ʣ�Խ��Ƶ��Խ��
Sound2_1:	ACALL	MusicalScale
		JNB	K2,Sound2_1
		RET
;3�ż�����
Sound3:		MOV	R7,#M3
Sound3_1:	ACALL	MusicalScale
		JNB	K3,Sound3_1
		RET
;4�ż�����
Sound4:		MOV	R7,#M4
Sound4_1:	ACALL	MusicalScale
		JNB	K4,Sound4_1
		RET
;5�ż�����
Sound5:		MOV	R7,#M5
Sound5_1:	ACALL	MusicalScale
		JNB	K5,Sound5_1
		RET
;6�ż�����
Sound6:		MOV	R7,#M6
Sound6_1:	ACALL	MusicalScale
		JNB	K6,Sound6_1
		RET
;7�ż�����
Sound7:		MOV	R7,#M7			;����Ƶ�ʣ�Խ��Ƶ��Խ��
Sound7_1:	ACALL	MusicalScale
		JNB	K7,Sound7_1
		RET
;��ʱ
Delay:		NOP
		RET

		END