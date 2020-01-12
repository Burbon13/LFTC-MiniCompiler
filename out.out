bits 32

global start

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
read_int_msg db "n=", 0
int_format db "%d", 10, 0
e dd 0
d dd 0
c dd 0
b dd 0
a dd 0
temp1 dd 0
temp2 dd 0
temp3 dd 0
temp4 dd 0

segment code use32 class=code
start:
; a = 1
mov eax, 1
mov [a], eax
; 2 + 3
mov eax, 2
add eax, 3
mov [temp1], eax
; b = temp1
mov eax, [temp1]
mov [b], eax
; 10 - 4
mov eax, 10
sub eax, 4
mov [temp2], eax
; c = temp2
mov eax, [temp2]
mov [c], eax
; 3 * 7
mov eax, 3
mov ebx, 7
imul ebx
mov [temp3], eax
; d = temp3
mov eax, [temp3]
mov [d], eax
; 60 / 4
mov edx, 0
mov eax, 60
mov ebx, 4
idiv ebx
mov [temp4], eax
; e = temp4
mov eax, [temp4]
mov [e], eax
; print(a)
mov eax, [a]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; print(b)
mov eax, [b]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; print(c)
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; print(d)
mov eax, [d]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; print(e)
mov eax, [e]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; exit(0)
push dword 0
call [exit]
