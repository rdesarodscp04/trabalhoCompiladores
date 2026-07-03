%{
//#include PROG ".tab.h"
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


[a-z][a-zA-Z0-9_]*    { yylval.string = strdup(yytext); return ID; }

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

%%
