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
        DW 64777,64820,64860,64898,64934  ;M3 M4 M#4 M5 M#5
        DW 64968,65030,65058,65110,65157  ;M6 M7 H1  H2 H3
	DW 65178,65217,65252              ;H4 H5 H6
     ;���������֮�ǡ�������
  TAB2: DB 04H,04H,04H,62H,72H,86H,72H,84H,0A4H
        DB 78H,04H,32H,32H,66H,52H,64H,84H
        DB 58H,04H,32H,32H,46H,32H,42H,86H
        end
        
        DB 34H,04H,02H,82H,82H,82H,76H,42H,44H,74H
        DB 74H,04H,04H,62H,72H,86H,72H,84H,0A4H
        DB 74H,04H,04H,32H,32H,66H,52H,64H,84H
        
        DB 54H,04H,04H,02H,32H,44H,82H,72H,74H,84H
        DB 92H,92H,0A2H,82H,84H,04H,82H,72H,62H,62H,74H,54H
        DB 64H,04H,04H,82H,92H,0A6H,92H,0A4H,0C4H
        
        DB 94H,04H,04H,52H,52H,86H,72H,84H,0A4H
        DB 0A4H,04H,04H,04H,62H,72H,84H,74H,92H,92H
        DB 86H,52H,54H,04H,0B4H,0A4H,94H,84H
        
        DB 0A4H,04H,04H,04H,0A4H,04H,04H,0A4H
        DB 0D4H,04H,0C4H,0C4H,0A2H,92H,84H,04H,02H,82H
        DB 94H,82H,92H,94H,0C4H,0A4H,04H,04H,0A4
        
        DB 0D4H,04H,0C4H,04H,0A2H,92H,84H,04H,02H,82H
        DB 94H,82H,92H,94H,74H,64H,04H,04H,62H,72H
        DB 64H,04H,04H
        DB 00H