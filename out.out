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

segment code use32 class=code
start:
mov eax, 3
mov [a], eax
mov eax, 5
mov [b], eax
mov eax, 10
mov [c], eax
mov eax, [a]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
mov eax, [b]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
mov eax, [c]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
push dword 0
call [exit]
