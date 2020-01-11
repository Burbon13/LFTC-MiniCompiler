/*
 * Lexical analizer for the chosen language.
 * Matches each word to a regex.
 */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "attrib.h"
#include "bison.tab.h"

extern int lineno;  /* defined in bison */



%}


id						([a-zA-Z]+[0-9]*)
const_int			([0-9]|[1-9][0-9]+)
const_real			(([0])|([1-9][0-9]*\.[0-9]*[1-9]+)|([0]\.[0-9]*[1-9]+))
const				({const_int}|{const_real})

%option noyywrap

%%

begin_program	{ printf("%s\n", yytext); return BEGIN_PROGRAM; }
end_program		{ printf("%s\n", yytext); return END_PROGRAM; }
begin_block		{ printf("%s\n", yytext); return BEGIN_BLOCK; }
end_block			{ printf("%s\n", yytext); return END_BLOCK; }
int					{ printf("%s ", yytext); return  INT; }
real					{ printf("%s ", yytext); return REAL; }
array_int			{ printf("%s ", yytext); return ARRAY_INT; }
array_real			{ printf("%s ", yytext); return ARRAY_REAL; }
"="					{ printf("%s ", yytext); return ASSUME; }
"("					{ printf("%s ", yytext); return LEFT_BRACKET; }
")"					{ printf("%s ", yytext); return RIGHT_BRACKET; }
"+"					{ printf("%s ", yytext); return PLUS; }
"-"					{ printf("%s ", yytext); return MINUS; }
"*"					{ printf("%s ", yytext); return  MULTIPLY; }
"/"					{ printf("%s ", yytext); return DIVIDE; }
read					{ printf("%s ", yytext); return READ; }
write					{ printf("%s ", yytext); return WRITE; }
if						{ printf("%s ", yytext); return IF; }
else					{ printf("%s ", yytext); return ELSE; }
"!="					{ printf("%s ", yytext); return NE; }
">"					{ printf("%s ", yytext); return GT; }
"<"					{ printf("%s ", yytext); return LT; }
"=="					{ printf("%s ", yytext); return EQ; }
">="					{ printf("%s ", yytext); return GE;}
"<="					{ printf("%s ", yytext); return LE;}
while					{ printf("%s ", yytext); return WHILE; }
"&"					{ printf("%s ", yytext); return AND; }
"["					{ printf("%s ", yytext); return SQUARE_LEFT_BRACKET; }
"]"					{ printf("%s ", yytext); return SQUARE_RIGHT_BRACKET; }
";"					{ printf("%s\n", yytext); return SEMICOLON; }
","					{ printf("%s ", yytext); return COMMA; }

[ \t\r]*				{/*Do nothing for whitespaces*/}
[\n]            		{ lineno++; }

{id}					{ printf("%s ", yytext); strcpy(yylval.varname,yytext); return ID;}
{const}				{ printf("%s ", yytext); strcpy(yylval.varname,yytext); return CONST;}


%	
