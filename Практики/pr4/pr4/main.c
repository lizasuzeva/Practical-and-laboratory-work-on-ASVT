#include <8051.h>

void msec(int x) // ???????? ?? 10 ??
{
    while(x-->0)
    {
        TH0 = (-10000)>>8;
        TL0 = -10000;

        TR0 = 1;

        while(TF0 == 0);

        TF0 = 0;
        TR0 = 0;
    }
}

void delay_sec(int s)
{
    while(s--)
        msec(100);   // 100 ? 10?? = 1 ???
}

void main()
{
    TMOD = 0x01;   // ?????? 0, ????? 1

    while(1)
    {
        P1 = 0x06;   // LED2 + LED3
        delay_sec(1);

        P1 = 0x60;   // LED6 + LED7
        delay_sec(1);

        P1 = 0x01;   // LED1
        delay_sec(3);

        P1 = 0x18;   // LED4 + LED5
        delay_sec(5);

        P1 = 0x80;   // LED8
        delay_sec(7);
    }
}