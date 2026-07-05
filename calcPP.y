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
void isInteger(const char *num);
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
%token <string> NUM ID PALAVRAS

%locations

%start linhas

%right '='
%left '+' '-'
%left '*' '/' '%'

%left OR
%left AND

%%

linhas
    : linha
    | linhas linha
    ;

prints : print
      | prints print
      | EOL  { };

print : expr_bool { printf("s - [print | S].\n"); fflush(stdout); }
      | PALAVRAS { 
        print_string($1);        
        fflush(stdout); 
        }
      ;

linha
    : expr eol_opcional            { }
    | ID '=' expr                  { printf("var - [%s | S].\n", $1); fflush(stdout); }
    | IF '(' cond_marcada ')' eol_opcional bloco {
                                        printf("cond - [if | S].\n");
                                        fflush(stdout);
                                    }
    | IF '(' cond_marcada ')' eol_opcional bloco ELSE eol_opcional {
                                        printf("cond - [else | S].\n");
                                        fflush(stdout);
                                    } bloco
                                    { }
    | WHILE
                                    {
                                        printf("while - [inicio | S].\n");
                                        fflush(stdout);
                                    }
      '(' cond_marcada ')' eol_opcional bloco
                                    {
                                        printf("while - [fim | S].\n");
                                        fflush(stdout);
                                    }
    | IO '=' prints eol_opcional    { }
    | EOL                           { }
    ;

cond_marcada
    : expr_bool                    {
                                        printf("condicao - [fim | S].\n");
                                        fflush(stdout);
                                    }
    ;

expr_bool
    : expr                                  { }
    | expr '<' expr                         { printf("bool - [< | S].\n"); }
    | expr '>' expr                         { printf("bool - [> | S].\n"); }
    | expr EQ expr                          { printf("bool - [== | S].\n"); }
    | expr NEQ expr                         { printf("bool - [/= | S].\n"); }
    | expr GE expr                          { printf("bool - [>= | S].\n"); }
    | expr LE expr                          { printf("bool - [<= | S].\n"); }
    | expr_bool AND expr_bool               { printf("bool - [&& | S].\n"); }
    | expr_bool OR expr_bool                { printf("bool - [or | S].\n"); }
    | '(' expr_bool ')'                     { }
    ;

eol_opcional
    : /* vazio */
    | EOL
    ;

bloco
    : '{' eol_opcional              {
                                         printf("bloco - [abre | S].\n");
                                         fflush(stdout);
                                     }
      linhas_opcional '}'           {
                                         printf("bloco - [fecha | S].\n");
                                         fflush(stdout);
                                     }
    ;

linhas_opcional
    : /* vazio */
    | linhas
    ;

expr
    : NUM                   { isInteger($1); printf("s - [%s | S].\n", $1); }
    | ID                    { printf("val - [%s | S].\n", $1); }
    | expr '+' expr         { printf("op - [+ | S].\n"); }
    | expr '-' expr         { printf("op - [- | S].\n"); }
    | expr '*' expr         { printf("op - [* | S].\n"); }
    | expr '/' expr         { printf("op - [/ | S].\n"); }
    | expr '%' expr         { printf("op - ['%%' | S].\n"); }
    | '(' expr ')'          { }
    ;

%%

extern int yychar;         
extern char linha_atual[];

void yyerror(char const *e) {
    if (yychar == ELSE) {
        fprintf(stderr, "\033[1;31mErro de Sintaxe: 'else' sem 'if' correspondente (linha %d, coluna %d): %s\033[0m\n",
                yylloc.first_line, yylloc.first_column, linha_atual);
        exit(1);
    }

    fprintf(stderr, "\033[1;31mAlerta: %s (linha %d, coluna %d): %s\033[0m\n",
            e, yylloc.first_line, yylloc.first_column, linha_atual);
    exit(1);
}

void isInteger(const char *num) {

    if (num == NULL || *num == '\0')
        yyerror("Erro de Semantica - Valor da variavel invalido ou Sistema sem espaco");

    char *endPtr;
    errno = 0;

    long valor_long = strtol(num, &endPtr, 10);

    if (errno == ERANGE)
        yyerror("Erro de Semantica - Valor lido excede o valor maximo de um inteiro");

    if (endPtr == num)
        yyerror("Erro de Semantica - O dominio de valores a atribuir deve ser o conjunto dos numeros inteiros");

    if (*endPtr != '\0' && *endPtr != '\n')
        yyerror("Erro de Semantica - O valor da variavel deve ser todo inteiro!");

    if (valor_long < INT_MIN || valor_long > INT_MAX)
        yyerror("Erro de Semantica - Valor excede o valor admitido por um inteiro!");
}

int main(int argc, char **argv) {
    yylloc.first_line = yylloc.last_line = 1;
    yylloc.first_column = yylloc.last_column = 1;
    yyparse();
    printf("end_of_file.\n");
    return 0;
}