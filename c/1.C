#include<reg52.h>

unsigned char sz[]={
  0xfe,0xfd,0xfb,0xf7,
  0xef,0xdf,0xbf,0x7f,
  0xbf,0xdf,0xef,0xf7,
  0xfb,0xfd,
  };

void main()
{
   unsigned char cnt = 0; //������ʱ������ֵ
   unsigned char sec = 0; //��������������ֵ
   TMOD = 0x01;         //���ö�ʱ��ģʽΪ1
   TH0 = 0xb8;         //��λ��ʱ��������ֵ
   TL0 = 0x00;         //��λ��ʱ��������ֵ
   TR0 = 1;                //�򿪶�ʱ��
  while (1)
  {
    if (TF0 == 1)
      {
        TF0 = 0;   //��ʱ����������㲢����ֵ
        TH0 = 0xb8;
        TL0 = 0x00;
        cnt++;
       if (cnt>=5)        //�ı���ֵ�ɸı���ˮ�������ٶ�
        {
         cnt = 0;
         P2 = sz[sec];
         sec++;
         if (sec>=14) //�������ж��ٸ�Ԫ�ؾ�д������
          {
           sec = 0;
           }
         }
       }
   }
}