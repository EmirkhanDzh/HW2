; Äæàïàðîâ Ýìèðõàí Ìàéðàìáåêîâè÷, ÁÏÈ197
; Ìàññèâ èç ýëåìåíòîâ A, çíà÷åíèå êîòîðûõ íå ñîâïàäàåò ñ ïåðâûì è ïîñëåäíèì ýëåìåíòàìè A
format PE console
entry start
 
include 'win32a.inc'
;--------------------------------------------------------------------------
section '.data' data readable writable
 
        strVecSize   db 'Enter vector size: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strScanInt db '%d', 0
        strOutputTitle db 'Positive elements of vector: ', 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        titleVecA db 'Initial vector:',10, 0
        titleVecB db 'Vector of massive B:',10, 0
 
        firstEl dd ?
        lastEl dd ?
 
 
        vecA_size dd 0
        vecB_size dd 0
 
        vec rd 100
        vec2 rd 100
 
        tmpStack dd ?
        tmp dd ?
        i dd ?
        num dd ?
;--------------------------------------------------------------------------
 
section '.code' code readable executable
start:
; 1)vector input
  call VectorInput
; 2) search number of positive
  call SearchPositive
; 3) output initial vector A
  call VectorOut
; 4) output new vector B
  call ChangedVectorOut
 
finish:
        call [getch]
 
        push 0
        call [ExitProcess]
;--------------------------------------------------------------------------
VectorOut:
        push titleVecA
        call [printf]
        add esp, 4
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vecA_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx
 
        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]
 
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------
ChangedVectorOut:
        push titleVecB
        call [printf]
        add esp, 4
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec2            ; ebx = &vec
putChangedVecLoop:
        mov [tmp], ebx
        cmp ecx, [vecB_size]
        je endOutputChangedVector      ; to end of loop
        mov [i], ecx
 
        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]
 
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putChangedVecLoop
endOutputChangedVector:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------
; ???? ?????? ????????????? ???????? ??????? ?
SearchPositive:
        xor ecx, ecx
        mov ebx, vec + 4
        mov eax, vec2
SearchLoop:
        mov edx, [vecA_size]
        sub edx, 1
        sub edx, 1
        cmp ecx, edx
        je endSearchPositive
        mov [i], ecx
        mov edx, dword [ebx]
        mov [num], edx
        ; ? ?????? ????? ????? ?????? ???? -- ???? ?? ?????
        jmp  AddPositiveElement
AddPositiveElement:
        inc [vecB_size]
        mov [tmp], eax
        mov [eax], edx
        mov eax, [tmp]
        add eax, 4
        ; standart
        mov ecx, [i]
        inc ecx
        add ebx, 4
        jmp SearchLoop
endSearchPositive:
        ret
;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4
 
        push vecA_size
        push strScanInt
        call [scanf]
        add esp, 8
 
        mov eax, [vecA_size]
 
        cmp eax, 0
        jg  getVector
; fail size
        push [vecA_size]
        push strIncorSize
        call [printf]
        jmp finish
; else continue...
getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vecA_size]
        jge endInputVector       ; to end of loop
 
        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8
 
        push ebx
        push strScanInt
        call [scanf]
        add esp, 8
        mov edx, dword [ebx]
        cmp [i], 0
        jne first
        mov [firstEl], edx
        first:
 
        mov eax, [vecA_size]
        sub eax, 1
        cmp [i], eax
        jne last
        mov [lastEl], edx
        last:
 
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
 
;--------------------------------------------------------------------------
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'
 
    import kernel,\
           ExitProcess, 'ExitProcess'
 
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
