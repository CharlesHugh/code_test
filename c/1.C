#include<reg52.h>

unsigned char sz[]={
  0xfe,0xfd,0xfb,0xf7,
  0xef,0xdf,0xbf,0x7f,
  0xbf,0xdf,0xef,0xf7,
  0xfb,0xfd,
  };

void main()
{
   unsigned char cnt = 0; //声明定时器并赋值
   unsigned char sec = 0; //声明计数器并赋值
   TMOD = 0x01;         //设置定时器模式为1
   TH0 = 0xb8;         //高位定时器并赋初值
   TL0 = 0x00;         //低位定时器并赋初值
   TR0 = 1;                //打开定时器
  while (1)
  {
    if (TF0 == 1)
      {
        TF0 = 0;   //定时器溢出后清零并赋初值
        TH0 = 0xb8;
        TL0 = 0x00;
        cnt++;
       if (cnt>=5)        //改变数值可改变流水灯流动速度
        {
         cnt = 0;
         P2 = sz[sec];
         sec++;
         if (sec>=14) //数组里有多少个元素就写多少数
          {
           sec = 0;
           }
         }
       }
   }
}
