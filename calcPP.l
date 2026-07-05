%{

#include "calcPP.tab.h"

%}

%%

[0-9]+		          { yylval.string = strdup (yytext); return NUM; }

if                     { return IF; }
else                   { return ELSE; }
"=="                     { return EQ; }
"/="                    { return NEQ; }
while                  { return WHILE; }
">="                    { return GE; }
"<="                    { return LE; }
io                   { return IO; }
"&&"    { return AND; }
"||"    { return OR; }


[a-z][a-zA-Z0-9_]*    { yylval.string = strdup(yytext); return ID; }

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