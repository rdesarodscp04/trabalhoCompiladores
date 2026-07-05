%{ // -*- Bison -*-

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>

int yylex(void);
int yywrap(void) { return 1; }   

void yyerror(char const *e);
void valida_inteiro(const char *num);
void print_string(char *string);

void print_string(char *string) {
    int tamanho_string = strlen(string) - 1;

    for(int i = 1; i < tamanho_string ; i++){
        if(string[i] == ' '){
            printf("print_char(espaco).\n");
        }else{
            printf("print_char(%c).\n", string[i]);
        }
    }
}

%}

%union { char *string; }  

%token EOL EQ NEQ IO GE LE IF ELSE WHILE AND OR
%token <string> NUM ID

%start programa

%right '='
%left '+' '-'
%left '*' '/' '%'

%left OR
%left AND

%%

programa
    : instrucao
    | programa instrucao
    ;

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
      | EOL  { }
      ;

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
          | expr_bool AND expr_bool { printf("bool - [&& | S].\n"); }
          | expr_bool OR expr_bool  { printf("bool - [or | S].\n"); }
          | '(' expr_bool ')'       { }
          ;

bloco : '{' { printf("bloco - [abre | S].\n"); fflush(stdout); } { printf("bloco - [fecha | S].\n"); fflush(stdout); } '}'
      | '{' EOL { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      | '{'  { printf("bloco - [abre | S].\n"); fflush(stdout); } linhas '}' { printf("bloco - [fecha | S].\n"); fflush(stdout); }
      |'{' EOL { printf("bloco - [abre | S].\n"); fflush(stdout); } { printf("bloco - [fecha | S].\n"); fflush(stdout); } '}'
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