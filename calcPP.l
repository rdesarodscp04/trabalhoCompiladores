%{
//#include PROG ".tab.h"
#include "calcPP.tab.h"

%}

%%

[0-9]+		          { yylval.string = strdup (yytext); return NUM; }
\"[^\"]*\"              { yylval.string = strdup(yytext); return PALAVRAS; }

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

[0-9]+[a-zA-Z_][a-zA-Z0-9_]*   { 
                                    fprintf(stderr, "Erro Léxico: '%s' não é um inteiro válido!\n", yytext); 
                                    exit(1); 
                               }

"<"   return '<';
">"   return '>';


"("		return '(';
")"		return ')';
"+"		return '+';
"-"		return '-';
"*"		return '*';
"/"		return '/';
"="     return '=';
"%"     return '%';
"{"     return '{';  
"}"     return '}'; 
;		return EOL;
\n		return EOL;

[ \t]+		{}
"#"([^\\\n]|\\.)* { /* ignora o comentário */ }

%%
