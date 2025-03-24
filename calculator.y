%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int yylex();  /* Lex tarafından tanımlanan yylex() fonksiyonunu belirt */
void yyerror(const char *msg);

#define MAXVARS 100

typedef struct {
    char* name;
    double value;
} Symbol;

static Symbol symTable[MAXVARS];
static int symCount = 0;
static int errorFlag = 0;

/* Değişken arama fonksiyonu */
static Symbol* lookup(const char *name) {
    for (int i = 0; i < symCount; ++i) {
        if (strcmp(name, symTable[i].name) == 0) {
            return &symTable[i];
        }
    }
    return NULL;
}

/* Yeni değişken oluşturma fonksiyonu */
static Symbol* createVar(char *name) {
    if (symCount < MAXVARS) {
        symTable[symCount].name = strdup(name);
        symTable[symCount].value = 0.0;
        return &symTable[symCount++];
    }
    return NULL;
}
%}

/* Veri türleri */
%union {
    double dval;
    char* sval;
}

/* Token tanımları */
%token <dval> NUMBER
%token <sval> ID
%token EXIT   /* 'exit' komutunu tanımlayan token */

/* Operatör öncelikleri */
%right '='
%left '+' '-'
%left '*' '/'
%right '^'

/* Nonterminal tip tanımları */
%type <dval> expr

%%

/* Giriş */
input:
    /* boş */
    | input line
    ;

line:
    '\n'
    | expr '\n' {  
          if (!errorFlag) {
              printf("= %g\n", $1);
          }
          errorFlag = 0;
      }
    | EXIT '\n' {  /* Kullanıcı "exit" yazarsa */
          printf("Logging out...\n");
          exit(0);  /* Programı sonlandır */
      }
    | error '\n' {
          errorFlag = 0;
          yyerrok;
          fprintf(stderr, "Error: Invalid expression\n");
      }
    ;

expr:
    expr '+' expr   { $$ = $1 + $3; }
    | expr '-' expr   { $$ = $1 - $3; }
    | expr '*' expr   { $$ = $1 * $3; }
    | expr '/' expr   {
          if ($3 == 0) {
              fprintf(stderr, "Error: Division by zero\n");
              errorFlag = 1;
              $$ = 0;
          } else {
              $$ = $1 / $3;
          }
      }
    | expr '^' expr   { $$ = pow($1, $3); }
    | '(' expr ')'   { $$ = $2; }
    | NUMBER         { $$ = $1; }
    | ID '=' expr    {
          Symbol *sym = lookup($1);
          if (!errorFlag) {
              if (sym == NULL) {
                  sym = createVar($1);
              }
              sym->value = $3;
              $$ = $3;
          } else {
              $$ = 0;
          }
          free($1);
      }
    | ID {
          Symbol *sym = lookup($1);
          if (sym == NULL) {
              fprintf(stderr, "Error: Undefined variable '%s'\n", $1);
              errorFlag = 1;
              $$ = 0;
          } else {
              $$ = sym->value;
          }
          free($1);
      }
    ;
%%

void yyerror(const char *msg) {
    fprintf(stderr, "Syntax Error: %s\n", msg);
}

int main() {
    printf("Simple calculator. Enter expressions:\n");
    printf("To exit, type 'exit' and press Enter.\n");
    return yyparse();
}
