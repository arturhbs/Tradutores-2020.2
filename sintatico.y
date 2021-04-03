%define parse.error verbose 
%debug
%locations

%{
#include <stdio.h>
#include "ut_hash.h"
int yylex();
extern void yyerror(const char *string_node);
extern int yylex_destroy();
extern FILE *yyin;
int DEBUG = 1; 

// Arvore sintatica
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

%type <node> conjuntoIs_Set tradutor declaracoesExtenas declaracoesVariaveis funcoes parametros posDeclaracao tipagem sentencaLista sentenca
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

tradutor: declaracoesExtenas  {if(DEBUG)printf("<tradutor> <== <declaracoesExternas>\n");
            syntaticTree = $1;
          }
;

declaracoesExtenas: funcoes                                 {if(DEBUG)printf("<declaracoesExternas> <==  <funcoes>\n");
                                                              $$ = $1;
                                                            }
                  | declaracoesVariaveis                    {if(DEBUG)printf("<declaracoesExternas> <== <declaracoesVariaveis>\n");
                                                              $$ = $1;
                                                            }
                  | declaracoesExtenas funcoes              {if(DEBUG)printf("<declaracoesExternas> <== <declaracoesExternas> <funcoes>\n");
                                                              $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                                                            }
                  | declaracoesExtenas declaracoesVariaveis {if(DEBUG)printf("<declaracoesExternas> <== <declaracoExternas> <declaracoesVariaveis>\n");
                                                              $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                                                            }
;

declaracoesVariaveis: tipagem ID ';' {if(DEBUG)printf("<declaracoesVariaveis> <== <tipagem> ID ';'\n");
                                        $$ = addition_node($1, NULL, NULL, NULL, "declaracoesVariaveis", $2, NULL, NULL);
                                     }
 
;

funcoes: tipagem ID '(' parametros ')' posDeclaracao {if(DEBUG)printf("<funcoes> <==  <tipagem> ID '(' <parametros> ')' <posDeclaracao>\n");
                                                       $$ = addition_node($1, $4, $6, NULL, "funcoes", $2, NULL, NULL);            
                                                     }
;

parametros: parametros ',' tipagem ID {if(DEBUG)printf("<parametros> <== <parametros> , <tipagem> ID\n");
                                        $$ = addition_node($1, $3, NULL, NULL, "parametros", $4, NULL, NULL);            
                                      }
          | tipagem ID                {if(DEBUG)printf("<parametros> <== <tipagem> ID\n");
                                        $$ = addition_node($1,NULL ,NULL ,NULL , "parametros", $2, NULL, NULL);            
                                      }
          | %empty                    {if(DEBUG)printf("<parametros> <== E\n");
                                        $$ = NULL ;          
                                      }
;

posDeclaracao:  '{' sentencaLista '}' {if(DEBUG)printf("<posDeclaracao> <==  OPEN_CURLY <declaracoesVariaveisLocais> <sentencaLista> CLOSE_CURLY\n");
                                        $$ = $2;    
                                      }
; 

tipagem: TYPE_INT   { if(DEBUG)printf("<tipagem> <== TYPE_INT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_FLOAT { if(DEBUG)printf("<tipagem> <== TYPE_FLOAT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_ELEM  { if(DEBUG)printf("<tipagem> <== TYPE_ELEM\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_SET   { if(DEBUG)printf("<tipagem> <== TYPE_SET\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
;          

sentencaLista: sentencaLista sentenca { if(DEBUG)printf("<sentencaLista> <== <sentencaLista> <sentenca>\n");
                                        $$ = addition_node($1, $2, NULL, NULL, "sentecaLista", NULL, NULL, NULL);
                                      }
              | %empty                { if(DEBUG)printf("<sentencaLista> <== E\n");
                                        $$ = NULL;
                                      }
;

sentenca: condicionalSentenca    { if(DEBUG)printf("<sentenca> <== <condicionalSentenca>\n");
                                   $$ = $1;
                                 }
        | iteracaoSentenca       { if(DEBUG)printf("<sentenca> <== <iteracaoSentenca>\n");
                                   $$ = $1;
                                 }
        | returnSentenca         { if(DEBUG)printf("<sentenca> <== <returnSentenca>\n");
                                   $$ = $1;
                                 }
        | leituraEscritaSentenca { if(DEBUG)printf("<sentenca> <== <leituraEscritaSentenca>\n");
                                   $$ = $1;
                                 }
        | chamaFuncoes           { if(DEBUG)printf("<sentenca> <== <chamaFuncoes>\n");
                                   $$ = $1;
                                 }
        | expressao              { if(DEBUG)printf("<sentenca> <== <expressao>\n");
                                   $$ = $1;
                                 }
        | conjuntoSentenca ';'   { if(DEBUG)printf("<sentenca> <== <conjuntoSentenca>\n");
                                   $$ = $1;
                                 }
        | declaracoesVariaveis   { if(DEBUG)printf("<sentenca> <== <declaracoesVariaveis>\n");
                                   $$ = $1;
                                 }
        | conjuntoForall         { if(DEBUG)printf("<sentenca> <== <conjuntoForall>\n");
                                   $$ = $1;
                                 }  
        | conjuntoIs_Set         { if(DEBUG)printf("<sentenca> <== <conjuntoIs_Set>\n");
                                   $$ = $1;
                                 }  
;

conjuntoIs_Set: ID ASSING conjuntoSentenca ';' { if(DEBUG)printf("<conjuntoSentenca> <==  ID ASSING conjuntoSentenca ';'\n");
                                                  $$ = addition_node($3, NULL, NULL, NULL, "conjuntoSentenca", $1, $2, NULL);
                                                }
            
;
conjuntoForall:  SET_FORALL'('conjuntoBoleano ')' posIFForallExists  { if(DEBUG)printf("<conjuntoSentenca> <== SET_FORALL'('conjuntoExpressaoForallExists ')' sentenca ';'\n");
                                                                       $$ = addition_node($3, $5, NULL, NULL, "conjuntoSentenca", $1, NULL, NULL);
                                                                     }
;

condicionalSentenca: IF '(' condicaoIF ')' posIFForallExists %prec THEN             { if(DEBUG)printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao>\n");
                                                                                      $$ = addition_node($3, $5, NULL, NULL, "condicionalSentenca", $1, NULL, NULL);                                                                        
                                                                                    }
                   | IF '(' condicaoIF ')' posIFForallExists ELSE posIFForallExists {if(DEBUG)printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao> ELSE posDeclaracao\n");
                                                                                      $$ = addition_node($3, $5, $7, NULL, "condicionalSentenca", $1, $6 , NULL);                                                                        
                                                                                    }
;

condicaoIF: ID '(' argumentos ')'           {if(DEBUG)printf("<condicaoIF> <==  ID '(' argumentos ')'\n");
                                              $$ = addition_node($3, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                        
                                            }
          | expressaoSimplificada           {if(DEBUG)printf("<condicaoIF> <== expressaoSimplificada\n");
                                              $$ = $1;                                                                                                  
                                            }
          | conjuntoBoleano                 {if(DEBUG)printf("<condicaoIF> <== conjuntoBoleano\n");
                                              $$ = $1;                                                                                                                    
                                            }
          | conjuntoSentenca                {if(DEBUG)printf("<condicaoIF> <== conjuntoSentenca\n");
                                              $$ = $1;                                                                                                                    
                                            }
          | NEGATIVE ID '(' argumentos ')'  {if(DEBUG)printf("<condicaoIF> <== NEGATIVE ID '(' argumentos ')'\n");
                                              $$ = addition_node($4, NULL, NULL, NULL, "condicaoIF", $1, $2, NULL);                                                                                                                    
                                            }
          | NEGATIVE expressaoSimplificada  {if(DEBUG)printf("<condicaoIF> <== NEGATIVE expressaoSimplificada\n");
                                              $$ = addition_node($2, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                                                                    
                                            }
          | NEGATIVE conjuntoBoleano        {if(DEBUG)printf("<condicaoIF> <== NEGATIVE conjuntoBoleano\n");
                                              $$ = addition_node($2, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                                                                                                                
                                            }
          | NEGATIVE conjuntoSentenca       {if(DEBUG)printf("<condicaoIF> <== NEGATIVE conjuntoSentenca\n");
                                              $$ = addition_node($2, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                                                                                                                
                                            }   
          | '(' conjuntoBoleano ')'      {}
;

posIFForallExists: posDeclaracao  { if(DEBUG)printf("<posIFForallExists> <== posDeclaracao\n");
                                    $$ = $1;                                                                                                                                                                                                 
                                  }
                  | sentenca      { if(DEBUG)printf("<posIFForallExists> <== sentenca\n");
                                    $$ = $1;                                                                                                                                                                                    
                                  }
;

iteracaoSentenca:  FOR '(' expressao  expressaoSimplificada ';' expressaoFor ')' posDeclaracao { if(DEBUG)printf("<iteracaoSentenca> <== for '(' <expressao> ';' <expressaoSimplificada> ';' <expressao> ')' <posDeclaracao>\n");
                                                                                                 $$ = addition_node($3, $4, $6 , $8, "iteracaoSentenca", $1, NULL, NULL);                                                                                                                                                                                                                                                                                   
                                                                                               }
;

returnSentenca: RETURN conjuntoSentenca ';'      { if(DEBUG)printf("<returnSentenca> <== RETURN conjuntoSentenca ';'\n");
                                                   $$ = addition_node($2 ,NULL ,NULL ,NULL, "returnSentenca",$1 ,NULL ,NULL);                                                                                                                                                                                                                                                                                               
                                                 }
              | RETURN expressaoSimplificada ';' { if(DEBUG)printf("<returnSentenca> <== RETURN expressaoSimplificada ';'\n");
                                                   $$ = addition_node($2 ,NULL ,NULL ,NULL, "returnSentenca",$1 ,NULL ,NULL);                                                                                                                                                                                                                                                                                   
                                                 }
;

leituraEscritaSentenca: OUT_WRITE '('STRING')' ';'   { if(DEBUG)printf("<leituraEscritaSentenca> <== OUT_WRITE '('STRING')' ';' \n");
                                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , $3 ,NULL);                                                                                                                                                                                                                        
                                                     }
                      | OUT_WRITELN '('STRING')' ';' { if(DEBUG)printf("<leituraEscritaSentenca> <== OUT_WRITELN '('STRING')' ';'\n");
                                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , $3 ,NULL);                                                                                                                                                                                                                                                                                   
                                                     }
                      | IN_READ '('ID')' ';'         { if(DEBUG)printf("<leituraEscritaSentenca> <== IN_READ '('ID')' ';'\n");
                                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , $3 ,NULL);                                                                                                                                                                                                                                                                                   
                                                     }                      
;

chamaFuncoes: ID '(' argumentos ')' ';'           { if(DEBUG)printf("<chamaFuncoes> <== ID '(' argumentos ')'\n");
                                                    $$ = addition_node($3 ,NULL ,NULL ,NULL, "chamaFuncoes",$1 , NULL ,NULL);
                                                  }
            | ID ASSING ID '(' argumentos ')' ';' { if(DEBUG)printf("<chamaFuncoes> <== ID '(' argumentos ')'\n");
                                                    $$ = addition_node($5 ,NULL ,NULL ,NULL, "chamaFuncoes",$1 , $2 ,$3);  
                                                  }                                      
;

argumentos: argumentosLista { if(DEBUG)printf("<argumentos> <== <argumentosLista>\n");
                              $$ = $1;          
                            }
          | %empty          { if(DEBUG)printf("<argumentos> <== E\n");
                              $$ = NULL;
                            }
;

argumentosLista: expressaoSimplificada                      { if(DEBUG)printf("<argumentosLista> <== <expressaoSimplificada>\n");
                                                              $$ = $1;                                                                     
                                                            }
               |  argumentosLista ',' expressaoSimplificada { if(DEBUG)printf("<argumentosLista> <== <expressaoSimplificada> ',' <argumentosLista>\n");
                                                              $$ = addition_node($1 ,$3 ,NULL ,NULL, "argumentosLista", NULL , NULL ,NULL);                                      
                                                            }
               | conjuntoSentenca                           { if(DEBUG)printf("<argumentosLista> <== <conjuntoSentenca>\n");
                                                              $$ = $1;                                      
                                                            }
               | argumentosLista ',' conjuntoSentenca       { if(DEBUG)printf("<argumentosLista> <== <argumentosLista> ',' <conjuntoSentenca>\n");
                                                              $$ = addition_node($1 ,$3 ,NULL ,NULL, "argumentosLista", NULL , NULL ,NULL);                                      
                                                            }
;

conjuntoSentenca: SET_ADD '(' conjuntoBoleano ')'    { if(DEBUG)printf("<conjuntoSentenca> <== SET_ADD '(' conjuntoBoleano ')' ';'\n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL); 
                                                     }
                | SET_REMOVE '(' conjuntoBoleano')'  { if(DEBUG)printf("<conjuntoSentenca> <== SET_REMOVE '(' conjuntoBoleano')' ';' \n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL);
                                                     }
                | SET_IS_SET '(' ID ')'              { if(DEBUG)printf("<conjuntoSentenca> <== SET_IS_SET '(' ID ')' ';'\n");
                                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , $3 ,NULL);
                                                     }      
                | SET_EXISTS '('conjuntoBoleano ')'  { if(DEBUG)printf("<conjuntoSentenca> <== SET_EXISTS '('conjuntoExpressaoForallExists ')' sentenca ';'\n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL);
                                                     }
;

conjuntoBoleano: expressaoSimplificada SET_IN conjuntoSentenca    { if(DEBUG)printf("<conjuntoBoleano> <== expressao SET_IN conjuntoSentenca\n");
                                                                    $$ = addition_node($1 ,$3 ,NULL ,NULL, "conjuntoBoleano", $2 , NULL ,NULL);
                                                                  }
               | expressaoSimplificada SET_IN ID                  { if(DEBUG)printf("<conjuntoBoleano> <== expressaoSimplificada SET_IN ID\n");
                                                                    $$ = addition_node($1 ,NULL ,NULL ,NULL, "conjuntoBoleano", $2 ,$3 ,NULL);
                                                                  }
               | '('conjuntoSentenca ')' SET_IN ID                { if(DEBUG)printf("<conjuntoBoleano> <== '('conjuntoSentenca ')' SET_IN ID \n");
                                                                    $$ = addition_node($2 ,NULL ,NULL ,NULL, "conjuntoBoleano", $4 , $5 ,NULL);
                                                                  }
               | conjuntoSentenca SET_IN ID                       { if(DEBUG)printf("<conjuntoBoleano> <== conjuntoSentenca SET_IN ID  \n");
                                                                    $$ = addition_node($1 ,NULL ,NULL ,NULL, "conjuntoBoleano", $2 , $3 ,NULL);
                                                                  }
               | ID '(' argumentos ')' SET_IN ID                  { if(DEBUG)printf("<conjuntoBoleano> <== ID '(' argumentos ')' SET_IN ID  \n");
                                                                    $$ = addition_node($3 , NULL ,NULL ,NULL, "conjuntoBoleano", $1 , $5 ,$6);
                                                                  }
               | conjuntoSentenca SET_IN conjuntoSentenca         { if(DEBUG)printf("<conjuntoBoleano> <== conjuntoSentenca SET_IN conjuntoSentenca\n");
                                                                    $$ = addition_node($1 , $3 ,NULL ,NULL, "conjuntoBoleano", $2 , NULL ,NULL);
                                                                  }
;                    

expressao: ID ASSING expressao        { if(DEBUG)printf("<expressao> <== ID ASSING expressao\n");
                                        $$ = addition_node($3 ,NULL ,NULL ,NULL, "expressao", $1 , $2 ,NULL); 
                                      }                                       
         | expressaoSimplificada ';' { if(DEBUG)printf("<expressao> <== expressaoSimplificada\n");
                                       $$ = $1; 
                                     }
;    

expressaoFor: ID ASSING expressaoFor { if(DEBUG)printf("<expressaoFor> <== ID ASSING expressaoFor\n");
                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "expressaoFor", $1, $2 ,NULL);  
                                     }
             |expressaoSimplificada { if(DEBUG)printf("<expressaoFor> <== expressaoSimplificada\n");
                                      $$ = $1; 
                                    } 
;

expressaoSimplificada: expressaoOperacao operacaoComparacao expressaoOperacao { if(DEBUG)printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoComparacao> <expressaoOperacao>\n");
                                                                                $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoSimplificada", NULL, NULL ,NULL);
                                                                              }
                     | expressaoOperacao                                      { if(DEBUG)printf("<expressaoSimplificada> <== <expressaoOperacao>\n");
                                                                                $$ = $1; 
                                                                              }
;

expressaoOperacao: expressaoOperacao operacaoNumerica termo { if(DEBUG)printf("<operacaoNumerica> <== <expressaoOperacao> <operacaoNumerica> <termo>\n");
                                                              $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoOperacao", NULL, NULL ,NULL);
                                                            }
                 | expressaoOperacao operacaoLogic termo    { if(DEBUG)printf("<operacaoNumerica> <== <expressaoOperacao> <operacaoLogic> <termo>\n");
                                                              $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoOperacao", NULL, NULL ,NULL);  
                                                            }
                 | termo                                    { if(DEBUG)printf("<operacaoNumerica> <== <termo>\n");
                                                              $$ = $1;
                                                            }
;

operacaoNumerica: ADD  { if(DEBUG)printf("<operacaoNumerica> <== ADD\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "expressaoFor", $1, NULL ,NULL);
                       }
                | SUB  { if(DEBUG)printf("<operacaoNumerica> <== SUB\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "expressaoFor", $1, NULL ,NULL);
                       }
                | MULT { if(DEBUG)printf("<operacaoNumerica> <== MULT\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "expressaoFor", $1, NULL ,NULL);
                       }
                | DIV  { if(DEBUG)printf("<operacaoNumerica> <== DIV\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "expressaoFor", $1, NULL ,NULL);
                       }
;    

operacaoLogic: OR        { if(DEBUG)printf("<operacaoLogic> <== OR\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL);
                         }
             | AND       { if(DEBUG)printf("<operacaoLogic> <== AND\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL);
                         }
             | NEGATIVE  { if(DEBUG)printf("<operacaoLogic> <== NEGATIVE\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL); 
                         }
;

termo: '(' expressaoSimplificada ')' { if(DEBUG)printf("<termo> <== '(' <expressaoSimplificada> ')'\n");
                                       $$ = addition_node($2 ,NULL ,NULL ,NULL, "termo", NULL, NULL ,NULL);
                                     }
     | ID                            { if(DEBUG)printf("<termo> <== ID\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);  
                                     }
     | INT                           { if(DEBUG)printf("<termo> <== INT\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | FLOAT                         { if(DEBUG)printf("<termo> <== FLOAT\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | EMPTY_LABEL                   { if(DEBUG)printf("<termo> <== EMPTY_LABEL\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | QUOTES STRING QUOTES          { if(DEBUG)printf("<termo> <== QUOTES STRING QUOTES\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, $2 ,$3);
                                     }

;

operacaoComparacao: COMPARABLES_EQUAL { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_EQUAL\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_DIFF  { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_DIFF\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_LTE   { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_GTE   { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_LT    { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_GT    { if(DEBUG)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
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
  if (tree) {
    for(int j=0;j<positionTree;j++){
      printf("__");
    }
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

void yyerror(const char *string_node) {
    printf("yyerror= %s\n", string_node);
}

// Got from documentation flex https://westes.github.io/flex/manual/Simple-Examples.html#Simple-Examples
int main( int argc, char **argv ){
  ++argv, --argc;
  int begginTree = 0;
  if ( argc > 0 )yyin = fopen( argv[0], "r" );else yyin = stdin; 

  yyparse();
  if(DEBUG == 0){
    printf("\n\n ####  Arvore Sintatica  #### \n\n");
    show_tree(begginTree, syntaticTree); 
  }
  fclose(yyin);
  yylex_destroy();
  return 0;
}

