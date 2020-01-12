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
; a = 20
mov eax, 20
mov [a], eax
; b = 5
mov eax, 5
mov [b], eax
; 100 + [b]
mov eax, 100
add eax, [b]
mov [temp1], eax
; c = temp1
mov eax, [temp1]
mov [c], eax
; print(c)
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; 100 - [b]
mov eax, 100
sub eax, [b]
mov [temp2], eax
; c = temp2
mov eax, [temp2]
mov [c], eax
; print(c)
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; 100 * [b]
mov eax, 100
mov ebx, [b]
imul ebx
mov [temp3], eax
; c = temp3
mov eax, [temp3]
mov [c], eax
; print(c)
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; 100 / [b]
mov edx, 0
mov eax, 100
mov ebx, [b]
idiv ebx
mov [temp4], eax
; c = temp4
mov eax, [temp4]
mov [c], eax
; print(c)
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; exit(0)
push dword 0
call [exit]
