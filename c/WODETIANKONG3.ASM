			;                ���ࡶ���֮�ǡ�
        ORG 0000H
        AJMP MAIN    ;ת��������
        ORG 000BH    ;T0���ж���ڵ�ַ
        LJMP IT0P    ;ת��T0���жϷ����ӳ���
     	ORG 0020H    ;��������ڵ�ַ
  MAIN: MOV TMOD,#01H    ;ѡ��T0�����ڷ�ʽ1
        MOV IE,#82H      ;����T0�ж�
 START: MOV 30H,#00H     ;ȡ��ָ���ʼ����������30HΪȡ��ָ�룩
  LOOP: MOV A,30H        ;��ȡ��ָ��װ��A
        MOV DPTR,#TAB2 	 ;��TAB2����ȡ������
        MOVC A,@A+DPTR 	 ;ȡ������
        MOV R2,A     ;��ȡ�����������ݴ���R2
        JZ END0      ;�ж�ȡ�����Ƿ�Ϊ������00H
        ANL A,#0FH   ;ȡ��4λ�������룩
        MOV R3,A  	 ;�����������R3
        MOV A,R2   	 ;��ȡ������������װ��A��
        ANL A,#0F0H  ;ȡ��4λ�������룩
        JNZ SING  	 ;�ж�ȡ�����������Ƿ�Ϊ0����ֹ����
        CLR TR0   	 ;ֹͣT0��������
        SJMP NEXT    ;ת����ʱ�ӳ���
  SING: SWAP A	  ;�ߵ�λ����
        DEC A     ;ȡ�����������1
        RL A 	  ;A����ֵ��2
  		MOV R4,A  ;��A����ֵ�ݴ���R4
        MOV DPTR,#TAB1 	;��TAB1��ȡ�����루������ֵ��
        MOVC A,@A+DPTR 	;ȡ��λ�ֽ�
        MOV TH0,A   ;��ȡ���ĸ�λ�ֽ�װ��TH0
        MOV 21H,A  	;��ȡ���ĸ�λ�ֽڴ���21H��Ԫ
        MOV A,R4 	;��R4�е���ֵ��װ��A��
        INC DPTR  	;DPTR��1
        MOVC A,@A+DPTR  ;ȡ��λ�ֽ�
        MOV TL0,A  	;��ȡ���ĵ�λ�ֽ�װ��TL0
        MOV 20H,A  	;��ȡ���ĵ�λ�ֽڴ���20H��Ԫ
        SETB TR0   	;����T0
  NEXT: LCALL DELAY   ;������ʱ
        DJNZ R3,NEXT
        INC 30H   	 ;ȡ��ָ����1
        LJMP LOOP 	 ;ȡ��һ��������
  END0: CLR TR0   	 ;ֹͣT0
        LJMP START 	 ;�ظ�ѭ������

  IT0P: MOV TL0,20H  ;��T0��װ��ֵ
        MOV TH0,21H
        CPL P1.5  	 ;��P1.0ȡ�����Բ�����Ƶ����
        RETI

 DELAY: MOV R7,#02   ;1/4���ĵ���ʱ�ӳ���125ms��4/4�ĵ����ӣ�
DELAY1: MOV R6,#125
DELAY2: MOV R5,#248
        DJNZ R5,$
        DJNZ R6,DELAY2
        DJNZ R7,DELAY1
        RET
  TAB1:    ;�������
        DW 64580,63684,64777,64820,64898,64968,65030 ;M1 M2 M3 M4  M5 M6 M7
        DW 65058,65110,64260,64400,64524  ;H1 H2  L5 L6 L7

        DW 64400,64524,64580,63684,64777,64820,64898 ; L6 L7  M1 M2 M3 M4  M5    63628,63835,64021,64103,64260   L1 L2 L3 L4 L5
        DW 64968,65030,65058,65110,65157,65178,65217 ;M6 M7 H1 H2 H3 H4 H5
        DW 65252,65283  ; H6 H7
     ;���������֮�ǡ�������
  TAB2:

        DB 32H,12H,52H,32H,32H,12H,52H,32H,42H,12H,52H,42H,32H,32H,12H,12H,32H,12H,32H,12H,0D2H,32H,32H,12H,52H,32H,42H,12H,52H,42H,32H,32H,32H,32H
        DB 32H,12H,52H,32H,32H,12H,52H,32H,42H,12H,52H,42H,32H,32H,12H,12H,32H,12H,32H,12H,0D2H,32H,32H,12H,52H,32H,42H,12H,52H,42H,32H,32H,02H,02H

        DB 02H,52H,63H,0C1H,0C2H,52H,63H,0C1H,0C2H,0A2H,0B4H,04H,02H,0C2H,0B2H,0A2H
        DB 53H,0B1H,0B2H,32H,53H,0B1H,0B2H,52H,0A6H,52H,02H,12H,22H,23H,32H
        DB 54H,62H,34H,22H,24H,02H,12H,22H,32H,26H,12H,14H,0CH,14H,0CH
        DB 32H,54H,32H,62H,52H,32H,22H,22H,12H,14H,08H
        DB 62H,0A4H,62H,62H,52H,54H,32H,52H,54H,08H,62H,52H,62H,0A2H,0B2H,0C2H,72H,62H
        DB 56H,31H,21H,34H,04H,02H,22H,32H,52H,62H,54H,32H

END
        DB 0BH,52H,31H,21H,31H,21H,11H,0D4H,21H,31H,21H,11H,0C4H,21H,31H
        DB 21H,11H,0D2H,11H,21H,0D2H,34H,11H,21H,31H,52H,33H,22H,12H,21H,11H,0D2H,11H,21H,32H
        DB 54H,08H,01H,21H,11H,0D1H,13H,0D1H,13H,0D1H,11H,0D1H,0C1H,01H,21H,11H,0D1H
        DB 13H,0D1H,13H,0D1H,11H,61H,0C2H,01H,21H,11H,0D1H,13H,0D1H,13H,31H,21H,13H,01H,0C1H,0D1H,31H
        end

  DB 18H,02H,86H,76H,26H,74H,78h,04H
        DB 62H,72H,86H,72H,84H,0A4H       ;
        DB 78h,04H,14H,66H,42H,64H,84H            ;
        DB 34H,04H,02H,82H,82H,82H,76H,42H,44H,74H
        DB 74H,04H,04H,62H,72H,86H,72H,84H,0A4H
        DB 74H,04H,04H,32H,32H,66H,52H,64H,84H        ;
        DB 54H,04H,04H,02H,32H,44H,82H,72H,74H,84H
        DB 92H,92H,0A2H,82H,84H,04H,82H,72H,62H,62H,74H,54H
        DB 64H,04H,04H,82H,92H,0A6H,92H,0A4H,0C4H              ;
        DB 94H,04H,04H,52H,52H,86H,72H,84H,0A4H
        DB 0A4H,04H,04H,04H,62H,72H,84H,74H,92H,92H
        DB 86H,52H,54H,04H,0B4H,0A4H,94H,84H                  ;
        DB 0A4H,04H,04H,04H,0A4H,04H,04H,0A4H
        DB 0D4H,04H,0C4H,0C4H,0A2H,92H,84H,04H,02H,82H
        DB 94H,82H,92H,94H,0C4H,0A4H,04H,04H,0A4              ;
        DB 0D4H,04H,0C4H,04H,0A2H,92H,84H,04H,02H,82H
        DB 94H,82H,92H,94H,74H,64H,04H,04H,62H,72H
        DB 64H,04H,04H                                         ;
        DB 00H
        END