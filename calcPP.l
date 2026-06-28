%{
//#include PROG ".tab.h"
#include "calcPP.tab.h"

%}

%%

[0-9]+		          { yylval.string = strdup (yytext); return NUM; }
[a-z][a-zA-Z0-9_]*    { yylval.string = strdup(yytext); return ID; }

"("		return '(';
")"		return ')';
"+"		return '+';
"-"		return '-';
"*"		return '*';
"/"		return '/';
"="     return '=';
"%"     return '%';

;		return EOL;
\n		return EOL;

[ \t]+		{}

%%
