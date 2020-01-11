@echo off
win_bison -d bison.y
win_flex flex.lex
gcc bison.tab.c lex.yy.c -o result.exe -lm
result.exe
pause