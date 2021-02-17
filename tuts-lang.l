%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int currentLine = 1;
int positionWord = 1;

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
    positionWord += strlen(yytext);
    printf("TYPE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return TYPE;
}

{INT} {
    printf("INT = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return INT;
}

{FLOAT} {
    printf("FLOAT = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return FLOAT;
}

{VECTOR} {
    printf("VECTOR = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return VECTOR;
}



{IF} {
    printf("IF = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return IF;
}

{ELSE} {
    printf("ELSE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return ELSE;
}

{WHILE} {
    printf("WHILE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return WHILE;
}

{RETURN} {
    printf("RETURN = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return RETURN;
}

{DISTANCE} {
    printf("DISTANCE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return DISTANCE;
}

{NORMALIZE} {
    printf("NORMALIZE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return NORMALIZE;
}

{WRITE} {
    printf("WRITE = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return WRITE;
}

{READ} {
    printf("READ = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return READ;
}

{QUOTES} {
    printf("QUOTES = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //BEGIN(STRING);
    //return QUOTES;
}

{ID} {
    printf("ID = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return ID;
}

{ADD} {
    printf("ADD = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return ADD;
}

{SUB} {
    printf("SUB = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return SUB;
}

{MULT} {
    printf("MULT = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return MULT;
}

{DIV} {
    printf("DIV = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return DIV;
}

{ASSING} {
    printf("ASSING = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return ASSING;
}

{OR} {
    printf("OR = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return OR;
}

{AND} {
    printf("AND = '%s', | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return AND;
}

{COMPARABLES} {
    printf("COMPARABLES = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord );
    //return COMPARABLES;
}

{OPEN_PARENTESES} {
    printf("OPEN_PARENTESES = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return OPEN_PARENTESES;
}

{CLOSE_PARENTESES} {
    printf("CLOSE_PARENTESES = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return CLOSE_PARENTESES;
}

{OPEN_BRACKETS} {
    printf("OPEN_BRACKETS = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return OPEN_BRACKETS;
}

{CLOSE_BRACKETS} {
    printf("CLOSE_BRACKETS = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return CLOSE_BRACKETS;
}

{OPEN_CURLY} {
    printf("OPEN_CURLY = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return OPEN_CURLY;
}

{CLOSE_CURLY} {
    printf("CLOSE_CURLY = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
    //return CLOSE_CURLY;
}

{EOL} {
    currentLine++;
    positionWord = 1;
}

\t* {
}

" "* {
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

. {
    printf("##### Ocorreu erro ######\n");
    printf("ERROR = '%s' | Line %d | Position %d \n", yytext, currentLine, positionWord);
}

%%

// Got from 
int main( int argc, char **argv ){
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;
        yylex();
}
