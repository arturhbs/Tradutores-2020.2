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
TYPE "int"|"float"|"elem"|"set"
SET_COMMANDS "add"|"remove"|"forall"|"is_set"|"in"|"exists"
EMPTY_LABEL "EMPTY"
OUTINPUT "writeln"|"write"|"read"
IF "if"
ELSE "else"
FOR "for"
RETURN "return"
ADD_SUB "+"|"-"
MULT_DIV "*"|"/"
ASSING "="
LOGIC "||"|"&&"|"!"
COMPARABLES "=="|"!="|"<="|">="|"<"|">"
COMMENT "//"
UNDERSCORE "_"
DIGIT [0-9]
LETTER [a-zA-Z]
STRING \"[^\"]*\"|'[^']*'
ID  ({UNDERSCORE}|{LETTER})+({LETTER}|{DIGIT}|{UNDERSCORE})*

%%


{INT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    return INT;
}


{FLOAT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | FLOAT = '%s'\n", currentLine, positionWord, yytext);
    return FLOAT;
}

{TYPE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    if(strcmp(yytext, "int") == 0 ){
        return TYPE_INT;
    }
    else{
        if(strcmp(yytext,"float") == 0){
            return TYPE_FLOAT;
        }
        else{
            if(strcmp(yytext,"elem")==0){
                return TYPE_ELEM;
            }
            else{
                if(strcmp(yytext,"set")==0){
                    return TYPE_SET;
                }
            }
        }
    }
}

{SET_COMMANDS} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | SET_COMMANDS = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"add")==0){
        return SET_ADD;
    }
    else{
        if(strcmp(yytext,"remove")==0){
            return SET_REMOVE;
        }
        else{
            if(strcmp(yytext,"forall")==0){
                return SET_FORALL;
            }
            else{
                if(strcmp(yytext,"is_set")==0){
                    return SET_IS_SET;
                }
                else{
                    if(strcmp(yytext,"in")==0){
                        return SET_IN;
                    }
                    else{
                        if(strcmp(yytext,"exists")==0){
                            return SET_EXISTS;
                        }
                    }
                }
            }
        }
    }
}


{EMPTY_LABEL} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | EMPTY = '%s'\n", currentLine, positionWord, yytext);
    return EMPTY_LABEL;
}


{OUTINPUT} { 
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OUTINPUT = '%s'\n", currentLine, positionWord, yytext);
    if(strcmp(yytext,"writeln")==0){
        return OUT_WRITELN;
    }
    else{
        if(strcmp(yytext,"write")==0){
            return OUT_WRITE;
        }
        else{
            if(strcmp(yytext,"read")){
                return IN_READ;
            }
        }
    }
}


{IF} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | IF = '%s' \n", currentLine, positionWord, yytext );
    return IF;
}

{ELSE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ELSE = '%s'\n", currentLine, positionWord, yytext );
    return ELSE;
}

{FOR} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | FOR = '%s'\n", currentLine, positionWord, yytext );
    return FOR;
}

{RETURN} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | RETURN = '%s'\n", currentLine, positionWord, yytext );
    return RETURN;
}

{STRING} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | STRING = '%s' \n", currentLine, positionWord, yytext);
    return STRING;
}


{ADD_SUB} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ADD_SUB = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"+")==0){
        return ADD;
    }
    else{
        if(strcmp(yytext,"-")==0){
            return SUB;
        }
    }
}


{MULT_DIV} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | MULT_DIV = '%s'\n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"*")==0){
        return MULT;
    }
    else{
        if(strcmp(yytext,"/")==0){
            return DIV;
        }
    }
}

{ASSING} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ASSING = '%s'\n", currentLine, positionWord, yytext );
    return ASSING;
}

{LOGIC} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | LOGIC = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"||")==0){
        return OR;
    }
    else{
        if(strcmp(yytext,"&&")==0){
            return AND;
        }
        else{
            if(strcmp(yytext,"!")==0){
                return NEGATIVE;
            }
        }
    }
}

{COMPARABLES} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"==")==0){
        return COMPARABLES_EQUAL;
    }
    else{
        if(strcmp(yytext,"!=")==0){
            return COMPARABLES_DIFF;
        }
        else{
            if(strcmp(yytext,"<=")==0){
                return COMPARABLES_LTE;
            }
            else{
                if(strcmp(yytext,">=")==0){
                    return COMPARABLES_GTE;
                }
                else{
                    if(strcmp(yytext,"<")){
                        return COMPARABLES_LT;
                    }
                    else{
                        if(strcmp(yytext,">")==0){
                            return COMPARABLES_GT;
                        }
                    }
                }
            }
        }
    }
}



{COMMENT}.* {
    //printf("Line %d | Position %d | CLOSE_CURLY = '%s'\n", currentLine, positionWord, yytext);
}

"\n" {
    //printf("<EOL>\n");
    currentLine++;
    positionWord = 1;
}

\t* {
}

" "* {
    //printf("<ESPACE>\n");
}

";" {
    return yytext[0];
}

"," {
    return yytext[0];
}

"(" {
    return yytext[0];
}

")" {
    return yytext[0];
}

"{" {
    return yytext[0];
}

"}" {
    return yytext[0];
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
