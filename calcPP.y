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
%token <string> NUM ID

%start linhas

%right '='
%left '+' '-'
%left '*' '/'

%%

linhas : linha
       | linhas linha ;

linha : expr EOL               { }
      | ID '=' expr            { 
                                if (strcmp($1, "io") == 0) {
                            
                                    printf("s - [print | S].\n"); 
                                    fflush(stdout);

                                  }else{
                                        printf("var - [%s | S].\n", $1); 
                                        fflush(stdout); 
                                      }
                                  }
                                   
      
      | EOL

expr : NUM                     { printf("s - [%s | S].\n", $1); }
     | ID                      { printf("val - [%s | S].\n", $1); }
     | expr '+' expr           { printf("op - [+ | S].\n"); }
     | expr '-' expr           { printf("op - [- | S].\n"); }
     | expr '*' expr           { printf("op - [* | S].\n"); }
     | expr '/' expr           { printf("op - [/ | S].\n"); }
     | '(' expr ')'
     ;

%%

int main (int argc, char **argv) {
  yyparse();
  printf("end_of_file.\n");
}