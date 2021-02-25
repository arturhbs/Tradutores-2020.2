%{
#include <stdio.h>

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
INT [-]?{DIGIT}+
FLOAT [-]?{DIGIT}+"."{DIGIT}*
LETTER [a-zA-Z]
TYPE "int"|"float"|"elem"|"set"
EMPTY_LABEL "EMPTY"
NEGATIVE_IF_ID [!]{ID}
STRING_DOUBLE_QUOTE \"(\\.|[^"\\])*\"
STRING_SIMPLE_QUOTE \'(\\.|[^"\\])*\'
IF "if"
ELSE "else"
WHILE "while"
RETURN "return"
DISTANCE "distance"
NORMALIZE "normalize"
OUTINPUT "writeln"|"write"|"read"
ADD "+"
SUB "-"
MULT "*"
DIV "/"
ASSING "="
OR "||"
AND "&&"
SET_INSTRUCT "in" 
COMPARABLES "<="|"=="|">="|">"|"<"|"!="
ID  ({UNDERSCORE}|{LETTER})+({LETTER}|{DIGIT}|{UNDERSCORE})*

%%

{TYPE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | TYPE = '%s'\n",  currentLine, positionWord, yytext);
    //return TYPE;
}

{INT} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    //return INT;
}

{FLOAT} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | FLOAT = '%s'\n", currentLine, positionWord, yytext);
    //return FLOAT;
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

{WHILE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | WHILE = '%s'  \n", currentLine, positionWord, yytext );
    //return WHILE;
}

{RETURN} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | RETURN = '%s'\n", currentLine, positionWord, yytext );
    //return RETURN;
}

{DISTANCE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | DISTANCE = '%s'\n", currentLine, positionWord, yytext );
    //return DISTANCE;
}

{NORMALIZE} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | NORMALIZE = '%s'\n", currentLine, positionWord, yytext );
    //return NORMALIZE;
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

{OPEN_PARENTESES} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OPEN_PARENTESES = '%s' \n", currentLine, positionWord, yytext);
    //return OPEN_PARENTESES;
}

{CLOSE_PARENTESES} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | CLOSE_PARENTESES = '%s' \n", currentLine, positionWord, yytext);
    //return CLOSE_PARENTESES;
}

{OPEN_BRACKETS} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OPEN_BRACKETS = '%s'\n", currentLine, positionWord, yytext);
    //return OPEN_BRACKETS;
}

{CLOSE_BRACKETS} {
    printf("Line %d | Position %d | CLOSE_BRACKETS = '%s'\n", currentLine, positionWord, yytext);
    //return CLOSE_BRACKETS;
}

{OPEN_CURLY} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OPEN_CURLY = '%s' \n", currentLine, positionWord, yytext);
    //return OPEN_CURLY;
}

{CLOSE_CURLY} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | CLOSE_CURLY = '%s'\n", currentLine, positionWord, yytext);
    //return CLOSE_CURLY;
}


{EMPTY_LABEL} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | EMPTY = '%s'\n", currentLine, positionWord, yytext);
    //return EMPTY_LABEL
}

{SET_INSTRUCT} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | SET_INSTRUCT = '%s'\n", currentLine, positionWord, yytext);
    //return SET_INSTRUCT
}

{OUTINPUT} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OUTINPUT = '%s'\n", currentLine, positionWord, yytext);
    //return OUTINPUT
}

{NEGATIVE_IF_ID} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | NEGATIVE_IF_ID = '%s'\n", currentLine, positionWord, yytext);
    //return NEGATIVE_IF_ID
}

{EOL} {
    currentLine++;
    positionWord = 1;
}

\t* {
}

" "* {
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
    printf("Line %d | Position %d | ID = '%s'\n", currentLine, positionWord, yytext );
    //return ID;
}


. {
    printf("\n##### Ocorreu erro ######\n");
    printf("Line %d | Position %d | ERROR = '%s' \n",  currentLine, positionWord, yytext);
    printf("##### Fim Erro     #####\n\n");
}

%%

// Got from documentation flex https://westes.github.io/flex/manual/Simple-Examples.html#Simple-Examples
int main( int argc, char **argv ){
    ++argv, --argc;
    if ( argc > 0 )yyin = fopen( argv[0], "r" );else yyin = stdin; 
    
    yylex();
    fclose(yyin);
    yylex_destroy();

    return 0;
}
