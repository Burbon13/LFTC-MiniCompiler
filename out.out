bits 32

global start

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
read_int_msg db ">>", 0
int_format db "%d", 10, 0
read_int_f db "%d", 0
e dd 0
d dd 0
c dd 0
b dd 0
a dd 0
temp1 dd 0

segment code use32 class=code
start:
push dword read_int_msg
call [printf]
add esp, 4 * 1
push dword a
push dword read_int_f
call [scanf]
 add esp, 4 * 2; print(a)
mov eax, [a]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; [a] + 4
mov eax, [a]
add eax, 4
mov [temp1], eax
; a = temp1
mov eax, [temp1]
mov [a], eax
; print(a)
mov eax, [a]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; exit(0)
push dword 0
call [exit]
