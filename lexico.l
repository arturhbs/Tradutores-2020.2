%{
/*
Autor: Artur Henrique Brandão de Souza
Matricula: 15/0118783
Sistema Operacional: Ubuntu v.20.04
Compilador: gcc v.9.3.0
            flex v.2.6.4
            bison v.3.5.1


*/
#include <stdio.h>
#include <string.h>
#include "sintatico.tab.h"

int currentLine = 1;
int positionWord = 1;

%}
%option noyywrap
%option noinput nounput

INT [-]?{DIGIT}+
FLOAT [-]?{DIGIT}+"."{DIGIT}*
TYPE_INT "int"
TYPE_FLOAT "float"
TYPE_ELEM "elem"
TYPE_SET "set"
TYPE "int2"
IF "if"
ELSE "else"
RETURN "return"
STRING_DOUBLE_QUOTE \"(\\.|[^"\\])*\"
STRING_SIMPLE_QUOTE \'(\\.|[^"\\])*\'
ADD "+"
SUB "-"
MULT "*"
DIV "/"
ASSING "="
OR "||"
AND "&&"
COMPARABLES "==+"
COMPARABLES_EQUAL "=="
COMPARABLES_DIFF "!="
COMPARABLES_LTE "<="
COMPARABLES_GTE ">="
COMPARABLES_LT "<"
COMPARABLES_GT ">"
CLOSE_BRACKETS [\]]
OPEN_BRACKETS [\[]
CLOSE_PARENTESES [)]
OPEN_PARENTESES [(]
CLOSE_CURLY [}]
OPEN_CURLY [{]
EMPTY_LABEL "EMPTY"
DELIM [ \t]
WHITESPACE {DELIM}+
UNDERSCORE "_"
DIGIT [0-9]
LETTER [a-zA-Z]
NEGATIVE_IF_ID [!]{ID}
OUTINPUT "writeln"|"write"|"read"
SET_INSTRUCT "in" 
SEP [,.;:]
ID  ({UNDERSCORE}|{LETTER})+({LETTER}|{DIGIT}|{UNDERSCORE})*

%%


{INT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    //return INT;
}

{FLOAT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | FLOAT = '%s'\n", currentLine, positionWord, yytext);
    //return FLOAT;
}

{TYPE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE = '%s'\n",  currentLine, positionWord, yytext);

}

{TYPE_INT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE_INT = '%s' \n", currentLine, positionWord, yytext );
    return TYPE_INT;
}

{TYPE_FLOAT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE_FLOAT = '%s' \n", currentLine, positionWord, yytext );
    return TYPE_FLOAT;
}
{TYPE_ELEM} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE_ELEM = '%s' \n", currentLine, positionWord, yytext );
    return TYPE_ELEM;
}

{TYPE_SET} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE_SET = '%s' \n", currentLine, positionWord, yytext );
    return TYPE_SET;
}


{IF} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | IF = '%s' \n", currentLine, positionWord, yytext );
    //return IF;
}

{ELSE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | ELSE = '%s'\n", currentLine, positionWord, yytext );
    //return ELSE;
}


{RETURN} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | RETURN = '%s'\n", currentLine, positionWord, yytext );
    //return RETURN;
}

{STRING_DOUBLE_QUOTE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | STRING_DOUBLE_QUOTE = '%s' \n", currentLine, positionWord, yytext);
    //return STRING_DOUBLE_QUOTE;
}

{STRING_SIMPLE_QUOTE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | STRING_SIMPLE_QUOTE = '%s' \n", currentLine, positionWord, yytext);
    //return STRING_SIMPLE_QUOTE;
}


{ADD} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | ADD = '%s' \n", currentLine, positionWord, yytext );
    //return ADD;
}

{SUB} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | SUB = '%s'\n", currentLine, positionWord, yytext);
    //return SUB;
}

{MULT} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | MULT = '%s'\n", currentLine, positionWord, yytext );
    //return MULT;
}

{DIV} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | DIV = '%s' \n", currentLine, positionWord, yytext );
    //return DIV;
}

{ASSING} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | ASSING = '%s'\n", currentLine, positionWord, yytext );
    //return ASSING;
}

{OR} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OR = '%s' \n", currentLine, positionWord, yytext );
    //return OR;
}

{AND} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | AND = '%s'\n", currentLine, positionWord , yytext);
    //return AND;
}

{COMPARABLES} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | COMPARABLES = '%s' \n", currentLine, positionWord, yytext );
    //return COMPARABLES;     
}


{COMPARABLES_EQUAL} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_EQUAL = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_EQUAL;
}
{COMPARABLES_DIFF} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_DIFF = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_DIFF;
}

{COMPARABLES_LTE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_LTE = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_LTE;
}
{COMPARABLES_GTE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_GTE = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_GTE;
}
{COMPARABLES_LT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_LT = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_LT;
}
{COMPARABLES_GT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES_GT = '%s'\n", currentLine, positionWord, yytext);
    //return COMPARABLES_GT;
}

{CLOSE_BRACKETS} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | CLOSE_BRACKETS = '%s'\n", currentLine, positionWord, yytext);
    //return CLOSE_BRACKETS;
}

{OPEN_BRACKETS} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OPEN_BRACKETS = '%s'\n", currentLine, positionWord, yytext);
    //return OPEN_BRACKETS;
}

{OPEN_PARENTESES} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OPEN_PARENTESES = '%s' \n", currentLine, positionWord, yytext);
    return OPEN_PARENTESES;
}

{CLOSE_PARENTESES} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | CLOSE_PARENTESES = '%s' \n", currentLine, positionWord, yytext);
    return CLOSE_PARENTESES;
}

{OPEN_CURLY} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OPEN_CURLY = '%s' \n", currentLine, positionWord, yytext);
    return OPEN_CURLY;
}

{CLOSE_CURLY} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | CLOSE_CURLY = '%s'\n", currentLine, positionWord, yytext);
    return CLOSE_CURLY;
}


{EMPTY_LABEL} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | EMPTY = '%s'\n", currentLine, positionWord, yytext);
    //return EMPTY_LABEL;
}

{SET_INSTRUCT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | SET_INSTRUCT = '%s'\n", currentLine, positionWord, yytext);
    //return SET_INSTRUCT;
}

{OUTINPUT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OUTINPUT = '%s'\n", currentLine, positionWord, yytext);
    //return OUTINPUT;
}

{NEGATIVE_IF_ID} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | NEGATIVE_IF_ID = '%s'\n", currentLine, positionWord, yytext);
    //return NEGATIVE_IF_ID;
}

"\n" {
    printf("<EOL>\n");
    currentLine++;
    positionWord = 1;
}

\t* {
}

" "* {
    //printf("<ESPACE>\n");
    // return yytext[0];
}

";" {
    //return yytext[0];
}

"," {
    //return yytext[0];
}

":" {
    //return yytext[0];
}

"." {
    //return yytext[0];
}

{ID} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ID = '%s'\n", currentLine, positionWord, yytext );
    return ID;
}


. {
    printf("\n##### Ocorreu erro ######\n");
    printf("Line %d | Position %d | ERROR = '%s' \n",  currentLine, positionWord, yytext);
    printf("##### Fim Erro     #####\n\n");
}

%%
