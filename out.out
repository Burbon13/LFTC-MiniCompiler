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
temp2 dd 0
temp3 dd 0
temp4 dd 0
temp5 dd 0
temp6 dd 0

segment code use32 class=code
start:
; a = 2
mov eax, 2
mov [a], eax
; b = 3
mov eax, 3
mov [b], eax
; [a] + [b]
mov eax, [a]
add eax, [b]
mov [temp1], eax
; c = temp1
mov eax, [temp1]
mov [c], eax
; [c] * 10
mov eax, [c]
mov ebx, 10
imul ebx
mov [temp2], eax
; d = temp2
mov eax, [temp2]
mov [d], eax
; [d] - 1
mov eax, [d]
sub eax, 1
mov [temp3], eax
; e = temp3
mov eax, [temp3]
mov [e], eax
; [e] / 2
mov edx, 0
mov eax, [e]
mov ebx, 2
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
push dword read_int_msg
call [printf]
add esp, 4 * 1
push dword a
push dword read_int_f
call [scanf]
 add esp, 4 * 2; 100 * [a]
mov eax, 100
mov ebx, [a]
imul ebx
mov [temp5], eax
; a = temp5
mov eax, [temp5]
mov [a], eax
; print(a)
mov eax, [a]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
push dword read_int_msg
call [printf]
add esp, 4 * 1
push dword b
push dword read_int_f
call [scanf]
 add esp, 4 * 2; print(b)
mov eax, [b]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; [b] + 22
mov eax, [b]
add eax, 22
mov [temp6], eax
; b = temp6
mov eax, [temp6]
mov [b], eax
; print(b)
mov eax, [b]
push dword eax
push dword int_format
call [printf]
add esp, 4 * 2
; exit(0)
push dword 0
call [exit]
