%{ // -*- Bison -*-

#include <stdlib.h>
#include <stdio.h>

void yyerror (char const *e) {
  fprintf (stderr, "ouch: %s\n", e);
  exit(1);
}

void yywrap() {}

int yylex();

%}

%union { char *string; }

%token EOL
%token <string> NUM ID

%start linhas

%right '='
%left '+' '-'
%left '*' '/'

%%

linhas : linha
       | linhas linha ;

linha : expr EOL               { printf("S - [print | S].\n"); fflush(stdout); }
      | ID '=' expr            { printf("Var - [%s | S].\n", $1); fflush(stdout); }
      | EOL

expr : NUM                     { printf("S - [%s | S].\n", $1); }
     | ID                      { printf("Var - [%s | S].\n", $1); }
     | expr '+' expr           { printf("Op - [+ | S].\n"); }
     | expr '-' expr           { printf("Op - [- | S].\n"); }
     | expr '*' expr           { printf("Op - [* | S].\n"); }
     | expr '/' expr           { printf("Op - [/ | S].\n"); }
     | '(' expr ')'
     ;

%%

int main (int argc, char **argv) {
  yyparse();
  printf("end_of_file.\n");
}