		  	 ;���ࡶ���֮�ǡ�
        ORG 0000H
        AJMP MAIN        ;ת��������
        ORG 000BH        ;T0���ж���ڵ�ַ
        LJMP IT0P        ;ת��T0���жϷ����ӳ���

     	ORG 0020H        ;��������ڵ�ַ
  MAIN: MOV TMOD,#01H    ;ѡ��T0�����ڷ�ʽ1
        MOV IE,#82H      ;����T0�ж�
 START: MOV 30H,#00H     ;ȡ��ָ���ʼ����������30HΪȡ��ָ�룩
  LOOP: MOV A,30H        ;��ȡ��ָ��װ��A                    A =00H
        MOV DPTR,#TAB2 	 ;��TAB2����ȡ������
        MOVC A,@A+DPTR 	 ;ȡ������                           A =JPH (������)
        MOV R2,A         ;��ȡ�����������ݴ���R2             R2=JPH (������)
        JZ END0          ;�ж�ȡ�����Ƿ�Ϊ������00H
        ANL A,#0FH       ;ȡ��4λ�������룩                  A =0PH  (������)
        MOV R3,A  	 ;�����������R3                     R3=0PH  (������)
        MOV A,R2   	 ;��ȡ������������װ��A��            A =JPH  (������)
        ANL A,#0F0H      ;ȡ��4λ�������룩                  A =J0H  (������)
        JNZ SING  	 ;�ж�ȡ�����������Ƿ�Ϊ0����ֹ����
        CLR TR0   	 ;ֹͣT0��������
        SJMP NEXT       ;ת����ʱ�ӳ���
  SING: SWAP A	        ;�ߵ�λ����                          A =0JH
        DEC A           ;ȡ�����������1                     A =0JH-1
        RL A 	        ;A����ֵ��2
  	MOV R4,A        ;��A����ֵ�ݴ���R4

        MOV DPTR,#TAB1 	;��TAB1��ȡ�����루������ֵ��
        MOVC A,@A+DPTR 	;ȡ��λ�ֽ�
        MOV TH0,A       ;��ȡ���ĸ�λ�ֽ�װ��TH0
        MOV 21H,A  	;��ȡ���ĸ�λ�ֽڴ���21H��Ԫ
        MOV A,R4 	;��R4�е���ֵ��װ��A��
        INC DPTR  	;DPTR��1
        MOVC A,@A+DPTR  ;ȡ��λ�ֽ�
        MOV TL0,A  	;��ȡ���ĵ�λ�ֽ�װ��TL0
        MOV 20H,A  	;��ȡ���ĵ�λ�ֽڴ���20H��Ԫ

        SETB TR0   	;����T0
  NEXT: LCALL DELAY     ;������ʱ
        DJNZ R3,NEXT
        INC 30H   	 ;ȡ��ָ����1
        LJMP LOOP 	 ;ȡ��һ��������
  END0: CLR TR0   	 ;ֹͣT0
        LJMP START 	 ;�ظ�ѭ������

  IT0P: MOV TL0,20H      ;��T0��װ��ֵ
        MOV TH0,21H
        CPL P1.5  	 ;��P1.5ȡ�����Բ�����Ƶ����
        RETI

 DELAY: MOV R7,#02   ;1/4���ĵ���ʱ�ӳ���125ms��4/4�ĵ����ӣ�
DELAY1: MOV R6,#125
DELAY2: MOV R5,#248
        DJNZ R5,$
        DJNZ R6,DELAY2
        DJNZ R7,DELAY1
        RET

  TAB1:                                   ;�������
        DW 64777,64820,64860,64898,64934  ;M3 M4 M#4 M5 M#5
        DW 64968,65030,65058,65110,65157  ;M6 M7 H1  H2 H3
	DW 65178,65217,65252	          ;H4 H5 H6
  TAB2:    ;���������֮�ǡ������� 1=C��4/4��
        DB 0CH,62H,72H,86H,72H,84H,0A4H,7CH       ;���磬0CH��ʾ��ֹ����ռ3��
        DB 14H,66H,42H,64H,84H,58H,04H            ;66H��ʾM6��ռ1�İ룻12H��ʾM3��ռ���ġ�����
        DB 14H,26H,12H,24H,84H,18H,02H            ;��һ��
        DB 86H,76H,2H,74H,78H,04H
        DB 62H,72H,86H,72H,84H,0A4H,78H,04H
        DB 14H,66H,42H,64H,84H,4CH,02H            ;�ڶ���
        DB 12H,24H,82H,76H,84H,94H,0A2H,86H,04H
        DB 82H,72H,64H,74H,44H,68H,04H
        DB 82H,92H,0A6H,92H,0A4H,0C4H,98H,04H     ;������
        DB 44H,86H,72H,84H,0ACH,08H
        DB 62H,72H,84H,74H,94H,86H,46H,04H
        DB 0B4H,0A4H,94H,84H,0A8H,08H             ;������
        DB 0A8H,02H,0A4H,0D4H,04H
        DB 0C8H,0A2H,92H,88H,02H
        DB 82H,94H,82H,96H,0C4H,0A8H,04H          ;������
        DB 0A4H,0D8H,0C8H,0A2H,92H,88H,02H
        DB 82H,94H,82H,96H,74H,68H,04H
        DB 62H,72H,64H,0CH                        ;������
        DB 00H                                    ;������
        END

TABLE3:
        DW 0,63628,63835,64021,64103,64260,64400,64524,0,0    ; ���� ��  0  Do  Re M  Fa    So La Si 0  0
        DW 0,63731,63928,0,64185,64331,64463,0,0,0            ; ����#��  0  Do  Re 0  Fa    So La Si 0  0
        DW 0,64580,64684,64777,64820,64898,64968,65030,0,0    ; ���� ��  0  Do  Re M  Fa    So La Si 0  0
        DW 0,64633,64732,0,64860,64934,64994,0,0,0            ; ����#��  0  Do  Re 0  Fa    So La Si 0  0
        DW 0,65058,65110,65157,65178,65217,65252,65283,0,0    ; ���� ��  0  Do  Re M  Fa    So La Si 0  0
        DW 0,65085,65134,0,65198,65235,65268,0,0,0            ; ����#��  0  Do  Re 0  Fa    So La Si 0  0
        DW 0