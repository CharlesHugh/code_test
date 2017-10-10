		  	 ;演奏《天空之城》
        ORG 0000H
        AJMP MAIN        ;转到主程序
        ORG 000BH        ;T0的中断入口地址
        LJMP IT0P        ;转到T0的中断服务子程序

     	ORG 0020H        ;主程序入口地址
  MAIN: MOV TMOD,#01H    ;选择T0工作在方式1
        MOV IE,#82H      ;允许T0中断
 START: MOV 30H,#00H     ;取谱指针初始化（这里设30H为取谱指针）
  LOOP: MOV A,30H        ;将取谱指针装入A                    A =00H
        MOV DPTR,#TAB2 	 ;到TAB2处，取乐谱码
        MOVC A,@A+DPTR 	 ;取乐谱码                           A =JPH (乐谱码)
        MOV R2,A         ;将取到的乐谱码暂存于R2             R2=JPH (乐谱码)
        JZ END0          ;判断取到的是否为结束码00H
        ANL A,#0FH       ;取低4位（节拍码）                  A =0PH  (节拍码)
        MOV R3,A  	 ;将节拍码存入R3                     R3=0PH  (节拍码)
        MOV A,R2   	 ;将取到的乐谱码重装入A中            A =JPH  (乐谱码)
        ANL A,#0F0H      ;取高4位（音符码）                  A =J0H  (音符码)
        JNZ SING  	 ;判断取到的音符码是否为0（休止符）
        CLR TR0   	 ;停止T0，不发音
        SJMP NEXT       ;转至延时子程序
  SING: SWAP A	        ;高低位互换                          A =0JH
        DEC A           ;取到的音符码减1                     A =0JH-1
        RL A 	        ;A中数值乘2
  	MOV R4,A        ;将A中数值暂存于R4

        MOV DPTR,#TAB1 	;到TAB1处取简谱码（计数初值）
        MOVC A,@A+DPTR 	;取高位字节
        MOV TH0,A       ;将取到的高位字节装入TH0
        MOV 21H,A  	;将取到的高位字节存入21H单元
        MOV A,R4 	;将R4中的数值重装入A中
        INC DPTR  	;DPTR增1
        MOVC A,@A+DPTR  ;取低位字节
        MOV TL0,A  	;将取到的低位字节装入TL0
        MOV 20H,A  	;将取到的低位字节存入20H单元

        SETB TR0   	;启动T0
  NEXT: LCALL DELAY     ;节拍延时
        DJNZ R3,NEXT
        INC 30H   	 ;取谱指针增1
        LJMP LOOP 	 ;取下一个乐谱码
  END0: CLR TR0   	 ;停止T0
        LJMP START 	 ;重复循环播放

  IT0P: MOV TL0,20H      ;给T0重装初值
        MOV TH0,21H
        CPL P1.5  	 ;将P1.5取反，以产生音频脉冲
        RETI

 DELAY: MOV R7,#02   ;1/4节拍的延时子程序125ms（4/4拍的曲子）
DELAY1: MOV R6,#125
DELAY2: MOV R5,#248
        DJNZ R5,$
        DJNZ R6,DELAY2
        DJNZ R7,DELAY1
        RET

  TAB1:                                   ;简谱码表
        DW 64777,64820,64860,64898,64934  ;M3 M4 M#4 M5 M#5
        DW 64968,65030,65058,65110,65157  ;M6 M7 H1  H2 H3
	DW 65178,65217,65252	          ;H4 H5 H6
  TAB2:    ;歌曲《天空之城》的乐谱 1=C，4/4拍
        DB 0CH,62H,72H,86H,72H,84H,0A4H,7CH       ;例如，0CH表示休止符，占3拍
        DB 14H,66H,42H,64H,84H,58H,04H            ;66H表示M6，占1拍半；12H表示M3，占半拍。。。
        DB 14H,26H,12H,24H,84H,18H,02H            ;第一行
        DB 86H,76H,2H,74H,78H,04H
        DB 62H,72H,86H,72H,84H,0A4H,78H,04H
        DB 14H,66H,42H,64H,84H,4CH,02H            ;第二行
        DB 12H,24H,82H,76H,84H,94H,0A2H,86H,04H
        DB 82H,72H,64H,74H,44H,68H,04H
        DB 82H,92H,0A6H,92H,0A4H,0C4H,98H,04H     ;第三行
        DB 44H,86H,72H,84H,0ACH,08H
        DB 62H,72H,84H,74H,94H,86H,46H,04H
        DB 0B4H,0A4H,94H,84H,0A8H,08H             ;第四行
        DB 0A8H,02H,0A4H,0D4H,04H
        DB 0C8H,0A2H,92H,88H,02H
        DB 82H,94H,82H,96H,0C4H,0A8H,04H          ;第五行
        DB 0A4H,0D8H,0C8H,0A2H,92H,88H,02H
        DB 82H,94H,82H,96H,74H,68H,04H
        DB 62H,72H,64H,0CH                        ;第六行
        DB 00H                                    ;结束码
        END

TABLE3:
        DW 0,63628,63835,64021,64103,64260,64400,64524,0,0    ; 低音 ：  0  Do  Re M  Fa    So La Si 0  0
        DW 0,63731,63928,0,64185,64331,64463,0,0,0            ; 低音#：  0  Do  Re 0  Fa    So La Si 0  0
        DW 0,64580,64684,64777,64820,64898,64968,65030,0,0    ; 中音 ：  0  Do  Re M  Fa    So La Si 0  0
        DW 0,64633,64732,0,64860,64934,64994,0,0,0            ; 中音#：  0  Do  Re 0  Fa    So La Si 0  0
        DW 0,65058,65110,65157,65178,65217,65252,65283,0,0    ; 高音 ：  0  Do  Re M  Fa    So La Si 0  0
        DW 0,65085,65134,0,65198,65235,65268,0,0,0            ; 高音#：  0  Do  Re 0  Fa    So La Si 0  0
        DW 0
