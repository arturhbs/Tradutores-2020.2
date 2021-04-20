%define parse.error verbose 
%debug
%locations

%{
#include <stdio.h>
#include <stdlib.h>
#include "ut_hash.h"
#include "ut_list.h"

int yylex();
extern void yyerror(const char *string_node);
extern int yylex_destroy();
extern FILE *yyin;
extern int currentLine;
extern int positionWord;
int DEPURADOR = 0; 
int deuErro = 0; 
char* scope_current = "GLOBAL";
char* scope_current_aux = "GLOBAL";

// Arvore sintatica
struct nodeTree {
  struct nodeTree *firstNode; // primeiro no da arvore
  struct nodeTree *secondNode;// segundo no da arvore
  struct nodeTree *thirdNode; // terceiro no da arvore
  struct nodeTree *fourthNode;// quarto no da arvore
  char *nameNode;             // no vinculado na arvore
  char *firstSymbol;          // primeiro token da arvore
  char *secondSymbol;         // segundo token no da arvore
  char *thirdSymbol;          // terceiro token da arvore
};

// Arvore sintatica
struct symbolTable {
  char *nameObj;     // nome do objeto que esta no codigo 
  char *typeObj;     // int;float;set;elem
  char *localObj;    // variavel;funcao
  char *scope;       // escopo em que esta inserido
  UT_hash_handle hh; // auxiliar para hash
};

// Declaracoes escopo
struct element{
  char *typeObj;
  char *nameObj;
  char *scopeName;
  char *localObj;
  struct element *prev,*next;
};

struct nodeTree* syntaticTree = NULL;
struct symbolTable* syntaticTable = NULL;
struct element* elementParam = NULL;
struct element* elementParamCallFunction = NULL;
struct nodeTree* addition_node( struct nodeTree *firstNode, struct nodeTree *secondNode, struct nodeTree *thirdNode, struct nodeTree *fourthNode,  char *nameNode, char *firstSymbol, char *secondSymbol, char *thirdSymbol );
void addition_symbolTable(char *nameObj,char *typeObj,char *localObj);
void insert_scope();
void  show_elements();
void delete_elements();
char* concat(const char *s1, const char *s2);
void insert_scope(char *typeParam, char *nameParam, char *scope);
void verify_var_declaration(char *name);
void insert_function_scope();
%}

%union {
  char* string_node;
  struct nodeTree* node;
}

%type <node>  tradutor declaracoesExtenas declaracoesVariaveis funcoes parametros posDeclaracao tipagem sentencaLista sentenca
%type <node> conjuntoForall condicionalSentenca condicaoIF posIFForallExists iteracaoSentenca returnSentenca leituraEscritaSentenca
%type <node>  argumentos argumentosLista conjuntoSentenca conjuntoIN expressao expressaoFor expressaoSimplificada expressaoSimplificada2 expressaoSimplificada3
%type <node>  operacaoNumerica operacaoLogic termo operacaoComparacao operacaoMultDiv expressaoSimplificadaMinus


%token <string_node> TYPE_INT TYPE_FLOAT TYPE_ELEM TYPE_SET
%token <string_node> ID INT FLOAT STRING EMPTY_LABEL  ASSING CHAR
%token <string_node> IF ELSE FOR RETURN 
%token <string_node> COMPARABLES_EQUAL COMPARABLES_DIFF COMPARABLES_LTE COMPARABLES_GTE COMPARABLES_LT COMPARABLES_GT
%token <string_node> OR AND NEGATIVE MULT DIV ADD SUB 
%token <string_node> OUT_WRITELN OUT_WRITE IN_READ
%token <string_node> SET_IN SET_ADD SET_REMOVE SET_FORALL SET_IS_SET SET_EXISTS

%right THEN ELSE
%%

tradutor: 
  declaracoesExtenas  {if(DEPURADOR)printf("<tradutor> <== <declaracoesExternas>\n");
                        syntaticTree = $1;
                      }
;

declaracoesExtenas: funcoes                                 {if(DEPURADOR)printf("<declaracoesExternas> <==  <funcoes>\n");
                                                              $$ = $1;
                                                            }
                  | declaracoesVariaveis                    {if(DEPURADOR)printf("<declaracoesExternas> <== <declaracoesVariaveis>\n");
                                                              $$ = $1;
                                                            }
                  | declaracoesExtenas funcoes              {if(DEPURADOR)printf("<declaracoesExternas> <== <declaracoesExternas> <funcoes>\n");
                                                              $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);
                                                            }
                  | declaracoesExtenas declaracoesVariaveis {if(DEPURADOR)printf("<declaracoesExternas> <== <declaracoExternas> <declaracoesVariaveis>\n");
                                                              $$ = addition_node($1, $2, NULL, NULL, "declaracoesExternas", NULL, NULL, NULL);                                                              
                                                            }
                  | error                                   {deuErro =1;
                                                            }
;

declaracoesVariaveis: 
  tipagem ID ';' {if(DEPURADOR)printf("<declaracoesVariaveis> <== <tipagem> ID ';'\n");
                  $$ = addition_node($1, NULL, NULL, NULL, "declaracoesVariaveis", $2, NULL, NULL);
                  addition_symbolTable($2, $1->firstSymbol,  "Variavel");
                  insert_scope($1->firstSymbol, $2, "variavel");            
                 }
;

funcoes: tipagem ID { scope_current=$2;
                      insert_scope($1->firstSymbol,$2,"funcao");
                    }
      '(' parametros ')'  posDeclaracao {if(DEPURADOR)printf("<funcoes> <==  <tipagem> ID '(' <parametros> ')' <posDeclaracao>\n");
                                                       $$ = addition_node($1, $5, $7, NULL, "funcoes", $2, NULL, NULL);  
                                                       addition_symbolTable( $2, $1->firstSymbol, "Funcao");
                                                       scope_current = "GLOBAL"; // quando acaba a funcao, ele abre o escopo como gloabal
                                                      }
;

parametros: parametros ',' tipagem ID { if(DEPURADOR)printf("<parametros> <== <parametros> , <tipagem> ID\n");
                                        $$ = addition_node($1, $3, NULL, NULL, "parametros", $4, NULL, NULL);
                                        addition_symbolTable($4, $3->firstSymbol,  "Parametro");
                                        insert_scope($3->firstSymbol, $4, "parametro");              
                                      }
          | tipagem ID                { if(DEPURADOR)printf("<parametros> <== <tipagem> ID\n");
                                        $$ = addition_node($1,NULL ,NULL ,NULL , "parametros", $2, NULL, NULL);            
                                        addition_symbolTable($2, $1->firstSymbol,  "Parametro");
                                        insert_scope($1->firstSymbol, $2, "parametro");            
                                      }
          | %empty                    { if(DEPURADOR)printf("<parametros> <== E\n");
                                        $$ = NULL ;          
                                      }
;

posDeclaracao:   '{' sentencaLista '}' {if(DEPURADOR)printf("<posDeclaracao> <==  OPEN_CURLY <declaracoesVariaveisLocais> <sentencaLista> CLOSE_CURLY\n");
                                        $$ = $2;    
                                      }
; 

tipagem: TYPE_INT   { if(DEPURADOR)printf("<tipagem> <== TYPE_INT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_FLOAT { if(DEPURADOR)printf("<tipagem> <== TYPE_FLOAT\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_ELEM  { if(DEPURADOR)printf("<tipagem> <== TYPE_ELEM\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
       | TYPE_SET   { if(DEPURADOR)printf("<tipagem> <== TYPE_SET\n");
                      $$ = addition_node(NULL, NULL, NULL, NULL, "tipagem", $1, NULL, NULL);
                    }
;          

sentencaLista: sentencaLista sentenca { if(DEPURADOR)printf("<sentencaLista> <== <sentencaLista> <sentenca>\n");
                                        $$ = addition_node($1, $2, NULL, NULL, "sentecaLista", NULL, NULL, NULL);
                                      }
              | %empty                { if(DEPURADOR)printf("<sentencaLista> <== E\n");
                                        $$ = NULL;
                                      }
;

sentenca: condicionalSentenca    { if(DEPURADOR)printf("<sentenca> <== <condicionalSentenca>\n");
                                   $$ = $1;
                                 }
        | iteracaoSentenca       { if(DEPURADOR)printf("<sentenca> <== <iteracaoSentenca>\n");
                                   $$ = $1;
                                 }
        | returnSentenca         { if(DEPURADOR)printf("<sentenca> <== <returnSentenca>\n");
                                   $$ = $1;
                                 }
        | leituraEscritaSentenca { if(DEPURADOR)printf("<sentenca> <== <leituraEscritaSentenca>\n");
                                   $$ = $1;
                                 }
        | expressao              { if(DEPURADOR)printf("<sentenca> <== <expressao>\n");
                                   $$ = $1;
                                 }    
        | declaracoesVariaveis   { if(DEPURADOR)printf("<sentenca> <== <declaracoesVariaveis>\n");
                                   $$ = $1;
                                 }
        | conjuntoForall         { if(DEPURADOR)printf("<sentenca> <== <conjuntoForall>\n");
                                   $$ = $1;
                                 }  
        | error                   {deuErro =1;
                                  }
;

conjuntoForall:  SET_FORALL'('conjuntoIN ')' posIFForallExists  { if(DEPURADOR)printf("<conjuntoForall> <== SET_FORALL'('conjuntoIN ')' posIFForallExists \n");
                                                                  $$ = addition_node($3, $5, NULL, NULL, "conjuntoForall", $1, NULL, NULL);
                                                                }
;

condicionalSentenca: IF '(' condicaoIF ')' posIFForallExists %prec THEN             { if(DEPURADOR)printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao>\n");
                                                                                      $$ = addition_node($3, $5, NULL, NULL, "condicionalSentenca", $1, NULL, NULL);                                                                        
                                                                                    }
                   | IF '(' condicaoIF ')' posIFForallExists ELSE posIFForallExists {if(DEPURADOR)printf("<condicionalSentenca> <== IF '(' <condicaoIF> ')' <posDeclaracao> ELSE posDeclaracao\n");
                                                                                      $$ = addition_node($3, $5, $7, NULL, "condicionalSentenca", $1, $6 , NULL);                                                                        
                                                                                    }
;

condicaoIF: expressaoSimplificada           { if(DEPURADOR)printf("<condicaoIF> <== expressaoSimplificada\n");
                                              $$ = $1;                                                                                                  
                                            }
          | conjuntoIN                      { if(DEPURADOR)printf("<condicaoIF> <== conjuntoIN\n");
                                              $$ = $1;                                                                                                                    
                                            }
          | NEGATIVE expressaoSimplificada  { if(DEPURADOR)printf("<condicaoIF> <== NEGATIVE expressaoSimplificada\n");
                                              $$ = addition_node($2, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                                                                    
                                            }
          | NEGATIVE conjuntoIN             { if(DEPURADOR)printf("<condicaoIF> <== NEGATIVE conjuntoIN\n");
                                              $$ = addition_node($2, NULL, NULL, NULL, "condicaoIF", $1, NULL, NULL);                                                                                                                                                                
                                            }
          | '(' conjuntoIN ')'              { if(DEPURADOR)printf("<termo> <== ID '(' argumentos')' \n");
                                              $$ = $2;
                                            }
;

posIFForallExists: posDeclaracao  { if(DEPURADOR)printf("<posIFForallExists> <== posDeclaracao\n");
                                    $$ = $1;                                                                                                                                                                                                 
                                  }
                  | sentenca      { if(DEPURADOR)printf("<posIFForallExists> <== sentenca\n");
                                    $$ = $1;                                                                                                                                                                                    
                                  }
;

iteracaoSentenca:  FOR '(' expressao  expressaoSimplificada ';' expressaoFor ')' posDeclaracao { if(DEPURADOR)printf("<iteracaoSentenca> <== for '(' <expressao> ';' <expressaoSimplificada> ';' <expressao> ')' <posDeclaracao>\n");
                                                                                                 $$ = addition_node($3, $4, $6 , $8, "iteracaoSentenca", $1, NULL, NULL);                                                                                                                                                                                                                                                                                   
                                                                                               }
;

returnSentenca: RETURN expressaoSimplificada ';' { if(DEPURADOR)printf("<returnSentenca> <== RETURN expressaoSimplificada ';'\n");
                                                   $$ = addition_node($2 ,NULL ,NULL ,NULL, "returnSentenca",$1 ,NULL ,NULL);
                                                   insert_scope(NULL,$2->firstSymbol, "return");          
                                                 }
;

leituraEscritaSentenca: OUT_WRITE '('expressaoSimplificada')' ';'   { if(DEPURADOR)printf("<leituraEscritaSentenca> <== OUT_WRITE '('STRING')' ';' \n");
                                                                      $$ = addition_node($3 ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , NULL ,NULL);                                                                                                                                                                                                                        
                                                                    }
                      | OUT_WRITELN '('expressaoSimplificada')' ';' { if(DEPURADOR)printf("<leituraEscritaSentenca> <== OUT_WRITELN '('STRING')' ';'\n");
                                                                      $$ = addition_node($3 ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , NULL ,NULL);                                                                                                                                                                                                                                                                                   
                                                                    }
                      | IN_READ '('ID')' ';'                        { if(DEPURADOR)printf("<leituraEscritaSentenca> <== IN_READ '('ID')' ';'\n");
                                                                      $$ = addition_node(NULL ,NULL ,NULL ,NULL, "leituraEscritaSentenca",$1 , $3 ,NULL);                                                                                                                                                                                                                                                                                   
                                                                    }                      
;

argumentos: argumentosLista { if(DEPURADOR)printf("<argumentos> <== <argumentosLista>\n");
                              $$ = $1;          
                            }
          | %empty          { if(DEPURADOR)printf("<argumentos> <== E\n");
                              $$ = NULL;
                            }
;

argumentosLista: expressaoSimplificada                      { if(DEPURADOR)printf("<argumentosLista> <== <expressaoSimplificada>\n");
                                                              $$ = $1;         
                                                              insert_scope(NULL,$1->firstSymbol, "argumento");                                                                                                                                                                    
                                                            }
               |  argumentosLista ',' expressaoSimplificada { if(DEPURADOR)printf("<argumentosLista> <== <expressaoSimplificada> ',' <argumentosLista>\n");
                                                              $$ = addition_node($1 ,$3 ,NULL ,NULL, "argumentosLista", NULL , NULL ,NULL);                                                             
                                                              insert_scope(NULL,$3->firstSymbol, "argumento");          
                                                            }
     
;

conjuntoSentenca: SET_ADD '(' conjuntoIN ')'    { if(DEPURADOR)printf("<conjuntoSentenca> <== SET_ADD '(' conjuntoIN ')' \n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL); 
                                                     }
                | SET_REMOVE '(' conjuntoIN')'  { if(DEPURADOR)printf("<conjuntoSentenca> <== SET_REMOVE '(' conjuntoIN')'  \n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL);
                                                     }
                | SET_IS_SET '(' ID ')'              { if(DEPURADOR)printf("<conjuntoSentenca> <== SET_IS_SET '(' ID ')' \n");
                                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , $3 ,NULL);
                                                     }      
                | SET_EXISTS '('conjuntoIN ')'  { if(DEPURADOR)printf("<conjuntoSentenca> <== SET_EXISTS '('conjuntoIN ')' \n");
                                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "conjuntoSentenca", $1 , NULL ,NULL);
                                                     }
;

conjuntoIN: expressaoSimplificada SET_IN conjuntoSentenca    { if(DEPURADOR)printf("<conjuntoIN> <== expressao SET_IN conjuntoSentenca\n");
                                                                    $$ = addition_node($1 ,$3 ,NULL ,NULL, "conjuntoIN", $2 , NULL ,NULL);
                                                                  }
          | expressaoSimplificada SET_IN ID                  { if(DEPURADOR)printf("<conjuntoIN> <== expressaoSimplificada SET_IN ID\n");
                                                                    $$ = addition_node($1 ,NULL ,NULL ,NULL, "conjuntoIN", $2 ,$3 ,NULL);
                                                                  }       
;                    

expressao: ID ASSING expressao        { if(DEPURADOR)printf("<expressao> <== ID ASSING expressao\n");
                                        $$ = addition_node($3 ,NULL ,NULL ,NULL, "expressao", $1 , $2 ,NULL);
                                        verify_var_declaration($1); 
                                      }                                       
         | expressaoSimplificada ';'  { if(DEPURADOR)printf("<expressao> <== expressaoSimplificada\n");
                                        $$ = $1; 
                                      }
;    

expressaoFor: ID ASSING expressaoFor { if(DEPURADOR)printf("<expressaoFor> <== ID ASSING expressaoFor\n");
                                       $$ = addition_node($3 ,NULL ,NULL ,NULL, "expressaoFor", $1, $2 ,NULL);  
                                     }
             |expressaoSimplificada  { if(DEPURADOR)printf("<expressaoFor> <== expressaoSimplificada\n");
                                       $$ = $1; 
                                     } 
; 

expressaoSimplificada:  expressaoSimplificada operacaoLogic termo       { if(DEPURADOR)printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoLogic> <termo>\n");
                                                                         $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoOperacao", NULL, NULL ,NULL);  
                                                                        } 
                        | expressaoSimplificada2                        { if(DEPURADOR)printf("<expressaoSimplificada> <== <termo>\n");
                                                                          $$ = $1;
                                                                        }

;

expressaoSimplificada2: expressaoSimplificada operacaoNumerica termo     { if(DEPURADOR)printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoNumerica> <termo>\n");
                                                                          $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoOperacao", NULL, NULL ,NULL);
                                                                        }
                     | expressaoSimplificada3                           { if(DEPURADOR)printf("<expressaoSimplificada> <== <termo>\n");
                                                                          $$ = $1;
                                                                        }
;

expressaoSimplificada3: expressaoSimplificada operacaoMultDiv termo     { if(DEPURADOR)printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoMultDiv> <termo>\n");
                                                                          $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoOperacao", NULL, NULL ,NULL);  
                                                                        }  
                      | expressaoSimplificada operacaoComparacao termo  { if(DEPURADOR)printf("<expressaoSimplificada> <== <expressaoOperacao> <operacaoComparacao> <expressaoOperacao>\n");
                                                                         $$ = addition_node($1 ,$2 ,$3 ,NULL, "expressaoSimplificada", NULL, NULL ,NULL);
                                                                        }
                      | expressaoSimplificadaMinus                                           { if(DEPURADOR)printf("<expressaoSimplificada> <== <termo>\n");
                                                                          $$ = $1;
                                                                        }
;

expressaoSimplificadaMinus: 
    SUB termo { if(DEPURADOR)printf("<expressaoSimplificada> <== <termo>\n");
                 $$ = addition_node($2 ,NULL ,NULL ,NULL, "expressaoSimplificada", $1, NULL ,NULL);                                                       
              }
  | termo     { if(DEPURADOR)printf("<expressaoSimplificada> <== <termo>\n");
                $$ = $1;
              }
;

;
operacaoNumerica: ADD  { if(DEPURADOR)printf("<operacaoNumerica> <== ADD\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoNumerica", $1, NULL ,NULL);
                       }
                | SUB  { if(DEPURADOR)printf("<operacaoNumerica> <== SUB\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoNumerica", $1, NULL ,NULL);
                       }
             
;    

operacaoMultDiv: MULT { if(DEPURADOR)printf("<operacaoMultDiv> <== MULT\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoMultDiv", $1, NULL ,NULL);
                       }
                | DIV  { if(DEPURADOR)printf("<operacaoMultDiv> <== DIV\n");
                         $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoMultDiv", $1, NULL ,NULL);
                       }
;

operacaoLogic: OR        { if(DEPURADOR)printf("<operacaoLogic> <== OR\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL);
                         }
             | AND       { if(DEPURADOR)printf("<operacaoLogic> <== AND\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL);
                         }
             | NEGATIVE  { if(DEPURADOR)printf("<operacaoLogic> <== NEGATIVE\n");
                           $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoLogic", $1, NULL ,NULL); 
                         }
;

operacaoComparacao: COMPARABLES_EQUAL { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_EQUAL\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_DIFF  { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_DIFF\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_LTE   { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_GTE   { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_LT    { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
                  | COMPARABLES_GT    { if(DEPURADOR)printf("<operacaoComparacao> <== COMPARABLES_GT\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "operacaoComparacao", $1, NULL ,NULL);
                                      }
;                        

termo: '(' expressaoSimplificada ')' { if(DEPURADOR)printf("<termo> <== '(' <expressaoSimplificada> ')'\n");
                                       $$ = $2;
                                     }
     | ID                            { if(DEPURADOR)printf("<termo> <== ID\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);  
                                       verify_var_declaration($1);
                                     }
     | INT                           { if(DEPURADOR)printf("<termo> <== INT\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }     
     | FLOAT                         { if(DEPURADOR)printf("<termo> <== FLOAT\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | EMPTY_LABEL                   { if(DEPURADOR)printf("<termo> <== EMPTY_LABEL\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | STRING                        { if(DEPURADOR)printf("<termo> <== QUOTES STRING QUOTES\n");
                                       $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | CHAR                          { if(DEPURADOR)printf("<termo> <== QUOTES CHAR QUOTES\n");
                                        $$ = addition_node(NULL ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                     }
     | ID                            {  //scope_current_aux = scope_current;
                                        //scope_current = $1;
                                        insert_scope("call", $1, "callFunc");
                                     }
     '(' argumentos')'               { if(DEPURADOR)printf("<termo> <== ID '(' argumentos')' \n");
                                       $$ = addition_node($4 ,NULL ,NULL ,NULL, "termo", $1, NULL ,NULL);
                                       //scope_current = scope_current_aux;
                                       insert_function_scope($1);
                                     }
     | conjuntoSentenca              { if(DEPURADOR)printf("<termo> <== ID '(' argumentos')' \n");
                                       $$ = $1;
                                     }     

;

%%      

void insert_scope(char *typeParam, char *nameParam, char *local){
  struct element* obj = (struct element*)malloc(sizeof(struct element));
  
  obj->typeObj = typeParam;
  obj->nameObj = nameParam;
  obj->scopeName = scope_current;
  obj->localObj = local;
  DL_APPEND(elementParam, obj);
}

char* concat(const char *str1, const char *str2){
  char *output = malloc(strlen(str1) + strlen(str2) + 1);
  strcpy(output, str1);
  strcat(output, str2);
  return output;
}

void insert_function_scope(char *nameFunction){
  struct element *obj =  (struct element*)malloc(sizeof(struct element));
  DL_FOREACH(elementParam,obj) {
    if(strcmp(scope_current,obj->scopeName)==0 && strcmp("argumento", obj->localObj)==0 && obj->typeObj == NULL){
      obj->typeObj = nameFunction;
    }
  }
}

void verify_var_declaration(char *name){
  struct element *obj =  (struct element*)malloc(sizeof(struct element));
  int passou = 0;
  DL_FOREACH(elementParam,obj) { 
    if(strcmp(name,obj->nameObj)==0 && strcmp(scope_current,obj->scopeName)==0 ){
      passou = 1;
    }
  }
  if (passou == 0){
    printf("\n##### Ocorreu erro SEMANTICO ######\n");
    printf("\n\t[ERRO SEMANTICO] linha = %d, coluna = %d, variável %s não declarada\n\n", currentLine, positionWord, name);
    printf("##### Fim Erro     #####\n\n");
  }
}

void show_elements(){
  struct element *elt =  (struct element*)malloc(sizeof(struct element));
  DL_FOREACH(elementParam,elt) {
    printf("type= %15s\t",elt->typeObj);
    printf("|id= %15s\t",elt->nameObj);
    printf("|scope= %15s\t", elt->scopeName);
    printf("|local= %15s\n", elt->localObj);
  }
  printf("\n\n");
}

void delete_elements(){
  struct element *elt =  (struct element*)malloc(sizeof(struct element));
  struct element *tmp =  (struct element*)malloc(sizeof(struct element)); // ACHO QUE TEREI QUE DAR FREE DPS
  DL_FOREACH_SAFE(elementParam,elt,tmp) {
    DL_DELETE(elementParam,elt);
    free(elt);
  }
}

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

void show_tree( int positionTree, struct nodeTree *nodeTree) {
  if (nodeTree) {
    if(nodeTree->firstSymbol != NULL) {
      int i=0;
      while(i < positionTree){
        printf("__");
        i++;
      }
      printf("//  %s  -->  ", nodeTree->nameNode);
      printf(" '%s' / ", nodeTree->firstSymbol);
      if(nodeTree->secondSymbol != NULL) {
        printf(" '%s' / ", nodeTree->secondSymbol);
      }
      if(nodeTree->thirdSymbol != NULL) {
        printf(" '%s' ", nodeTree->thirdSymbol);
      }
      printf("\n");
    }
    show_tree(positionTree+1, nodeTree->firstNode );
    show_tree(positionTree+1, nodeTree->secondNode );
    show_tree(positionTree+1, nodeTree->thirdNode );
    show_tree(positionTree+1, nodeTree->fourthNode );
  }
}

void free_tree(struct nodeTree *nodeTree){
  if(!nodeTree)return;
  free_tree(nodeTree->firstNode );
  free_tree(nodeTree->secondNode );
  free_tree(nodeTree->thirdNode );
  free_tree(nodeTree->fourthNode );
  if(nodeTree->firstSymbol!= NULL) free(nodeTree->firstSymbol); 
  if(nodeTree->secondSymbol!= NULL) free(nodeTree->secondSymbol); 
  if(nodeTree->thirdSymbol!= NULL) free(nodeTree->thirdSymbol); 
  free(nodeTree);
}

void addition_symbolTable(char *nameObj,char *typeObj,char *localObj){
  struct symbolTable *obj = (struct symbolTable*)malloc(sizeof (struct symbolTable));
  obj->nameObj = nameObj;
  obj->typeObj = typeObj;
  obj->localObj = localObj;

  char *concatStringScope = malloc(strlen(nameObj) + strlen(localObj) + 1);
  strcpy(concatStringScope, nameObj);
  strcat(concatStringScope, localObj);
  // printf("Concat string  = %s", concatStringScope );
  obj->scope = concatStringScope;

  HASH_ADD_STR(syntaticTable, nameObj, obj);
  
}

void show_symbolTable() {
  struct symbolTable *obj;

  for(obj=syntaticTable; obj != NULL; obj=obj->hh.next) {
    printf("nameObj: %20s | typeObj: %10s | localObj: %10s | scope: %10s\n", obj->nameObj, obj->typeObj, obj->localObj, obj->scope);
  }

}

void free_symbolTable(){
    struct symbolTable *s, *tmp;
    HASH_ITER(hh, syntaticTable, s, tmp) {
      HASH_DEL(syntaticTable, s);
      free(s);
    }
}

void yyerror(const char *string_node) {
    printf("\n##### Ocorreu erro SINTATICO ######\n");
    printf("\n\t[ERRO SINTATICO] linha = %d, coluna = %d, yyerror = %s\n\n", currentLine, positionWord, string_node);
    printf("##### Fim Erro     #####\n\n");
}

// Got from documentation flex https://westes.github.io/flex/manual/Simple-Examples.html#Simple-Examples
int main( int argc, char **argv ){
  ++argv, --argc;
  int begginTree = 0;
  if ( argc > 0 )yyin = fopen( argv[0], "r" );else yyin = stdin; 

  yyparse();
  if(deuErro == 0){
    printf("\n\n ####  Arvore Sintatica  #### \n\n");
    show_tree(begginTree, syntaticTree);
    printf("\n\n ####  Tabela Sintatica  #### \n\n");
    show_symbolTable();
    show_elements();

    free_tree(syntaticTree); 
    free_symbolTable(syntaticTree); 

  }
  else{
    printf("\n\nERROS APARECERAM! NAO SERA MOSTRADO A ARVORE SINTATICA NEM A TABELA DE SIMBOLOS\n");
  }
  fclose(yyin);
  yylex_destroy();
  return 0;
}