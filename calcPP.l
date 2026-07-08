%{

#include "calcPP.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_LINHA 1024
#define MAX_ID    64
#define MAX_NUM   10  
#define MAX_STR   256

char linha_atual[MAX_LINHA] = "";
static int pos_linha = 0;

#define YY_USER_ACTION atualizar_localizacao();

static void atualizar_localizacao() {
    int i;
    yylloc.first_line   = yylloc.last_line;
    yylloc.first_column = yylloc.last_column;

    for (i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') {
            yylloc.last_line++;
            yylloc.last_column = 1;
            pos_linha = 0;
            linha_atual[0] = '\0';
        } else {
            yylloc.last_column++;
            if (pos_linha < MAX_LINHA - 1)
                linha_atual[pos_linha++] = yytext[i];
            linha_atual[pos_linha] = '\0';
        }
    }
}

static void erro_tamanho(const char *tipo, int n, int max) {
    fprintf(stderr,
            "\033[1;31mErro Léxico: %s demasiado longo (%d caracteres, máximo permitido = %d)\033[0m\n",
            tipo, n, max);
    exit(1);
}

%}

%%

[0-9]+		          { yylval.string = strdup (yytext); return NUM; }
\"[^\"]*\"              { yylval.string = strdup(yytext); return PALAVRAS; }

[a-z][a-zA-Z0-9_]* {
    int n = strlen(yytext);
    if (n > MAX_ID)
        erro_tamanho("ID", n, MAX_ID);

    yylval.string = strdup(yytext);
    return ID;
}

[0-9]+ {
    int n = strlen(yytext);
    if (n > MAX_NUM)
        erro_tamanho("Número", n, INT_MAX);

    yylval.string = strdup(yytext);
    return NUM;
}

\"[^\"]*\" {
    int n = strlen(yytext);
    if (n > MAX_STR)
        erro_tamanho("String", n, MAX_STR);

    yylval.string = strdup(yytext);
    return STRING;
}

[0-9]+[a-zA-Z_][a-zA-Z0-9_]* {
    fprintf(stderr, "\033[1;31mErro Léxico: '%s' não é um inteiro válido!\033[0m\n", yytext);
    exit(1);
}

"=="                               { return EQ; }
"/="                               { return NEQ; }
">="                               { return GE; }
"<="                               { return LE; }
"&&"                               { return AND; }
"||"                               { return OR; }

"<"                                return '<';
">"                                return '>';
"("                                return '(';
")"                                return ')';
"+"                                return '+';
"-"                                return '-';
"*"                                return '*';
"/"                                return '/';
"="                                return '=';
"%"                                return '%';
"{"                                return '{';
"}"                                return '}';

;                                  return EOL;
\n                                 return EOL;

[ \t]+                             {}

"#"([^\\\n]|\\.)*                  {}
. {
    fprintf(stderr, "\033[1;31mErro Léxico: caracter inesperado '%s'\033[0m\n", yytext);
    exit(1);
}
%%