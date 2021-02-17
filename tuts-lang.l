%{
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

int errorQty = 0;
int currentLine = 1;

struct Error {
    char error_symbol;
    int line;
};

struct Error errorArray[500];
/*
void printError(){
    if(errorQty > 0) {
        printf("\n\n\n------ERROS LEXICOS: %d--------\n", errorQty);
        for(int i = 0; i < errorQty; i++) {
            char* msg =  (char *)malloc(100 * sizeof(char));
            sprintf(msg, "Symbol not recognized: %c. line: %d\n", errorArray[i].error_symbol, errorArray[i].line);
            yyerror(msg);
        }
    }
}
*/
%}
%option noyywrap
%option noinput nounput
EOL \n
SEP [,.;:]
DELIM [ \t]
WHITESPACE {DELIM}+
UNDERSCORE "_"
OPEN_PARENTESES [(]
CLOSE_PARENTESES [)]
OPEN_CURLY [{]
CLOSE_CURLY [}]
OPEN_BRACKETS [\[]
CLOSE_BRACKETS [\]]
DIGIT [0-9]
VECTOR <(" ")*{INT}(" ")*(,(" ")*{INT}(" ")*)*>|<(" ")*{FLOAT}(" ")*(,(" ")*{FLOAT}(" ")*)*>
INT [-]?{DIGIT}+
FLOAT [-]?{DIGIT}+"."{DIGIT}*
LETTER [a-zA-Z]
TYPE "int"|"float"|"elem"|"set"
IF "if"
ELSE "else"
WHILE "while"
RETURN "return"
READ "read"
WRITE "write"
DISTANCE "distance"
NORMALIZE "normalize"
ADD "+"
SUB "-"
MULT "*"
DIV "/"
ASSING "="
OR "||"
AND "&&"
QUOTES ["]
COMPARABLES "<="|"=="|">="|">"|"<"|"!="
ID  {LETTER}({LETTER}|{DIGIT}|{UNDERSCORE})*

%%

{TYPE} {
    printf("TYPE (%s) \n", yytext);
    //return TYPE;
}

{INT} {
    printf("INT (%s) \n", yytext );
    //return INT;
}

{FLOAT} {
    printf("FLOAT (%s) \n", yytext );
    //return FLOAT;
}

{VECTOR} {
    printf("VECTOR (%s) \n", yytext );
    //return VECTOR;
}



{IF} {
    printf("IF (%s) \n", yytext );
    //return IF;
}

{ELSE} {
    printf("ELSE (%s) \n", yytext );
    //return ELSE;
}

{WHILE} {
    printf("WHILE (%s) \n", yytext );
    //return WHILE;
}

{RETURN} {
    printf("RETURN (%s) \n", yytext );
    //return RETURN;
}

{DISTANCE} {
    printf("DISTANCE (%s) \n", yytext );
    //return DISTANCE;
}

{NORMALIZE} {
    printf("NORMALIZE (%s) \n", yytext );
    //return NORMALIZE;
}

{WRITE} {
    printf("WRITE (%s) \n", yytext );
    //return WRITE;
}

{READ} {
    printf("READ (%s) \n", yytext );
    //return READ;
}

{QUOTES} {
    printf("QUOTES (%s)\n", yytext);
    //BEGIN(STRING);
    //return QUOTES;
}

{ID} {
    printf("ID (%s),  \n", yytext );
    //return ID;
}

{ADD} {
    printf("ADD (%s) \n", yytext );
    //return ADD;
}

{SUB} {
    printf("SUB (%s) \n", yytext );
    //return SUB;
}

{MULT} {
    printf("MULT (%s) \n", yytext );
    //return MULT;
}

{DIV} {
    printf("DIV (%s) \n", yytext );
    //return DIV;
}

{ASSING} {
    printf("ASSING (%s) \n", yytext );
    //return ASSING;
}

{OR} {
    printf("OR (%s) \n", yytext );
    //return OR;
}

{AND} {
    printf("AND (%s) \n", yytext );
    //return AND;
}

{COMPARABLES} {
    printf("COMPARABLES (%s) \n", yytext );
    //return COMPARABLES;
}

{OPEN_PARENTESES} {
    printf("OPEN_PARENTESES (%s) \n", yytext);
    //return OPEN_PARENTESES;
}

{CLOSE_PARENTESES} {
    printf("CLOSE_PARENTESES (%s) \n", yytext);
    //return CLOSE_PARENTESES;
}

{OPEN_BRACKETS} {
    printf("OPEN_BRACKETS (%s) \n", yytext);
    //return OPEN_BRACKETS;
}

{CLOSE_BRACKETS} {
    printf("CLOSE_BRACKETS (%s) \n", yytext);
    //return CLOSE_BRACKETS;
}

{OPEN_CURLY} {
    printf("OPEN_CURLY (%s) \n", yytext);
    //return OPEN_CURLY;
}

{CLOSE_CURLY} {
    printf("CLOSE_CURLY (%s) \n", yytext);
    //return CLOSE_CURLY;
}

{EOL} {
    currentLine++;
}

\t* {
}

" "* {
}

";" {
    return yytext[0];
}

"," {
    return yytext[0];
}

":" {
    return yytext[0];
}

"." {
    return yytext[0];
}

. {
    errorArray[error_cnt].line = currentLine;
    errorArray[error_cnt].error_symbol = yytext[0];
    errorQty++;
}

%%