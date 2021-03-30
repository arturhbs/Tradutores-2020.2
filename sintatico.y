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

%union {
  char* string;
  struct nodeTree* nodeTree;
}


%token TYPE_INT TYPE_FLOAT TYPE_ELEM TYPE_SET
%token ID INT FLOAT STRING EMPTY_LABEL QUOTES ASSING
%token IF ELSE FOR RETURN
%token COMPARABLES_EQUAL COMPARABLES_DIFF COMPARABLES_LTE COMPARABLES_GTE COMPARABLES_LT COMPARABLES_GT
%token OR AND NEGATIVE MULT DIV ADD SUB
%token OUT_WRITELN OUT_WRITE IN_READ
%token SET_IN SET_ADD SET_REMOVE SET_FORALL SET_IS_SET SET_EXISTS
%%

tradutor: declaracoesExtenas  {printf("<tradutor> <== <declaracoesExternas>\n");}
;

declaracoesExtenas: funcoes {printf("<declaracoesExternas> <==  <funcoes>\n");}
                  | declaracoesVariaveis {printf("<declaracoesExternas> <== <declaracoesVariaveis>\n");}
                  | declaracoesExtenas funcoes {printf("<declaracoesExternas> <== <declaracoesExternas> <funcoes>\n");}
                  | declaracoesExtenas declaracoesVariaveis {printf("<declaracoesExternas> <== <declaracoExternas> <declaracoesVariaveis>\n");}
;                     

declaracoesVariaveis: tipagem ID ';' {printf("<declaracoesVariaveis> <== <tipagem> ID ';'\n");}
;

funcoes: tipagem ID '(' parametros ')' posDeclaracao {printf("<funcoes> <==  <tipagem> ID '(' <parametros> ')' <posDeclaracao>\n");}
;

parametros: parametros ',' tipagem ID {printf("<parametros> <== <parametros> , <tipagem> ID\n");}
          | tipagem ID {printf("<parametros> <== <tipagem> ID\n");}
          | %empty {printf("<parametros> <== E\n");}
;

posDeclaracao:  '{' declaracoesVariaveisLocais sentencaLista '}' {printf("<posDeclaracao> <==  OPEN_CURLY <declaracoesVariaveisLocais> <sentencaLista> CLOSE_CURLY\n");}
; 

tipagem: TYPE_INT   {printf("<tipagem> <== TYPE_INT\n");}
       | TYPE_FLOAT {printf("<tipagem> <== TYPE_FLOAT\n");}
       | TYPE_ELEM  {printf("<tipagem> <== TYPE_ELEM\n");}
       | TYPE_SET   {printf("<tipagem> <== TYPE_SET\n");}
;          

declaracoesVariaveisLocais: declaracoesVariaveisLocais declaracoesVariaveis {printf("<declaracoesVariaveisLocais> <== <declaracoesVariaveisLocais> <declaracoesVariaveis>\n");}
                          | %empty  {printf("<declaracoesVariaveis> <== variable\n");} 
;

sentencaLista: sentencaLista sentenca {printf("<sentencaLista> <== <sentencaLista> <sentenca>\n");}
             | %empty {printf("<sentencaLista> <== E\n");}
;

sentenca: condicionalSentenca    {printf("<sentenca> <== <condicionalSentenca>\n");}
        | iteracaoSentenca       {printf("<sentenca> <== <iteracaoSentenca>\n");}
        | returnSentenca         {printf("<sentenca> <== <returnSentenca>\n");}
        | leituraEscritaSentenca {printf("<sentenca> <== <leituraEscritaSentenca>\n");}
        | chamaFuncoes           {printf("<sentenca> <== <chamaFuncoes>\n");}
        | expressao              {printf("<sentenca> <== <expressao>\n");}
        | conjuntoSentenca       {printf("<sentenca> <== <conjuntoSentenca>\n");}
;

condicionalSentenca: IF '(' condicaoIF ')' posIF {printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao>\n");}
                   | IF '(' condicaoIF ')' posIF ELSE posIF {printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao> ELSE posDeclaracao\n");}
;

condicaoIF: ID '(' argumentos ')'
          | expressaoSimplificada
;

posIF: posDeclaracao
      |sentenca
;

iteracaoSentenca:  FOR '(' expressao  expressaoSimplificada ';' expressaoFor ')' posDeclaracao {printf("<iteracaoSentenca> <== for '(' <expressao> ';' <expressaoSimplificada> ';' <expressao> ')' <posDeclaracao>\n");}
;

returnSentenca: RETURN expressaoSimplificada ';'  {printf("<returnSentenca> <== RETURN expressaoSimplificada ';'\n");}
;

leituraEscritaSentenca: OUT_WRITE '('STRING')' ';'   {printf("<leituraEscritaSentenca> <== OUT_WRITE '('STRING')' ';' \n");}
                      | OUT_WRITELN '('STRING')' ';' {printf("<leituraEscritaSentenca> <== OUT_WRITELN '('STRING')' ';'\n");}
                      | IN_READ '('ID')' ';'         {printf("<leituraEscritaSentenca> <== IN_READ '('ID')' ';'\n");}
;

chamaFuncoes: ID '(' argumentos ')' ';' {printf("<chamaFuncoes> <== ID '(' argumentos ')'\n");}
;

argumentos: argumentosLista {printf("<argumentos> <== <argumentosLista>\n");}
          | %empty          {printf("<argumentos> <== E\n");}
;

argumentosLista: expressaoSimplificada                     {printf("<argumentosLista> <== <expressaoSimplificada>\n");}
               | expressaoSimplificada ',' argumentosLista {printf("<argumentosLista> <== <expressaoSimplificada> ',' <argumentosLista>\n");}
;

conjuntoSentenca: SET_ADD '(' conjuntoBoleano ')' ';'                          {printf("<conjuntoSentenca> <== SET_ADD '(' conjuntoBoleano ')' ';'\n");}
                | SET_REMOVE '(' conjuntoBoleano')' ';'                        {printf("<conjuntoSentenca> <== SET_REMOVE '(' conjuntoBoleano')' ';' \n");}
                | SET_FORALL'('conjuntoExpressaoForallExists ')' sentencaLista ';'  {printf("<conjuntoSentenca> <== SET_FORALL'('conjuntoExpressaoForallExists ')' sentenca ';'\n");}
                | SET_IS_SET '(' ID ')' ';'                                    {printf("<conjuntoSentenca> <== SET_IS_SET '(' ID ')' ';'\n");}      
                | SET_EXISTS '('conjuntoExpressaoForallExists ')' sentencaLista ';' {printf("<conjuntoSentenca> <== SET_EXISTS '('conjuntoExpressaoForallExists ')' sentenca ';'\n");}
;

conjuntoBoleano: expressaoSimplificada SET_IN conjuntoSentenca    {printf("<conjuntoBoleano> <== expressao SET_IN conjuntoSentenca\n");}
               | expressaoSimplificada SET_IN ID                  {printf("<conjuntoBoleano> <== expressao SET_IN ID \n");}
;                    

conjuntoExpressaoForallExists: ID SET_IN conjuntoSentenca   {printf("<conjuntoExpressaoForallExists> <== ID SET_IN conjuntoSentenca\n");}
                             | ID SET_IN ID                 {printf("<conjuntoExpressaoForallExists> <== ID SET_IN ID\n");}
;

expressao: ID ASSING expressao {printf("<expressao> <== ID ASSING expressao\n");}
         | expressaoSimplificada ';' {printf("<expressao> <== expressaoSimplificada\n");}
         
;         
expressaoFor: ID ASSING expressaoFor {printf("<expressaoFor> <== ID ASSING expressaoFor\n");}
             |expressaoSimplificada {printf("<expressaoFor> <== expressaoSimplificada\n");} 
;

expressaoSimplificada: expressaoOperacao operacaoComparacao expressaoOperacao {printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoComparacao> <expressaoOperacao>\n");}
                     | expressaoOperacao     {printf("<expressaoSimplificada> <== <expressaoOperacao>\n");}
;

expressaoOperacao: expressaoOperacao operacaoNumerica termo {printf("<operacaoNumerica> <== <expressaoOperacao> <operacaoNumerica> <termo>\n");}
                 | expressaoOperacao operacaoLogic termo    {printf("<operacaoNumerica> <== <expressaoOperacao> <operacaoLogic> <termo>\n");}
                 | termo                                    {printf("<operacaoNumerica> <== <termo>\n");}
;

operacaoNumerica: ADD  {printf("<operacaoNumerica> <== ADD\n");}
                | SUB  {printf("<operacaoNumerica> <== SUB\n");}
                | MULT {printf("<operacaoNumerica> <== MULT\n");}
                | DIV  {printf("<operacaoNumerica> <== DIV\n");}
;    

operacaoLogic: OR {printf("<operacaoLogic> <== OR\n");}
             | AND {printf("<operacaoLogic> <== AND\n");}
             | NEGATIVE {printf("<operacaoLogic> <== NEGATIVE\n");}
;

termo: '(' expressaoSimplificada ')' {printf("<termo> <== '(' <expressaoSimplificada> ')'\n");}
     | ID {printf("<termo> <== ID\n");}
     | INT {printf("<termo> <== INT\n");}
     | FLOAT {printf("<termo> <== FLOAT\n");}
     | EMPTY_LABEL {printf("<termo> <== EMPTY_LABEL\n");}
     | QUOTES STRING QUOTES {printf("<termo> <== QUOTES STRING QUOTES\n");}
;

operacaoComparacao: COMPARABLES_EQUAL {printf("<operacaoComparacao> <== COMPARABLES_EQUAL\n");}
                  | COMPARABLES_DIFF {printf("<operacaoComparacao> <== COMPARABLES_DIFF\n");}
                  | COMPARABLES_LTE {printf("<operacaoComparacao> <== COMPARABLES_GT\n");}
                  | COMPARABLES_GTE {printf("<operacaoComparacao> <== COMPARABLES_GT\n");}
                  | COMPARABLES_LT {printf("<operacaoComparacao> <== COMPARABLES_GT\n");}
                  | COMPARABLES_GT {printf("<operacaoComparacao> <== COMPARABLES_GT\n");}
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

