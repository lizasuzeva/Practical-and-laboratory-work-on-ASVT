.386
.model flat, stdcall
option casemap:none

.stack 4096

.data
N equ 5

Rect STRUCT
    a dq ?
    b dq ?
    s dq ?
Rect ENDS

rects Rect <2.0, 3.0, 0.0>,
             <1.0, 2.0, 0.0>,
             <4.0, 1.0, 0.0>,
             <3.0, 5.0, 0.0>,
             <5.0, 2.0, 0.0>

temp dq ?

.code
main PROC

    mov ecx, N
    xor esi, esi

calc_loop:
    fld qword ptr rects[esi].a
    fmul qword ptr rects[esi].b
    fstp qword ptr rects[esi].s

    add esi, 24
    dec ecx
    jnz calc_loop

    mov ecx, N

outer_loop:
    push ecx
    mov ecx, N-1
    xor esi, esi

inner_loop:

    fld qword ptr rects[esi].s
    fld qword ptr rects[esi+24].s
    fcomip st(0), st(1)
    fstp st(0)

    jae no_swap

    ; swap a
    fld qword ptr rects[esi].a
    fstp qword ptr temp

    fld qword ptr rects[esi+24].a
    fstp qword ptr rects[esi].a

    fld qword ptr temp
    fstp qword ptr rects[esi+24].a

    ; swap b
    fld qword ptr rects[esi].b
    fstp qword ptr temp

    fld qword ptr rects[esi+24].b
    fstp qword ptr rects[esi].b

    fld qword ptr temp
    fstp qword ptr rects[esi+24].b

    ; swap s
    fld qword ptr rects[esi].s
    fstp qword ptr temp

    fld qword ptr rects[esi+24].s
    fstp qword ptr rects[esi].s

    fld qword ptr temp
    fstp qword ptr rects[esi+24].s

no_swap:
    add esi, 24

    dec ecx
    jnz inner_loop

    pop ecx
    dec ecx
    jnz outer_loop

    ret
main ENDP

END main