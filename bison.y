/*
 * Lexical analizer for the chosen language.
 * Reads symbols from an input file an processes them.
 */

%{

#include <ctype.h>
#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include "attrib.h"

int  lineno = 1; /* number of current source line */

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;

void yyerror(char *s);

//the variable containing the DataSegment for the assembly program
char DS[1000];

//the variable containing the CodeSegment for the assembly program
char CS[1000];

//add variables to DataSegment
void addTempToDS(char *s);

//add assembly code to CodeSegment
void addTempToCS(char *s);

char* moveVarToPrintBuffer(char *s);

//write the assembly code to file
void writeAssemblyToFile();

//counter for the temp variables
int tempnr = 1;
//create a new temp variable and add it to DS
void newTempName(char *s);

%}

%union {
	char varname[10];
	attributes attrib;
}


%token BEGIN_PROGRAM
%token END_PROGRAM
%token BEGIN_BLOCK
%token END_BLOCK
%token INT
%token REAL
%token ARRAY_INT
%token ARRAY_REAL
%token READ
%token WRITE
%token IF
%token ELSE
%token WHILE
%token NE
%token GT
%token LT
%token EQ
%token GE
%token LE
%token ASSUME
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token AND
%token SEMICOLON
%token COMMA
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token SQUARE_LEFT_BRACKET
%token SQUARE_RIGHT_BRACKET


%token <varname> ID
%token <varname> CONST 
%type <attrib> expresie
%type <attrib> termen


%%
	
program: BEGIN_PROGRAM lista_declaratii BEGIN_BLOCK lista_instr END_BLOCK END_PROGRAM
			;

lista_declaratii: tip ID SEMICOLON
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							sprintf(tmp, "%s dd 0\n", $2);
							addTempToDS(tmp);
							free(tmp);
						}
					| tip ID SEMICOLON lista_declaratii
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							sprintf(tmp, "%s dd 0\n", $2);
							addTempToDS(tmp);
							free(tmp);
						}
					;

tip: INT
	| REAL
	;
	
lista_instr: instr 
		| instr lista_instr
		;
				
instr: instr_atribuire
	| instr_io
	;

instr_atribuire: ID ASSUME expresie SEMICOLON		
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							//expression result is in temp, so we move it into ID
							sprintf(tmp, "; %s = %s\n", $1, $3);
							addTempToCS(tmp);
							if(isdigit($3.varn[0])) {
								sprintf(tmp, "mov eax, %s\n", $3.varn);
							} 
							else {
								sprintf(tmp, "mov eax, [%s]\n", $3.varn);
							}
							addTempToCS(tmp);
							sprintf(tmp, "mov [%s], eax\n", $1);
							addTempToCS(tmp);
							free(tmp);
						}
					;

expresie: termen
			| termen PLUS termen
				{
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					sprintf($$.varn, "%s", temp); 
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "; %s + %s\n", $1, $3);
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "add eax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen MINUS termen
				{
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					sprintf($$.varn, "%s", temp);
								
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "; %s - %s\n", $1, $3);
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "sub eax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen MULTIPLY termen
				{
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					sprintf($$.varn, "%s", temp);
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "; %s * %s\n", $1, $3);
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov ebx, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "imul ebx\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen DIVIDE termen
				{
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					sprintf($$.varn, "%s", temp);
							
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "; %s / %s\n", $1, $3);
					addTempToCS(tmp);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov ebx, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "idiv ebx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			;
			  
instr_io: WRITE LEFT_BRACKET ID RIGHT_BRACKET SEMICOLON
	{
		char *tmp = (char *)malloc(sizeof(char)*100);
		sprintf(tmp, "; print(%s)\nmov eax, [%s]\npush dword eax\npush dword int_format\ncall [printf]\nadd esp, 4 * 2\n", $3, $3);
		addTempToCS(tmp);
	}	
	| READ LEFT_BRACKET termen RIGHT_BRACKET SEMICOLON	
	{
		char *tmp = (char *)malloc(sizeof(char)*100);
		sprintf(tmp, "mov ah, 0Ah\nmov dx, offset %s\nint 21h\n", $3.varn);
		addTempToCS(tmp);
	}
	;

 
termen: ID			
				{
					strcpy($$.cod, "");
					sprintf($$.varn, "[%s]", $1); 
				}
		| CONST	
			{
				strcpy($$.cod, "");
				strcpy($$.varn, $1); 
			}
		;
			
%%

int main(int argc, char *argv[]) {	
	memset(DS, 0, 1000);
	memset(CS, 0, 1000);

	FILE *f = fopen("in.in", "r");
	if(!f) {
		perror("Could not open file!");
		exit(1);
	}
	yyin = f;
	while(!feof(yyin)) {
		yyparse();
	}

	writeAssemblyToFile();
	
	return 0;
}


void addTempToDS(char *s) {
	strcat(DS, s);		
}


void addTempToCS(char *s) {
	strcat(CS, s);
}

char *moveVarToPrintBuffer(char *s) {
	char *temp = (char*)malloc(sizeof(char)*200);
	sprintf(temp, "mov bx, %s\nmov buffer, bx\nmov buffer+2, '$'\n", s);
	return temp;

}

void writeAssemblyToFile() {
	char *bits32 = (char *) malloc(sizeof(char)*30);
	char *globalStart = (char *) malloc(sizeof(char)*20);
	char *imports = (char *) malloc(sizeof(char)*100);
	char *dataSegment = (char *) malloc(sizeof(char)*100);
	char *beginCS = (char *) malloc(sizeof(char)*20);
	char *start = (char *) malloc(sizeof(char)*10);
	char *endCS = (char *) malloc(sizeof(char)*30);
	char *init_code = (char *) malloc(sizeof(char)*30);
	char *end_code = (char *) malloc(sizeof(char)*30);
	
	sprintf(bits32, "bits 32\n\n");
	sprintf(globalStart, "global start\n\n");
	sprintf(imports, "extern exit, printf, scanf\nimport exit msvcrt.dll\nimport printf msvcrt.dll\nimport scanf msvcrt.dll\n\n");
	sprintf(dataSegment, "segment data use32 class=data\nread_int_msg db \"n=\", 0\nint_format db \"%s\", 10, 0\n", "%d");
	sprintf(beginCS, "\nsegment code use32 class=code\n");
	sprintf(start, "start:\n");
	sprintf(endCS, "; exit(0)\npush dword 0\ncall [exit]\n");

	FILE *f = fopen("out.out", "w");
	if(f == NULL) {
		perror("Mayday -> file out.out has failed.");
		exit(1);
	}
	fwrite(bits32, strlen(bits32), 1, f);
	fwrite(globalStart, strlen(globalStart), 1, f);
	fwrite(imports, strlen(imports), 1, f);
	fwrite(dataSegment, strlen(dataSegment), 1, f);
	fwrite(DS, strlen(DS), 1, f);
	fwrite(beginCS, strlen(beginCS), 1, f);
	fwrite(start, strlen(start), 1, f);
	fwrite(CS, strlen(CS), 1, f);
	fwrite(endCS, strlen(endCS), 1, f);

	fclose(f);
	free(bits32);
	free(globalStart);
	free(dataSegment);
	free(imports);
	free(beginCS);
	free(start);
	free(endCS);
}


void newTempName(char *s) {
	sprintf(s, "temp%d dd 0\n", tempnr);
	addTempToDS(s);
	sprintf(s, "temp%d", tempnr);
	tempnr++;
}


void yyerror(char *s) {
	printf("\n \n \nMy error: \n");
	printf( "Syntax error on line #%d: %s\n", lineno, s);
	printf( "Last token was \"%s\"\n", yytext);
	exit(1);
}
