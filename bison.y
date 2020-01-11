/*
 * Lexical analizer for the chosen language.
 * Reads symbols from an input file an processes them.
 */

%{

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
							sprintf(tmp, "%s dw 1\n", $2);
							addTempToDS(tmp);
							free(tmp);
						}
					| tip ID SEMICOLON lista_declaratii
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							sprintf(tmp, "%s dw 1\n", $2);
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
							sprintf(tmp, "mov ax, %s\n", $3.varn);
							addTempToCS(tmp);
							sprintf(tmp, "mov %s, ax\n", $1);
							addTempToCS(tmp);
							free(tmp);
						}
					;

expresie: termen
			| termen PLUS termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$.varn, temp); 
					
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "add ax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov %s, ax\n", temp);
					addTempToCS(tmp);
				}
			| termen MINUS termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
								
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "sub ax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov %s, ax\n", temp);
					addTempToCS(tmp);
				}
			| termen MULTIPLY termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mul ax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov %s, ax\n", temp);
					addTempToCS(tmp);
				}
			| termen DIVIDE termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
							
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ax, %s\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "div ax, %s\n", $3.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov %s, ax\n", temp);
					addTempToCS(tmp);
				}
			;
			  
instr_io: WRITE LEFT_BRACKET ID RIGHT_BRACKET SEMICOLON
	{
		char *tmp = (char *)malloc(sizeof(char)*100);
		addTempToCS(moveVarToPrintBuffer($3));
		sprintf(tmp, "mov dx, offset buffer\nmov al, 09h\nint 21h\n");
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
					strcpy($$.varn, $1); 
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

	//open the file in read mode
	FILE *f = fopen("in.in", "r");
	if(!f) {
		perror("Could not open file!");
		exit(1);
	}
	//set the input for the flex file
	yyin = f;
	//read each line from the input file and process it
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
	char *assume = (char *) malloc(sizeof(char)*30);
	char *beginDS = (char *) malloc(sizeof(char)*20);
	char *printBuffer = (char *) malloc(sizeof(char)*100);
	char *endDS = (char *) malloc(sizeof(char)*20);
	char *beginCS = (char *) malloc(sizeof(char)*20);
	char *start = (char *) malloc(sizeof(char)*10);
	char *endCS = (char *) malloc(sizeof(char)*30);
	char *init_code = (char *) malloc(sizeof(char)*30);
	char *end_code = (char *) malloc(sizeof(char)*30);
	
	sprintf(assume, "assume cs:code, ds:data\n");
	sprintf(beginDS, "data SEGMENT\n");
	sprintf(printBuffer, "buffer dw 100\n");
	sprintf(endDS, "data ENDS\n");
	sprintf(beginCS, "code SEGMENT\n");
	sprintf(start, "start:\n");
	sprintf(endCS, "code ENDS\nEND start");
	sprintf(init_code, "mov ax, data\nmov ds, ax\n");
	sprintf(end_code, "mov ax, 4C00h\nint 21h\n");

	FILE *f = fopen("out.out", "w");
	if(f == NULL) {
		perror("Mayday -> file out.out has failed.");
		exit(1);
	}
	fwrite(assume, strlen(assume), 1, f);
	fwrite(beginDS, strlen(beginDS), 1, f);
	fwrite(printBuffer, strlen(printBuffer), 1, f);
	fwrite(DS, strlen(DS), 1, f);
	fwrite(endDS, strlen(endDS), 1, f);
	fwrite(beginCS, strlen(beginCS), 1, f);
	fwrite(start, strlen(start), 1, f);
	fwrite(init_code, strlen(init_code), 1, f);
	fwrite(CS, strlen(CS), 1, f);
	fwrite(end_code, strlen(end_code), 1, f);
	fwrite(endCS, strlen(endCS), 1, f);

	fclose(f);
	free(assume);
	free(beginDS);
	free(endDS);
	free(beginCS);
	free(start);
	free(init_code);
	free(end_code);
	free(endCS);
}


void newTempName(char *s) {
	sprintf(s, "temp%d dw 1\n", tempnr);
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