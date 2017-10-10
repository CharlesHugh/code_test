/*******************************************************************************
* 实验名			   : 左右流水灯实验
* 使用的IO	     : P2
* 实验效果       : 点亮的LED从右边往左边移动，到达左边再往右边移动，依此循环。
*	注意					 ：
*******************************************************************************/
ORG		00H
LJMP	INIT

ORG		30H
INIT:
MOV 	A ,#0FEH	;将A赋值

MAIN:
MOV 	R1,#007H	;左移的次数
MOV 	R2,#007H	;右移的次数
LIFT:
MOV 	P2 , A
RL 		A
ACALL 	DELAY		;调用延时函数
DJNZ 	R1,LIFT
RIGHT:
MOV 	P2,A
RR		A
ACALL 	DELAY
DJNZ 	R2,RIGHT
LJMP 	MAIN		;跳回主函数

DELAY:
MOV 	R5,#005H
DE1:
MOV 	R6,#0FFH
DE2:
MOV 	R7,#0FFH
DE3:
DJNZ 	R7,DE3
DJNZ 	R6,DE2
DJNZ 	R5,DE1
RET

END		
