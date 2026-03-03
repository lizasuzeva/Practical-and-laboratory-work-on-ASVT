.686
.model flat, stdcall
.stack 100h

ExitProcess PROTO STDCALL :DWORD

.data
    X   dd  -15
    Y   dd   5
    Z   dd   3
    M   dd   ?
    two dd 2

.code
Start:

    mov ebx, X
    xor ebx, 0Fh          ; EBX = X'

    mov eax, Z
    mov edx, 0
    idiv two              ; EAX = Z/2

    imul ebx, Y           ; EBX = X'*Y
    add eax, ebx

    mov ebx, X
    xor ebx, 0Fh          ; EBX = X'
    mov eax, Z
    xor eax, 0Fh          ; EAX = Z'
    and ebx, eax          ; EBX = X' AND Z'

    add eax, ebx          ; итог

    mov M, eax

    invoke ExitProcess, 0

END Start



