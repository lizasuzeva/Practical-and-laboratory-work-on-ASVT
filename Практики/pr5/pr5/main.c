// ===== ????? =====
#define P0 (*((volatile unsigned char*)0x80))
#define P1 (*((volatile unsigned char*)0x90))
#define P2 (*((volatile unsigned char*)0xA0))

// ===== ??????-?????? =====
unsigned int timer = 0;

// ===== LCD =====
void lcd_enable() {
    P2 |= 0x01;
    P2 &= ~0x01;
}

void lcd_cmd(unsigned char cmd) {
    P0 = cmd;
    P2 &= ~0x02;
    P2 &= ~0x04;
    lcd_enable();
}

void lcd_data(unsigned char dat) {
    P0 = dat;
    P2 |= 0x02;
    P2 &= ~0x04;
    lcd_enable();
}

void lcd_init() {
    lcd_cmd(0x38);
    lcd_cmd(0x0C);
    lcd_cmd(0x06);
    lcd_cmd(0x01);
}

void lcd_string(char *s) {
    while(*s) lcd_data(*s++);
}


// ===== ?????????? =====
char get_key() {

    unsigned char val;

    P1 = 0xEF;
    val = P1 & 0x0F;
    if(val != 0x0F) {
        if(val == 0x0E) return '1';
        if(val == 0x0D) return '4';
        if(val == 0x0B) return '7';
        if(val == 0x07) return '*';
    }

    P1 = 0xDF;
    val = P1 & 0x0F;
    if(val != 0x0F) {
        if(val == 0x0E) return '2';
        if(val == 0x0D) return '5';
        if(val == 0x0B) return '8';
        if(val == 0x07) return '0';
    }

    P1 = 0xBF;
    val = P1 & 0x0F;
    if(val != 0x0F) {
        if(val == 0x0E) return '3';
        if(val == 0x0D) return '6';
        if(val == 0x0B) return '9';
        if(val == 0x07) return '#';
    }

    P1 = 0x7F;
    val = P1 & 0x0F;
    if(val != 0x0F) {
        if(val == 0x0E) return 'A';
        if(val == 0x0D) return 'B';
        if(val == 0x0B) return 'C';
        if(val == 0x07) return 'D';
    }

    return 0;
}


// ===== MAIN =====
void main() {

    char key;
    char last_key = 0;
    unsigned char pos = 0;

    lcd_init();
    lcd_string("Calculator:");
    lcd_cmd(0xC0);

    while(1) {

        key = get_key();

        // "??????" ????????????? ?????????
        timer++;

        // ???? ????? ?????? ? ?????? ?????
        if(key != 0 && key != last_key && timer > 10) {

            if(pos < 16) {
                lcd_data(key);
                pos++;
            }

            last_key = key;
            timer = 0; // ????? ???????
        }

        if(key == 0) {
            last_key = 0;
        }
    }
}