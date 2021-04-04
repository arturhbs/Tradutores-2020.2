%{
/*
Autor: Artur Henrique Brandão de Souza
Matricula: 15/0118783
Sistema Operacional: Ubuntu v.20.04
Compilador: gcc v.10.2.0
            flex v.2.6.4
            bison v.3.7.6


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
STRING \"[^\"][^\"]+\"
CHAR '[^']'
ID  ({UNDERSCORE}|{LETTER})+({LETTER}|{DIGIT}|{UNDERSCORE})*

%%


{INT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    // yylval.string_node = (char *) strdup(yytext);
    yylval.string_node = (char *) strdup(yytext);
    return INT;
}

{FLOAT} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | FLOAT = '%s'\n", currentLine, positionWord, yytext);
    yylval.string_node = (char *) strdup(yytext);
    return FLOAT;
}

{TYPE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | INT = '%s'\n", currentLine, positionWord, yytext);
    if(strcmp(yytext, "int") == 0 ){
        yylval.string_node = (char *) strdup(yytext);
        return TYPE_INT;
    }
    else{
        if(strcmp(yytext,"float") == 0){
            yylval.string_node = (char *) strdup(yytext);
            return TYPE_FLOAT;
        }
        else{
            if(strcmp(yytext,"elem")==0){
                yylval.string_node = (char *) strdup(yytext);
                return TYPE_ELEM;
            }
            else{
                if(strcmp(yytext,"set")==0){
                    yylval.string_node = (char *) strdup(yytext);
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
        yylval.string_node = (char *) strdup(yytext);
        return SET_ADD;
    }
    else{
        if(strcmp(yytext,"remove")==0){
            yylval.string_node = (char *) strdup(yytext);
            return SET_REMOVE;
        }
        else{
            if(strcmp(yytext,"forall")==0){
                yylval.string_node = (char *) strdup(yytext);
                return SET_FORALL;
            }
            else{
                if(strcmp(yytext,"is_set")==0){
                    yylval.string_node = (char *) strdup(yytext);
                    return SET_IS_SET;
                }
                else{
                    if(strcmp(yytext,"in")==0){
                        yylval.string_node = (char *) strdup(yytext);
                        return SET_IN;
                    }
                    else{
                        if(strcmp(yytext,"exists")==0){
                            yylval.string_node = (char *) strdup(yytext);
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
    yylval.string_node = (char *) strdup(yytext);
    return EMPTY_LABEL;
}

{OUTINPUT} { 
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OUTINPUT = '%s'\n", currentLine, positionWord, yytext);
    if(strcmp(yytext,"writeln")==0){
        yylval.string_node = (char *) strdup(yytext);
        return OUT_WRITELN;
    }
    else{
        if(strcmp(yytext,"write")==0){
            yylval.string_node = (char *) strdup(yytext);
            return OUT_WRITE;
        }
        else{
            if(strcmp(yytext,"read")){
                yylval.string_node = (char *) strdup(yytext);
                return IN_READ;
            }
        }
    }
}

{IF} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | IF = '%s' \n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);
    return IF;
}

{ELSE} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ELSE = '%s'\n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);
    return ELSE;
}

{FOR} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | FOR = '%s'\n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);    
    return FOR;
}

{RETURN} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | RETURN = '%s'\n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);
    return RETURN;
}

{STRING} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | STRING = '%s' \n", currentLine, positionWord, yytext);
    yylval.string_node = (char *) strdup(yytext);
    return STRING;
}

{CHAR} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | CHAR = '%s' \n", currentLine, positionWord, yytext);
    yylval.string_node = (char *) strdup(yytext);
    return CHAR;
}

{ADD_SUB} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ADD_SUB = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"+")==0){
        yylval.string_node = (char *) strdup(yytext);
        return ADD;
    }
    else{
        if(strcmp(yytext,"-")==0){
            yylval.string_node = (char *) strdup(yytext);
            return SUB;
        }
    }
}

{MULT_DIV} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | MULT_DIV = '%s'\n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"*")==0){
        yylval.string_node = (char *) strdup(yytext);
        return MULT;
    }
    else{
        if(strcmp(yytext,"/")==0){
            yylval.string_node = (char *) strdup(yytext);
            return DIV;
        }
    }
}

{ASSING} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ASSING = '%s'\n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);
    return ASSING;
}

{LOGIC} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | LOGIC = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"||")==0){
        yylval.string_node = (char *) strdup(yytext);
        return OR;
    }
    else{
        if(strcmp(yytext,"&&")==0){
            yylval.string_node = (char *) strdup(yytext);
            return AND;
        }
        else{
            if(strcmp(yytext,"!")==0){
                yylval.string_node = (char *) strdup(yytext);
                return NEGATIVE;
            }
        }
    }
}

{COMPARABLES} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | COMPARABLES = '%s' \n", currentLine, positionWord, yytext );
    if(strcmp(yytext,"==")==0){
        yylval.string_node = (char *) strdup(yytext);
        return COMPARABLES_EQUAL;
    }
    else{
        if(strcmp(yytext,"!=")==0){
            yylval.string_node = (char *) strdup(yytext);
            return COMPARABLES_DIFF;
        }
        else{
            if(strcmp(yytext,"<=")==0){
                yylval.string_node = (char *) strdup(yytext);
                return COMPARABLES_LTE;
            }
            else{
                if(strcmp(yytext,">=")==0){
                    yylval.string_node = (char *) strdup(yytext);
                    return COMPARABLES_GTE;
                }
                else{
                    if(strcmp(yytext,"<")==0){
                        yylval.string_node = (char *) strdup(yytext);
                        return COMPARABLES_LT;
                    }
                    else{
                        if(strcmp(yytext,">")==0){
                            yylval.string_node = (char *) strdup(yytext);
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
    positionWord += strlen(yytext);
    //printf("<ESPACE>\n");
}

";" {
    positionWord += strlen(yytext);
    return yytext[0];
}

"," {
    positionWord += strlen(yytext);
    return yytext[0];
}

"(" {
    positionWord += strlen(yytext);
    return yytext[0];
}

")" {
    positionWord += strlen(yytext);
    return yytext[0];
}

"{" {
    positionWord += strlen(yytext);
    return yytext[0];
}

"}" {
    positionWord += strlen(yytext);
    return yytext[0];
}

":" {
    positionWord += strlen(yytext);
    //return yytext[0];
}

"." {
    positionWord += strlen(yytext);
    //return yytext[0];
}

{ID} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | ID = '%s'\n", currentLine, positionWord, yytext );
    yylval.string_node = (char *) strdup(yytext);

    return ID;
}


. {
    printf("\n##### Ocorreu erro ######\n");
    printf("Line %d | Position %d | ERROR = '%s' \n",  currentLine, positionWord, yytext);
    printf("##### Fim Erro     #####\n\n");
}

%%
