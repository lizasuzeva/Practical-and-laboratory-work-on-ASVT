$MOD51
org 00h
clr P1.0
mov dptr, #800h    
mov r2, #04h        
mov r3, #00h        

test_page:
    mov r3, #00h    
    
test_byte:
    mov a, #0AAh    
    movx @dptr, a   
    movx a, @dptr   
    
    xrl a, #0AAh    
    jnz error       
    
    inc dptr        
    djnz r3, test_byte 
    djnz r2, test_page 
    
    sjmp $          

error:
    setb p1.0       
    sjmp $          

END