%{

//#include PROG ".tab.h"
#include "contas-pl.tab.h"

%}

%%

[0-9]+		{ yylval.string = strdup (yytext); return NUM; }

"("		return '(';
")"		return ')';
"+"		return '+';
"-"		return '-';
"*"		return '*';
"/"		return '/';

;		return EOL;
\n		return EOL;

[ \t]+		{}

%%
