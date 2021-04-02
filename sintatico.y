%define parse.error verbose 
%debug
%locations

%{
#include <stdio.h>
#include "ut_hash.h"
int yylex();
extern void yyerror(const char *string);
extern int yylex_destroy();
extern FILE *yyin;
int DEBUG = 0; 

// árvore sintática
struct nodeTree {
  struct nodeTree *firstNode;
  struct nodeTree *secondNode;
  struct nodeTree *thirdNode;
  struct nodeTree *fourthNode;
  char *nameNode;
  char *firstSymbol;
  char *secondSymbol;
  char *thirdSymbol;
};


struct nodeTree* syntaticTree = NULL;
struct nodeTree* addition_node( struct nodeTree *firstNode, struct nodeTree *secondNode, struct nodeTree *thirdNode, struct nodeTree *fourthNode,  char *nameNode, char *firstSymbol, char *secondSymbol, char *thirdSymbol );


%}

%union {
  char* string_node;
  struct nodeTree* node;
}

%type <node> tradutor declaracoesExtenas declaracoesVariaveis funcoes parametros posDeclaracao tipagem sentencaLista sentenca
%type <node> conjuntoForall condicionalSentenca condicaoIF posIFForallExists iteracaoSentenca returnSentenca leituraEscritaSentenca
%type <node> chamaFuncoes argumentos argumentosLista conjuntoSentenca conjuntoBoleano expressao expressaoFor expressaoSimplificada 
%type <node> expressaoOperacao operacaoNumerica operacaoLogic termo operacaoComparacao


%token <string_node> TYPE_INT TYPE_FLOAT TYPE_ELEM TYPE_SET
%token <string_node> ID INT FLOAT STRING EMPTY_LABEL QUOTES ASSING
%token <string_node> IF ELSE FOR RETURN
%token <string_node> COMPARABLES_EQUAL COMPARABLES_DIFF COMPARABLES_LTE COMPARABLES_GTE COMPARABLES_LT COMPARABLES_GT
%token <string_node> OR AND NEGATIVE MULT DIV ADD SUB
%token <string_node> OUT_WRITELN OUT_WRITE IN_READ
%token <string_node> SET_IN SET_ADD SET_REMOVE SET_FORALL SET_IS_SET SET_EXISTS

%right THEN ELSE
%%

tradutor: declaracoesExtenas  {
            printf("<tradutor> <== <declaracoesExternas>\n");
            syntaticTree = $1;
          }
;

declaracoesExtenas: funcoes {//if(DEBUG)printf("<declaracoesExternas> <==  <funcoes>%s\n",$1);
                      $$ = addition_node($1, NULL, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                    }
                  | declaracoesVariaveis {//if(DEBUG)printf("<declaracoesExternas> <== <declaracoesVariaveis>\n");
                      $$ = addition_node($1, NULL, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                    }
                  | declaracoesExtenas funcoes {//if(DEBUG)printf("<declaracoesExternas> <== <declaracoesExternas> <funcoes>\n");
                      $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                    }
                  | declaracoesExtenas declaracoesVariaveis {//if(DEBUG)printf("<declaracoesExternas> <== <declaracoExternas> <declaracoesVariaveis>\n");
                      $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                    }
;

declaracoesVariaveis: tipagem ID ';' {printf("<declaracoesVariaveis> <== <tipagem> ID ';'\n");
                                        $$ = addition_node($1, NULL, NULL, NULL, "declaracoesVariaveis", $2, NULL, NULL);
                                     }
 
;

funcoes: tipagem ID '(' parametros ')' posDeclaracao {printf("<funcoes> <==  <tipagem> ID '(' <parametros> ')' <posDeclaracao>\n");}
;

parametros: parametros ',' tipagem ID {printf("<parametros> <== <parametros> , <tipagem> ID\n");}
          | tipagem ID {printf("<parametros> <== <tipagem> ID\n");}
          | %empty {printf("<parametros> <== E\n");}
;

posDeclaracao:  '{' sentencaLista '}' {printf("<posDeclaracao> <==  OPEN_CURLY <declaracoesVariaveisLocais> <sentencaLista> CLOSE_CURLY\n");}
; 

tipagem: TYPE_INT   {printf("<tipagem> <== TYPE_INT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_FLOAT {printf("<tipagem> <== TYPE_FLOAT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_ELEM  {printf("<tipagem> <== TYPE_ELEM\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_SET   {printf("<tipagem> <== TYPE_SET\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
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
        | conjuntoSentenca   ';' {printf("<sentenca> <== <conjuntoSentenca>\n");}
        | declaracoesVariaveis   {printf("<sentenca> <== <declaracoesVariaveis>\n");}
        | conjuntoForall
;

conjuntoForall:  SET_FORALL'('conjuntoBoleano ')' posIFForallExists  {printf("<conjuntoSentenca> <== SET_FORALL'('conjuntoExpressaoForallExists ')' sentenca ';'\n");}
;

condicionalSentenca: IF '(' condicaoIF ')' posIFForallExists %prec THEN {printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao>\n");}
                   | IF '(' condicaoIF ')' posIFForallExists ELSE posIFForallExists {printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao> ELSE posDeclaracao\n");}
;

condicaoIF: ID '(' argumentos ')' {}
          | expressaoSimplificada {}
          | conjuntoBoleano   {}
          | conjuntoSentenca {}
          | NEGATIVE ID '(' argumentos ')' {}
          | NEGATIVE expressaoSimplificada {}
          | NEGATIVE conjuntoBoleano {}
          | NEGATIVE conjuntoSentenca {}         
;

posIFForallExists: posDeclaracao  {}
                  | sentenca       {}
;

iteracaoSentenca:  FOR '(' expressao  expressaoSimplificada ';' expressaoFor ')' posDeclaracao {printf("<iteracaoSentenca> <== for '(' <expressao> ';' <expressaoSimplificada> ';' <expressao> ')' <posDeclaracao>\n");}
;

returnSentenca: RETURN conjuntoSentenca  ';'  {printf("<returnSentenca> <== RETURN expressaoSimplificada ';'\n");}
              | RETURN expressaoSimplificada ';' {}
;

leituraEscritaSentenca: OUT_WRITE '('STRING')' ';'   {printf("<leituraEscritaSentenca> <== OUT_WRITE '('STRING')' ';' \n");}
                      | OUT_WRITELN '('STRING')' ';' {printf("<leituraEscritaSentenca> <== OUT_WRITELN '('STRING')' ';'\n");}
                      | IN_READ '('ID')' ';'         {printf("<leituraEscritaSentenca> <== IN_READ '('ID')' ';'\n");}
                      
;

chamaFuncoes: ID '(' argumentos ')' ';' {printf("<chamaFuncoes> <== ID '(' argumentos ')'\n");}
            | ID ASSING ID '(' argumentos ')' ';' {}
;

argumentos: argumentosLista {printf("<argumentos> <== <argumentosLista>\n");}
          | %empty          {printf("<argumentos> <== E\n");}
;

argumentosLista: expressaoSimplificada                     {printf("<argumentosLista> <== <expressaoSimplificada>\n");}
               | expressaoSimplificada ',' argumentosLista {printf("<argumentosLista> <== <expressaoSimplificada> ',' <argumentosLista>\n");}
;

conjuntoSentenca: SET_ADD '(' conjuntoBoleano ')'                           {printf("<conjuntoSentenca> <== SET_ADD '(' conjuntoBoleano ')' ';'\n");}
                | SET_REMOVE '(' conjuntoBoleano')'                        {printf("<conjuntoSentenca> <== SET_REMOVE '(' conjuntoBoleano')' ';' \n");}
                | SET_IS_SET '(' ID ')'                                     {printf("<conjuntoSentenca> <== SET_IS_SET '(' ID ')' ';'\n");}      
                | SET_EXISTS '('conjuntoBoleano ')'  {printf("<conjuntoSentenca> <== SET_EXISTS '('conjuntoExpressaoForallExists ')' sentenca ';'\n");}
;

conjuntoBoleano: expressaoSimplificada SET_IN conjuntoSentenca    {printf("<conjuntoBoleano> <== expressao SET_IN conjuntoSentenca\n");}
               | expressaoSimplificada SET_IN ID                  {printf("<conjuntoBoleano> <== expressao SET_IN ID \n");}
               | '('conjuntoSentenca ')' SET_IN ID  {}
               | conjuntoSentenca SET_IN ID          {}
               | ID '(' argumentos ')' SET_IN ID      {}
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


struct nodeTree * addition_node(struct nodeTree *firstNode, struct nodeTree *secondNode, struct nodeTree *thirdNode, struct nodeTree *fourthNode,  char *nameNode, char *firstSymbol, char *secondSymbol, char *thirdSymbol ){
  struct nodeTree* node = (struct nodeTree*)malloc(sizeof(struct nodeTree));
  node->firstNode = firstNode;
  node->secondNode = secondNode;
  node->thirdNode = thirdNode;
  node->fourthNode = fourthNode;
  node->nameNode = nameNode;
  node->firstSymbol = firstSymbol;
  node->secondSymbol = secondSymbol;
  node->thirdSymbol = thirdSymbol;

  return node;
}


void show_tree( int positionTree, struct nodeTree *tree) {
  
  for(int j=0;j<positionTree;j++){
    printf("__");
  }
  if (tree) {
    printf("| nameNode: %s  |", tree->nameNode);
    if(tree->firstSymbol != NULL) {
      printf("firstSymbol: %s ", tree->firstSymbol);
    }
    if(tree->secondSymbol != NULL) {
      printf("secondSymbol: %s |", tree->secondSymbol);
    }
    if(tree->thirdSymbol != NULL) {
      printf("thirdSymbol: %s |", tree->thirdSymbol);
    }
    printf("\n");
    show_tree(positionTree+1, tree->firstNode );
    show_tree(positionTree+1, tree->secondNode );
    show_tree(positionTree+1, tree->thirdNode );
    show_tree(positionTree+1, tree->fourthNode );

  }
}

void yyerror(const char *string) {
    printf("yyerror= %s\n", string);
}

// Got from documentation flex https://westes.github.io/flex/manual/Simple-Examples.html#Simple-Examples
int main( int argc, char **argv ){
  ++argv, --argc;
  int begginTree = 0;
  if ( argc > 0 )yyin = fopen( argv[0], "r" );else yyin = stdin; 

  yyparse();
  printf("\n\n ####  Arvore Sintática  #### \n\n");
  show_tree(begginTree, syntaticTree); 
  fclose(yyin);
  yylex_destroy();
  return 0;
}

