bits 32

global start

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
read_int_msg db "n=", 0
int_format db "%d", 10, 0
c dd 0
b dd 0
a dd 0
temp1 dd 0

segment code use32 class=code
start:
; a = 2
mov eax, 2
mov [a], eax
; 10 + 2
mov eax, 10
add eax, 2
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
; exit(0)
push dword 0
call [exit]
