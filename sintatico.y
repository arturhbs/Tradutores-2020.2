%define parse.error verbose 
%debug
%locations

%{
#include <stdio.h>
int yylex();
extern void yyerror(const char *string);
extern int yylex_destroy();
extern FILE *yyin;


%}
%token OPEN_CURLY CLOSE_CURLY OPEN_PARENTESES CLOSE_PARENTESES
%token TYPE_INT TYPE_FLOAT TYPE_ELEM TYPE_SET
%token ID

%union {
  char* string;
  struct nodeTree* nodeTree;
}

%%
tradutor: declaracoesExtenas  {printf("<TRADUTORES>\n");}
;

declaracoesExtenas: declaracoesExtenas funcoes {printf("<DECLARACOESEXTERNAS> <FUNCOES>\n");}
                    | declaracoesExtenas declaracoesVariaveis {printf("<DECLARACOESEXTERNASA> <DECLARACOESVARIAVEIS>\n");}
                    | funcoes {printf("<FUNCOES>\n");}
                    | declaracoesVariaveis {printf("<DECLARACAOVARIAVEIS>\n");}
                     
;                     

funcoes: tipagem ID  OPEN_PARENTESES parametros CLOSE_PARENTESES posDeclaracao {printf("funcoes\n");}
;

parametros: parametroLista | %empty {printf("<PARAMETROS>\n");}
;
parametroLista: declaracoesVariaveis
              | parametros ',' declaracoesVariaveis
;

posDeclaracao: OPEN_CURLY declaracoesVariaveis CLOSE_CURLY {printf("<POSDECLARACAO>\n");}
; 

tipagem: TYPE_INT {printf("TipoInt\n");}
          | TYPE_FLOAT {printf("TipoFloat\n");}
          | TYPE_ELEM {printf("TipoElement\n");}
          | TYPE_SET  {printf("TipoSet\n");}
;          

declaracoesVariaveis: tipagem ID ';' | tipagem ID  {printf("variable\n");} 
;


%%      

void yyerror(const char *string) {
    printf("yyerror= %s\n", string);
}

// Got from documentation flex https://westes.github.io/flex/manual/Simple-Examples.html#Simple-Examples
int main( int argc, char **argv ){
    ++argv, --argc;
    if ( argc > 0 )yyin = fopen( argv[0], "r" );else yyin = stdin; 

    yyparse();
    fclose(yyin);
    yylex_destroy();

    return 0;
}

