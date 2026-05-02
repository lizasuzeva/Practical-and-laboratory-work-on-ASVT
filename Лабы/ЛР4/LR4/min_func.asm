.586                            
.MODEL flat, C                  

.DATA
    min_val     DD 0.0          ; текущее минимальное значение функции
    curr_x      DD 0.0          ; текущая точка x (аргумент функции)

.CODE
    EXTERN func:NEAR             ; внешняя функция из C-модуля (вычисляет f(x))
    PUBLIC FindMin               ; делаем функцию видимой для C++ модуля

FindMin PROC C

    push ebp                    ; сохраняем старый базовый указатель
    mov  ebp, esp               ; устанавливаем новый базовый указатель
                                ; теперь параметры доступны через [ebp+8], [ebp+12] и т.д.

    ; min_val = f(start)        ;вычисляем значение в начальной точке
    push dword ptr [ebp+8]      ; помещаем start в стек (аргумент для func)
    call func                   ; вызываем C-функцию func(start)
    add  esp, 4                 ; очищаем стек после вызова (убираем аргумент)
    fstp min_val                ; сохраняем результат из ST(0) в переменную min_val

    ; curr_x = start + step     переходим к следующей точке
    fld  dword ptr [ebp+8]      ; загружаем start в FPU (ST(0) = start)
    fadd dword ptr [ebp+16]     ; прибавляем step (ST(0) = start + step)
    fst  curr_x                 ; сохраняем результат в curr_x

; === ОСНОВНОЙ ЦИКЛ ПЕРЕБОРА ТОЧЕК ===
loop_start:

    ; === ПРОВЕРКА УСЛОВИЯ ВЫХОДА ИЗ ЦИКЛА ===
    ; if (curr_x > end) goto finish
    fld  curr_x                 ; загружаем curr_x в ST(0)
    fld  dword ptr [ebp+12]     ; загружаем end в ST(0), curr_x в ST(1)
    fcompp                      ; сравниваем ST(0) и ST(1), выталкиваем оба из стека
    fstsw ax                    ; сохраняем состояние FPU в регистр AX
    sahf                        ; загружаем флаги из AH в EFLAGS
    ja   finish                 ; если curr_x > end, выходим из цикла

    ; === ПРОВЕРКА НА X = 0 (ЗАЩИТА ОТ ДЕЛЕНИЯ НА НОЛЬ) ===
    ; пропускаем точку x = 0, так как sin(0)=0 -> деление на ноль
    fld  curr_x                 ; загружаем curr_x в ST(0)
    fldz                        ; загружаем 0.0 в ST(0), curr_x в ST(1)
    fcompp                      ; сравниваем curr_x с 0.0
    fstsw ax
    sahf
    je   next_point             ; если curr_x == 0, переходим к следующей точке

    ; === ВЫЗОВ C-ФУНКЦИИ ДЛЯ ВЫЧИСЛЕНИЯ f(curr_x) ===
    push dword ptr curr_x       ; помещаем curr_x в стек (аргумент для func)
    call func                   ; вызываем C-функцию func(curr_x)
    add  esp, 4                 ; очищаем стек после вызова
                                ; результат теперь в регистре ST(0)

    ; === СРАВНЕНИЕ f(curr_x) С ТЕКУЩИМ МИНИМУМОМ ===
    fld  min_val                ; загружаем min_val в ST(0), f(x) в ST(1)
    fcompp                      ; сравниваем min_val и f(x), выталкиваем оба
    fstsw ax
    sahf
    jnb  next_point             ; если f(x) >= min_val, переходим к следующей точке

    ; === ОБНОВЛЕНИЕ МИНИМУМА ===
    ; если дошли сюда, значит f(x) < min_val -> нужно обновить минимум
    push dword ptr curr_x       ; помещаем curr_x в стек
    call func                   ; вызываем func(curr_x) повторно
    add  esp, 4                 ; очищаем стек
    fstp min_val                ; сохраняем новое минимальное значение

; === ПЕРЕХОД К СЛЕДУЮЩЕЙ ТОЧКЕ ===
next_point:
    ; curr_x = curr_x + step
    fld  curr_x                 ; загружаем curr_x в ST(0)
    fadd dword ptr [ebp+16]     ; прибавляем step (ST(0) = curr_x + step)
    fst  curr_x                 ; сохраняем новое значение
    jmp  loop_start             ; переходим к следующей итерации цикла

; === ЭПИЛОГ ФУНКЦИИ ===
finish:
    fld  min_val                ; загружаем минимальное значение в ST(0)
                                ; (оно будет возвращено в вызывающую функцию main)

    pop  ebp                    ; восстанавливаем старый базовый указатель
    ret                         ; возврат в C++ программу (main.cpp)

FindMin ENDP
END                             ; конец модуля