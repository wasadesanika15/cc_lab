%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);

/* Custom power function */
int power(int base, int exponent)
{
    int result = 1;
    int i;

    if (exponent < 0) {
        printf("Error: Negative exponent not supported\n");
        return 0;
    }

    for (i = 0; i < exponent; i++)
        result *= base;

    return result;
}
%}

%token NUMBER

%%

stmt:
      stmt expr '\n'
      {
          printf("Result: %d\n", $2);
      }
    |
    ;

expr:
      NUMBER
      {
          $$ = $1;
      }

    | expr expr '+'
      {
          $$ = $1 + $2;
      }

    | expr expr '-'
      {
          $$ = $1 - $2;
      }

    | expr expr '*'
      {
          $$ = $1 * $2;
      }

    | expr expr '/'
      {
          if ($2 == 0)
              yyerror("Division by zero");
          else
              $$ = $1 / $2;
      }

    | expr expr '^'
      {
          $$ = power($1, $2);
      }
    ;

%%

void yyerror(const char *s)
{
    printf("Error: %s\n", s);
}

int main(void)
{
    yyparse();
    return 0;
}

