
%{
#include "y.tab.h"
#include <string.h>
%}

%%
main return t_Main;
\{ return t_Acc_Ouv;
\} return t_Acc_Ferm;
"const" return t_Const;
"int" return t_Int;
\+ return t_ADD;
\- return t_SUB;
\* return t_MUL;
\/ return t_DIV;
\= return t_AFF;
\( return t_Par_Ouv;
\) return t_Par_Ferm;
[ \t\n]+ ;
"," return t_Virgule;
";" return t_Fin_Instr;
printf {return t_Print;}
if {return t_If;}
else {return t_Else;}
== {return t_Eq;}
\>\= return t_SupEq;
\> return t_Sup;
\<\= return t_InfEq;
\< return t_Inf;
while return t_While;
[0-9]+([e]([+-])*[0-9]+)* {yylval.valeur=atoi(yytext);
                           return t_Entier;}

["][A-Za-z0-9_ -'/]+["] {yylval.variable=malloc(sizeof(char)*20);
                         strncpy(yylval.variable,yytext,20); 
                         return t_String;
                        }
[a-z][a-z_0-9]* {//look at specs
                yylval.variable=malloc(sizeof(char)*20);
                strncpy(yylval.variable,yytext,20); 
                return t_Var;}





%%
int yywrap(){
    return 1;
}

