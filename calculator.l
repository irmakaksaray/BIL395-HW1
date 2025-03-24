%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"  /* Yacc tarafından oluşturulan token tanımları */
extern YYSTYPE yylval;
%}

/* Lex kuralları */
%%
"exit" { return EXIT; }  /* Kullanıcı 'exit' yazarsa özel token döndür */
[0-9]+"."[0-9]+    {  
    yylval.dval = atof(yytext);  
    return NUMBER;
}
[0-9]+             {  
    yylval.dval = atof(yytext);  
    return NUMBER;
}
[A-Za-z][A-Za-z0-9]*  {  
    yylval.sval = strdup(yytext);  
    return ID;
}
"+"    { return '+'; }
"-"    { return '-'; }
"*"    { return '*'; }
"/"    { return '/'; }
"^"    { return '^'; }
"="    { return '='; }
"("    { return '('; }
")"    { return ')'; }
[ \t]+ { /* Boşlukları yoksay */ }
\n     { return '\n'; }  /* Satır sonunu düzgün yakala */
.      {  
    fprintf(stderr, "Error: Unrecognized character '%c'\n", yytext[0]);
}
%%

int yywrap(void) { return 1; }
