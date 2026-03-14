.386
.model flat, stdcall
.stack 4096

.data

X  WORD 0CD5Bh        
Y  WORD 0E742h        
Z  WORD 09138h        

MASK1 WORD 0C621h     

X1 WORD ?             
Y1 WORD ?             
Z1 WORD ?             

M WORD ?              
R WORD ?              

.code

main PROC

mov ax,X
xor ax,MASK1
mov X1,ax

mov ax,Y
xor ax,MASK1
mov Y1,ax

mov ax,Z
xor ax,MASK1
mov Z1,ax

mov ax,X1
sub ax,Y1
add ax,Z1
mov M,ax

mov ax,M
cmp ax,19A8h
jb SUBR1

call SUB2
jmp CHECK

SUBR1:
call SUB1

CHECK:
mov ax,R
test ax,8000h
jnz ADR1
jmp ADR2

ADR1:
mov ax,R
xchg ah,al
mov R,ax
jmp FINISH

ADR2:
mov ax,R
dec ax
mov R,ax

FINISH:
ret

main ENDP


; подпрограмма 1
SUB1 PROC
mov ax,M
rol ax,5
mov R,ax
ret
SUB1 ENDP


; подпрограмма 2
SUB2 PROC
mov ax,M
and ax,9238h
mov R,ax
ret
SUB2 ENDP


END main