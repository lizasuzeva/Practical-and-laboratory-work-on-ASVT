#include <8051.h>

unsigned char duty;      // ?????????? (%)
unsigned char cnt;       // ??????? ???????
bit up_pressed;
bit down_pressed;

void delay_ms(unsigned int ms) {
    unsigned int i, j;
    for(i = 0; i < ms; i++)
        for(j = 0; j < 120; j++);
}

void main(void) {
    duty = 65;   // ????? = 65%
    cnt = 0;
    up_pressed = 0;
    down_pressed = 0;

    P1 = 0xFF;   

    // === Timer 0 ===
    TMOD = 0x01;   // ????? 1 (16 ???)

    TH0 = 0xFD;
    TL0 = 0x8F;

    TR0 = 1;       // ?????? ???????

    while(1) {

        // === ??? ??? ===
        if(TF0 == 1) {
            TF0 = 0;

            TH0 = 0xFD;
            TL0 = 0x8F;

            // ???????????? ???
            if(cnt < duty)
                P1 |= 0x01;   // HIGH
            else
                P1 &= 0xFE;   // LOW

            cnt++;
            if(cnt >= 100) cnt = 0;
        }

        // ===== ?????? + =====
        if((P1 & 0x02) == 0) {
            if(up_pressed == 0) {
                delay_ms(20);
                if((P1 & 0x02) == 0) {
                    if(duty < 65)
                        duty += 5;
                    up_pressed = 1;
                }
            }
        } else up_pressed = 0;

        // ===== ?????? - =====
        if((P1 & 0x04) == 0) {
            if(down_pressed == 0) {
                delay_ms(20);
                if((P1 & 0x04) == 0) {
                    if(duty > 25)
                        duty -= 5;
                    down_pressed = 1;
                }
            }
        } else down_pressed = 0;
    }
}