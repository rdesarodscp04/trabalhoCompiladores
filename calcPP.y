%{ // -*- Bison -*-

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>

void yyerror (char const *e) {
  fprintf (stderr, "ouch: %s\n", e);
  exit(1);
}

void converter_int(const char * num) {

  if ( *num == '\0' || num == NULL )
    yyerror("Semantic Error: Valor da varivel invalido ou Sistema sem espaço");

  char *endPtr;
  errno = 0;

  long valor_long = strtol(num, &endPtr, 10);

  if ( errno == ERANGE )
    yyerror("Semantic: Valor lido excede o valor maximo de um inteiro");

  if ( endPtr == num )
    yyerror("Semantic Error: O dominio de valores a atribuir deve ser o conjunto dos numeros inteiros ");
  
  if ( *endPtr != '\0' && *endPtr != '\n' )
    yyerror("Semantic Error: O valor da variavel deve ser todo inteiro! ");
  
  if(valor_long < INT_MIN || valor_long > INT_MAX)
    yyerror("Semantic Error: Valor excede o valor admitido por um inteiro!");
}

void yywrap() {}
int yylex();

%}

%union { char *string; }  

%token EOL EQ NEQ IO GE LE
%token <string> NUM ID IF ELSE WHILE

%start linhas

%right '='
%left '+' '-'
%left '*' '/' '%'

%%

linhas : linha
       | linhas linha ;

linha : expr EOL               { }
      | IO '=' expr_bool            { printf("s - [print | S].\n");  fflush(stdout); }
      | ID '=' expr            { 
                                    printf("var - [%s | S].\n", $1); 
                                    fflush(stdout);
                               }
      
      | IF '(' cond_marcada ')' bloco  {
                                printf("cond - [if | S].\n");
                                fflush(stdout);
                               }
      
      
      | IF '(' cond_marcada ')' bloco ELSE {
                                printf("cond - [else | S].\n");
                                fflush(stdout);
                               } bloco { 
                               }
      | WHILE { 
                printf("while - [inicio | S].\n"); 
                fflush(stdout); 
              } 
      '(' cond_marcada ')' bloco 
              {
                printf("while - [fim | S].\n");
                fflush(stdout);
              }
      | EOL ;

cond_marcada : expr_bool            { 
                                printf("condicao - [fim | S].\n"); 
                                fflush(stdout); 
                               }
             ;
          
expr_bool : expr              { }
          | expr '<' expr     {printf("bool - [< | S].\n"); }  
          | expr '>' expr     { printf("bool - [> | S].\n"); }
          | expr EQ expr      {printf("bool - [== | S].\n");  }
          | expr NEQ expr     {printf("bool - [/= | S].\n");  }
          | expr GE expr      { printf("bool - [>= | S].\n"); }
          | expr LE expr      { printf("bool - [<= | S].\n"); }
          ;

bloco : 
      | '{' EOL { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      | '{'  { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      ;

expr : NUM                     { converter_int($1); printf("s - [%s | S].\n", $1); }
     | ID                      { printf("val - [%s | S].\n", $1); }
     | expr '+' expr           { printf("op - [+ | S].\n"); }
     | expr '-' expr           { printf("op - [- | S].\n"); }
     | expr '*' expr           { printf("op - [* | S].\n"); }
     | expr '/' expr           { printf("op - [/ | S].\n"); }
     | expr '%' expr           { printf("op - ['%%' | S].\n"); }
     | '(' expr ')'            { }
     ;

%%

int main (int argc, char **argv) {
  yyparse();
  printf("end_of_file.\n");
}
