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
TYPE "int" | "float" | "elem" | "set"
SET_COMMANDS "add"| "remove" | "forall" | is_set | "in" | "exists"
EMPTY_LABEL "EMPTY"
OUTINPUT "writeln"|"write"|"read"
IF "if"
ELSE "else"
FOR "for"
RETURN "return"
STRING_DOUBLE_QUOTE \"(\\.|[^"\\])*\"
STRING_SIMPLE_QUOTE \'(\\.|[^"\\])*\'
ADD_SUB "+" | "-"
MULT_DIV "*" | "/"
ASSING "="
OR_AND "||" | "&&"
COMPARABLES "=="|"!="|"<="|">="|"<"|">"
CLOSE_BRACKETS [\]]
OPEN_BRACKETS [\[]
CLOSE_PARENTESES [)]
OPEN_PARENTESES [(]
CLOSE_CURLY [}]
OPEN_CURLY [{]
COMMENT "//"
NEGATIVE_IF_ID [!]{ID}
UNDERSCORE "_"
DIGIT [0-9]
LETTER [a-zA-Z]
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

{TYPE} {"int" | "float" | "elem" | "set"
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | TYPE = '%s'\n",  currentLine, positionWord, yytext);
    if(yytext == "int"){
        // return TYPE_INT;
    }
    else{
        if(yytext == "float"){
            // return TYPE_FLOAT;
        }
        else{
            if(yytext == "elem"){
                // return TYPE_ELEM;
            }
            else{
                if(yytext == "set"){
                    //return TYPE_SET;
                }
                else{
                    if(yytext == "exists"){
                        //return TYPE_EXISTS;
                    }
                }
            }
        }
    }

}

{SET_COMMANDS} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | SET_COMMANDS = '%s' \n", currentLine, positionWord, yytext );
    if(yytext == "add"){
        //return SET_ADD;
    }
    else{
        if(yytext == "remove"){
            //return SET_REMOVE;
        }
        else{
            if(yytext == "forall"){
                //return SET_FORALL;
            }
            else{
                if(yytext == "is_set"){
                    //return SET_IS_SET;
                }
                else{
                    if(yytext == "in"){
                        //return SET_IN;
                    }
                    else{
                        if(yytext == "exists"){
                            //return SET_EXISTS;
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
    //return EMPTY_LABEL;
}


{OUTINPUT} { "writeln"|"write"|"read"
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | OUTINPUT = '%s'\n", currentLine, positionWord, yytext);
    if(yytext == "writeln"){
        //return OUT_WRITELN;
    }
    else{
        if(yytext == "write"){
            //return OUT_WRITE;
        }
        else{
            if(yytext == "read"){
                //return IN_READ;
            }
        }
    }
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

{FOR} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | FOR = '%s'\n", currentLine, positionWord, yytext );
    //return FOR;
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


{ADD_SUB} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | ADD_SUB = '%s' \n", currentLine, positionWord, yytext );
    if(yytext == "+"){
        //return ADD;
    }
    else{
        if(yytext == "-"){
            //return SUB;
        }
    }
}


{MULT_DIV} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | MULT_DIV = '%s'\n", currentLine, positionWord, yytext );
    if(yytext == "*"){
        //return MULT;
    }
    else{
        if(yytext == "/"){
            //return DIV;
        }
    }
}

{ASSING} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | ASSING = '%s'\n", currentLine, positionWord, yytext );
    //return ASSING;
}

{OR_AND} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | OR = '%s' \n", currentLine, positionWord, yytext );
    if(yytext == "||"){
        return OR;
    }
    else{
        if(yytext == "&&"){
            return AND;
        }
    }
}

{COMPARABLES} {
    positionWord += strlen(yytext);
    printf("Line %d | Position %d | COMPARABLES = '%s' \n", currentLine, positionWord, yytext );
    //return COMPARABLES;     "=="|"!="|"<="|">="|"<"|">"
    if(yytext == "=="){
        return COMPARABLES_EQUAL;
    }
    else{
        if(yytext == "!="){
            //return COMPARABLES_DIFF;
        }
        else{
            if(yytext == "<="){
                //return COMPARABLES_LTE;
            }
            else{
                if(yytext == ">="){
                    //return COMPARABLES_GTE;
                }
                else{
                    if(yytext == "<"){
                        //return COMPARABLES_LT;
                    }
                    else{
                        if(yytext == ">"){
                            //return COMPARABLES_GT;
                        }
                    }
                }
            }
        }
    }
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


{NEGATIVE_IF_ID} {
    positionWord += strlen(yytext);
    //printf("Line %d | Position %d | NEGATIVE_IF_ID = '%s'\n", currentLine, positionWord, yytext);
    //return NEGATIVE_IF_ID;
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
