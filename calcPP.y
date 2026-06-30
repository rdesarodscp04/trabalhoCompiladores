%{ // -*- Bison -*-

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror (char const *e) {
  fprintf (stderr, "ouch: %s\n", e);
  exit(1);
}

void yywrap() {}
int yylex();

%}

%union { char *string; }

%token EOL
%token <string> NUM ID IF ELSE

%start linhas

%right '='
%left '+' '-'
%left '*' '/' '%'

%%

linhas : linha
       | linhas linha ;

linha : expr EOL               { }
      | ID '=' expr            { 
                                if (strcmp($1, "io") == 0) {
                                    printf("s - [print | S].\n"); 
                                    fflush(stdout);
                                } else {
                                    printf("var - [%s | S].\n", $1); 
                                    fflush(stdout); 
                                }
                               }
      
      | IF '('cond_marcada ')' bloco  {
                                printf("cond - [if | S].\n");
                                fflush(stdout);
                               }
      | IF '('cond_marcada ')' bloco ELSE bloco {
                                printf("cond - [ifelse | S].\n");
                                fflush(stdout);
                               }
      | EOL ;

cond_marcada : expr            { 
                                printf("condicao - [ fim | S].\n"); 
                                fflush(stdout); 
                               }
             ;

bloco : 
      | '{' EOL { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      | '{'  { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      ;

expr : NUM                     { printf("s - [%s | S].\n", $1); }
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