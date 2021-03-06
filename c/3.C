
//--------------------------------------------------------------------------//
//                                源程序大公开                              //
//                    (c) Copyright 2001－2002 xuwenjun                     //
//                            All Rights Reserved                           //
//                                    V1.00                                 //
//--------------------------------------------------------------------------//
//标　题: 单片机IO口播放乐曲                                                //
//版　本: V1.00                                                             //
//文件名: xwj_lcd16.C                                                       //
//创建人: 徐文军                         E-mail:xuwenjun@21cn.com           //
//日　期: 02-11-5                                                           //
//描　述: 单片机利用T1中断在IO口P1.0输出乐曲                                //
//声　明:                                                                   //
//        以下代码仅免费提供给学习用途，但引用或修改后必须在文件中声明出处. //
//        如用于商业用途请与作者联系.    E-mail:xuwenjun@21cn.com           //
//        有问题请mailto xuwenjun@21cn.com   欢迎与我交流!                  //
//--------------------------------------------------------------------------//
//修改人: 徐文军                         E-mail:xuwenjun@21cn.com           //
//日　期: 02-11-5                                                           //
//说　明:                                                                   //
//        单片机用T1中断在IO口P1.0输出乐曲(在P1.0口与VCC间接一喇叭即可听到) //
//        1.由于输出的是方波，比较难听:-)你也可以将波形细分用DA输出正弦波   //
//        2.由于T1频繁中断，任何其他中断发生都会是乐曲打顿，只适合试验      //
//        3.优化音符编码：一个字节中包含节拍、音符、升降调，可区分数据和命令//
//                        同时人工将音符译为机器码非常容易。(格式看下面实例)//
//--------------------------------------------------------------------------//
#include <reg52.h>
#include <intrins.h>
#define  FREQ 11059200

    //  音乐_编码2 -- 存储器定义  //
unsigned char code music_tab1[]={    //音符码格式:| D7 |D6  D5  D4| D3 |D2D1  D0|
                                     //梁祝       |变调|      节拍|升降|     音符 |
    0xcb,                            //示例:0xcb=11001011B,即升调,4/16拍,3Mi低音
    0x35,0x16,0xb9,0x12,0x96,0x99,0xa5,
    0xbd,0x99,0x96,0x15,0x13,0x15,0x62,
    0x32,0x13,0xa7,0x26,0x25,0x16,0xa9,0x22,
    0xa3,0xa9,0x96,0x15,0x16,0x99,0xe5,
    0xbb,0x15,0xa7,0xaa,0x96,0x99,0xd5,
    0x13,0x15,0x23,0x15,0x16,0x17,0x9a,0xd6,0x15,0x16,
    0xb9,0x12,0x25,0x23,0x23,0x22,0x13,0x12,0x21,0x96,0x15,
    0x43,0xc9,0x96,0x99,0x96,0x15,0x13,0x15,0x16,0x99,
    0xd5,                            //功能码格式:| D7  D6  D5  D4  | D3  D2D1  D0|
                                     //           |高4位=0时是功能码|根据低4位散转  |
    0x00,                            //最后字节为功能码必须==0x00退出
};
unsigned char code music_tab2[]={    //康定情歌
    0x23,0x25,0x26,0x16,0x15,    0x36,0x13,0x42,
    0x23,0x25,0x26,0x16,0x15,    0x26,0x53,
    0x23,0x25,0x26,0x16,0x15,    0x26,0x23,0x42,
    0x25,0x23,0x12,0x13,0x12,0x11,    0x22,0xd6,
    0x26,0xda,    0x25,0x53,    0x12,0x11,0xd6,
    0xad,0x23,0x12,0x13,0x12,0x11,    0x22,0xd6,
    0x00,
};
unsigned char code music_tab3[]={    //美酒加咖啡
    0x55,0x23,0x25,0x26,0xa9,0x22,    0x73,
    0x45,0x25,0x26,0x23,0x22,0x21,0x23,    0x72,
    0x52,0x23,0x45,0x43,    0x22,0x21,0xa6,0x25,0x66,
    0xc9,0xa6,0x25,0x23,0x25,0x26,0xa9,    0xf5,
    0x45,0x23,0x25,0x46,0xc9,    0x22,0x13,0x12,0x21,0x22,0x63,
    0x22,0x23,0x25,0x26,0x25,0x23,0x22,0x21,    0x72,
    0x52,0x23,0x45,0x43,    0x22,0x21,0xa6,0x25,0x66,
    0xb9,0x12,0x23,0x25,0x22,0xa5,0xab,0x22,    0x71,
    0x00,
};
unsigned char code music_tab4[]={    //北国之春
    0x15,0x16,0x75,    0x15,0x16,0x55,0x13,0x15,0x16,0x15,0x16,0x99,0x12,0x13,
    0x65,0x45,0x13,0x12,0x11,0x12,    0x73,
    0x62,0x42,0x12,0x11,0x96,0x15,    0x76,
    0x55,0x23,0x45,0xa9,0x22,    0x53,0x12,0x13,0x65,
    0x52,0x22,0x42,0x21,0xa6,    0xe9,0x91,0x12,0x13,0x12,0x13,0x15,0x99,0x12,
    //以上为过门
    0x20,0x23,0x23,0x23,0x63,    0x22,0x23,0x23,0x22,0x41,0xa6,0x25,
    0x53,0x22,0x21,0xa9,0x21,0xa6,    0x75,
    0x26,0xa9,0x21,0xa6,0xc9,0x12,0x11,0x96,0x15,
    0x23,0x25,0x25,0x26,0x45,0x21,0x22,
    0x13,0x35,0x25,0xa9,0xa6,0x25,0x23,0x22,    0x71,
    0x52,0x25,0x45,0x13,0x15,0x13,0x12,    0x21,0x41,0x22,0x43,0x45,
    0x23,0x25,0x26,0xa9,0x42,0x12,0x33,    0x72,
    0x51,0x22,0x43,0x22,0x21,    0xc6,0xc9,0x29,0xc6,0x45,0x23,0x23,
    0x53,0x25,0x26,0x25,0x13,0x12,0x21,    0x62,0x42,0x23,0x25,
    0x55,0x26,0x25,0x23,0x45,    0x26,0xa9,0x21,0x22,0x63,
    0x52,0x22,0x22,0x13,0x12,0x21,0xa6,0xf9,
    0x00,
};

unsigned char code music_l_tab[8]={0,1,2,3,4,6,8,16};//节拍延时单位
unsigned char code music_freq_tab[64]={             //音符定时器值表
    0xff,0xea,                                      //0 休止符
    255-FREQ/24/131/256,     //256-FREQ/24/x/256    //1 do 高字节
    256-FREQ/24/131%256,     //256-FREQ/24/x%256    //1 do 低字节
    255-FREQ/24/147/256,256-FREQ/24/147%256,        //2 re
    255-FREQ/24/165/256,256-FREQ/24/165%256,        //3 mi
    255-FREQ/24/175/256,256-FREQ/24/175%256,        //4 fa
    255-FREQ/24/196/256,256-FREQ/24/196%256,        //5 suo
    255-FREQ/24/221/256,256-FREQ/24/221%256,        //6 la
    255-FREQ/24/248/256,256-FREQ/24/248%256,        //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/262/256,256-FREQ/24/262%256,        //1 do
    255-FREQ/24/294/256,256-FREQ/24/294%256,        //2 re
    255-FREQ/24/330/256,256-FREQ/24/330%256,        //3 mi
    255-FREQ/24/350/256,256-FREQ/24/350%256,        //4 fa
    255-FREQ/24/393/256,256-FREQ/24/393%256,        //5 suo
    255-FREQ/24/441/256,256-FREQ/24/441%256,        //6 la
    255-FREQ/24/495/256,256-FREQ/24/495%256,        //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/525/256,256-FREQ/24/525%256,        //1 do
    255-FREQ/24/589/256,256-FREQ/24/589%256,        //2 re
    255-FREQ/24/661/256,256-FREQ/24/661%256,        //3 mi
    255-FREQ/24/700/256,256-FREQ/24/700%256,        //4 fa
    255-FREQ/24/786/256,256-FREQ/24/786%256,        //5 suo
    255-FREQ/24/882/256,256-FREQ/24/882%256,        //6 la
    255-FREQ/24/990/256,256-FREQ/24/990%256,        //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/1049/256,256-FREQ/24/1049%256,      //1 do
    255-FREQ/24/1178/256,256-FREQ/24/1178%256,      //2 re
    255-FREQ/24/1322/256,256-FREQ/24/1322%256,      //3 mi
    255-FREQ/24/1400/256,256-FREQ/24/1400%256,      //4 fa
    255-FREQ/24/1572/256,256-FREQ/24/1572%256,      //5 suo
    255-FREQ/24/1665/256,256-FREQ/24/1665%256,      //6 la
    255-FREQ/24/1869/256,256-FREQ/24/1869%256,      //7 xi

};

unsigned char code music_frequp_tab[64]={           //升半音
    0xff,0xea,                                      //0 休止符
    255-FREQ/24/139/256,        //1 do 高字节 //255-FREQ/24/x/256
    256-FREQ/24/139%256,        //1 do 低字节 //256-FREQ/24/x%256
    255-FREQ/24/156/256,256-FREQ/24/156%256,        //2 re
    255-FREQ/24/175/256,256-FREQ/24/175%256,        //3 mi
    255-FREQ/24/185/256,256-FREQ/24/185%256,        //4 fa
    255-FREQ/24/208/256,256-FREQ/24/208%256,        //5 suo
    255-FREQ/24/234/256,256-FREQ/24/234%256,        //6 la
    255-FREQ/24/262/256,256-FREQ/24/262%256,        //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/278/256,256-FREQ/24/278%256,        //1 do
    255-FREQ/24/312/256,256-FREQ/24/312%256,        //2 re
    255-FREQ/24/350/256,256-FREQ/24/350%256,        //3 mi
    255-FREQ/24/371/256,256-FREQ/24/371%256,        //4 fa
    255-FREQ/24/416/256,256-FREQ/24/416%256,        //5 suo
    255-FREQ/24/467/256,256-FREQ/24/467%256,        //6 la
    255-FREQ/24/525/256,256-FREQ/24/525%256,        //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/556/256,256-FREQ/24/556%256,        //1 do
    255-FREQ/24/624/256,256-FREQ/24/624%256,        //2 re
    255-FREQ/24/700/256,256-FREQ/24/700%256,        //3 mi
    255-FREQ/24/742/256,256-FREQ/24/742%256,        //4 fa
    255-FREQ/24/833/256,256-FREQ/24/833%256,        //5 suo
    255-FREQ/24/935/256,256-FREQ/24/935%256,        //6 la
    255-FREQ/24/1049/256,256-FREQ/24/1049%256,      //7 xi

    0xff,0xea,                                      //0 休止符
    255-FREQ/24/1112/256,256-FREQ/24/1112%256,      //1 do
    255-FREQ/24/1248/256,256-FREQ/24/1248%256,      //2 re
    255-FREQ/24/1400/256,256-FREQ/24/1400%256,      //3 mi
    255-FREQ/24/1484/256,256-FREQ/24/1484%256,      //4 fa
    255-FREQ/24/1618/256,256-FREQ/24/1618%256,      //5 suo
    255-FREQ/24/1764/256,256-FREQ/24/1764%256,      //6 la
    255-FREQ/24/1968/256,256-FREQ/24/1968%256,      //7 xi
};
unsigned char temp_TH1;
unsigned char temp_TL1;

    //  音乐_编码2 -- IO定义  //
sbit PIN_MSC=P1^5;                   //  音乐输出端口  //

    //  音乐_编码2 -- 函数原型//
void music_delay(unsigned char x);   //音乐节拍延时
void music_play(unsigned char *msc); //播放音乐子程序

    //  音乐_编码2 -- 函数    //
//---------------------------------------------------------------------------//
void music_int_t1 (void) interrupt 3 using 1    //定时中断1//
    {
    PIN_MSC=~PIN_MSC;
    TH1=temp_TH1;
    TL1=temp_TL1;
}

//---------------------------------------------------------------------------//
void music_delay(unsigned char n)     //延时 125*n 毫秒
    {
    unsigned char i=125,j;
    do {
        do {
            for (j=0; j<230; j++) _nop_(); //j=(11159KHz/12-10)/4
        }while(--i);
    }while(--n);
}

//---------------------------------------------------------------------------//
void music_play(unsigned char *msc)   //音乐
    {
    unsigned char music_freq=32;      //音高
    unsigned char music_long;         //节拍
    unsigned char music_data=0;       //音符数据
    bit music_up=0;                   //升半音
    bit music_break=0;                //断奏
    temp_TH1=0xff;
    temp_TL1=0xea;                    //关输出(输出超声波)
    TMOD=0x11;                        //T0：16位定时器、T1：16位定时器
//    ET0=0;                          //关T0定时器中断
    ET1=1;                            //开T1定时器中断
//---------------------------------------------------------
    while (*msc != 0x00)
        {
        music_data=*msc & 0x07;
        music_long=*msc>>4;
        //---------------------------------------------------------
        if (music_long != 0)          //是音符
            {
            if (*msc >=128)           //需升降调
                {
                if (((*msc) & 0x08) == 0)
                    {if (music_freq >= 16) music_freq -= 16;}    //音高下降
                else
                    {if (music_freq <  48) music_freq += 16;}    //音高上升
             }
            //---------------------------------------------------------
            if (music_up==1)          //升半音
                {
                temp_TH1=music_frequp_tab[(music_freq  + (music_data <<1))];
                temp_TL1=music_frequp_tab[(music_freq + (music_data <<1)+1)];
            }
            else                      //不升半音
                {
                temp_TH1=music_freq_tab[(music_freq + (music_data <<1))];
                temp_TL1=music_freq_tab[(music_freq + (music_data <<1)+ 1)];
            }
            //---------------------------------------------------------
            if (music_break)          //断奏
                {
                music_delay(music_l_tab[music_long&0x07]-1);
                temp_TH1=0xff;
                temp_TL1=0xea;
                music_delay(1);
            }
            else                      //连奏
                music_delay(music_l_tab[music_long&0x07]);
        }
        //---------------------------------------------------------
        else                          //是功能码
            {
            switch(music_data)
                {
                case 0x04:
                    music_up=0;       //不升半音
                    break;
                case 0x05:
                    music_up=1;       //升半音
                    break;
                case 0x06:
                    music_break=0;    //断奏
                    break;
                case 0x07:
                    music_break=1;    //连奏
                    break;
                default:
                    break;
            }
        }
        //---------------------------------------------------------
        msc++;
    }
    ET1=0;                           //播放结束,关T1中断
    PIN_MSC=1;                       //关输出
//    temp_TH1=0xff;
//    temp_TL1=0xea;                 //关输出(输出超声波)
//    ET0=1;                         //开T0定时器中断
//    TMOD=0x51;                     //T0：16位定时器、T1：16位计数器
}

//---------------------------------------------------------------------------//
void main(void)                      //示例
{
    //    设置定时器--------------------------------------
        TMOD   =  0x11;         // TMOD: 定时器1:模式1:16位;定时器2:模式1:16位   //
//        TCON   =  0x50;       // TCON: 定时器 1运行;      定时器 2运行         //
    //    设置并开启中断:
        IP  = 0x08;             //中断优先寄存器IP:|D7_x |x|x|PS|PT1|PX1|PT0|D0_PX0|//
        IE  = 0x88;             //中断允许寄存器IE:|D7_EA|x|ET2|ES|ET1|EX1|ET0|D0_EX0|//
   for (;;) {
      //在此调用键盘和显示函数//
      music_play(music_tab1);
      music_play(music_tab2);
      music_play(music_tab3);
      music_play(music_tab4);
   }
}
//---------------------------------------------------------------------------//

