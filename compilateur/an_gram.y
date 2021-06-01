%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "tab_symb.h"
  #include "trad_asm.h"
  int yyerror();
  int yylex();
%}
%union{
       char* variable;
       int valeur;
}
%token t_Main
%token t_Acc_Ouv
%token t_Acc_Ferm
%token t_Const
%token t_Int
%token t_ADD
%token t_String
%token t_SUB
%token t_MUL
%token t_DIV
%token t_AFF
%token t_Par_Ouv
%token t_Par_Ferm
%token t_Virgule
%token t_Fin_Instr
%token t_Print
%token t_Entier
%token t_Var
%token t_If
%token t_Eq
%token t_SupEq
%token t_Sup
%token t_InfEq
%token t_Inf
%token t_Else
%token t_While

%left t_ADD t_SUB
%left t_MUL t_DIV


%type <variable> t_Var
%type <variable> t_String
%type <valeur> VALEUR
%type <valeur> t_Entier
%type <valeur> EXPRESSION
%type <valeur> AFF
%type <valeur> AFFS
%type <valeur> DECL
%type <valeur> DECLS
%type <valeur> EXPRS
%type <valeur> INS
%type <valeur> INSS
%type <valeur> COND
%type <valeur> CAFFS

%%

//Reconaissance de l'enveloppe du pgrm
PRGM : t_Main t_Par_Ouv t_Par_Ferm t_Acc_Ouv EXPRS t_Acc_Ferm
        {printf("Debut programme\n");
         print_table();
         start_trad();}
     ;

//Reconaissance du corps du pgrm
EXPRS : DECLS INSS
        {$$=$1+$2;}
      | DECLS
        {$$=$1;}
      | INSS
        {$$=$1;}
      |
      ;

//Définition d'une VALEUR AKA un t_Entier ou un t_Var, définis dans an_lex
VALEUR : t_Var
        {//il faut vérifier que c'est une variable qui existe déjà et qui a une valeur affecté
        temporisation_asm($1);
        $$=1;
        }
       | t_Entier
        {start_trad();
        push_temp_asm($1);
        $$=1;
        }
       ;

//Définition d'une suite de déclarations
DECLS : DECL DECLS
        {$$=$1+$2;}
      | DECL
        {$$=$1;}
      ;

//Définition d'une déclaration (avec ou sans const, etc)
DECL : t_Int AFFS
        {$$=$2;}
        
     | t_Const t_Int CAFFS
        {$$=$3;}
     ;

// affectations pour cstes on veut une affectation à chaque déclaration
CAFFS : t_Var t_AFF t_Entier t_Virgule CAFFS
        {start_trad();
        push_symbol($1,false,true);
        affectation_asm($1,$3);
        initialize_symbol($1);
        $$=1+$5;}
      | t_Var t_AFF t_Entier t_Fin_Instr
        {start_trad();
        push_symbol($1,false,true);
        affectation_asm($1,$3);
        initialize_symbol($1);
         $$=1;}
      ;

//Définition d'une suite d'affectations
AFFS : AFF t_Virgule AFFS 
        {$$=$1+$3;}
     | AFF t_Fin_Instr
        {$$=$1;}
     ;

//Définition d'une affectation AKA int a=3, etc
AFF :   t_Var t_AFF t_Entier
        {start_trad();
         push_symbol($1,true,false);
         //on affecte directement l'entier à la variable
         affectation_asm($1,$3);
         //cela équivaut à 1 instruction
         $$=1;
         }
    | t_Var t_AFF t_Var
        {start_trad();
        push_symbol($1,true,false);
        //on copie la valeur
        cop_asm($1,$3);
        //cela équivaut à 1 instruction
        $$=1;}
    | t_Var
        {start_trad();
         push_symbol($1,false,false);
         //équivaut à 0 instruction
         $$=0;}
    ;

//Définition d'une suite d'instructions
INSS : INS INSS
        {$$=$1+$2;}
     | INS
        {$$=$1;}
     ;

//Définition d'une instruction AKA affectation de valeur, opérations, print
INS : t_Var t_AFF EXPRESSION t_Fin_Instr
        {//on intialize l'entier si dans la table des symboles si ce n'est pas déjà fait
         initialize_symbol($1);
         copie_asm($1);
         $$=$3+1;} 

    | t_Print t_Par_Ouv t_Var t_Par_Ferm t_Fin_Instr
        {start_trad();
         print_asm($3);
         $$=1;}

    | t_If t_Par_Ouv COND t_Par_Ferm t_Acc_Ouv EXPRS t_Acc_Ferm t_Else t_Acc_Ouv EXPRS t_Acc_Ferm 
        {if_else_cond($6,$10);
         $$=$3+$6+$10+2;}

    |t_If t_Par_Ouv COND t_Par_Ferm t_Acc_Ouv EXPRS t_Acc_Ferm
    {if_cond($6);
    //nombre d'instruction=nbre du body + nbre pour cond + 1 pour le jump
    $$=$6+1+$3;}
    
    |t_While t_Par_Ouv COND t_Par_Ferm t_Acc_Ouv EXPRS t_Acc_Ferm
    {while_cond($6,$3);
    $$=$3+$6+2;}
    ;

COND : EXPRESSION t_Eq EXPRESSION
       {start_trad();
       cond_equal();
       $$=$1+$3+1;}
     | EXPRESSION t_SupEq EXPRESSION
     {cond_sup_eq();
     $$=$1+$3+1;}
     | EXPRESSION t_Sup EXPRESSION
     {start_trad();
     cond_sup();
     $$=$1+$3+1;}
     | EXPRESSION t_InfEq EXPRESSION
     {cond_inf_eq();
     $$=$1+$3+5;}
     | EXPRESSION t_Inf EXPRESSION
     {start_trad();
     cond_inf();
     $$=$1+$3+1;}
     ;



//Pour affectations et instructions
EXPRESSION : VALEUR
            {$$=$1;}
           | EXPRESSION t_ADD EXPRESSION 
           {addition_asm();
            $$=$1+$3+1;}
           | EXPRESSION t_SUB EXPRESSION
           {soustraction_asm();
            $$=$1+$3+1;}
           | EXPRESSION t_MUL EXPRESSION
           {multiplication_asm();
            $$=$1+$3+1;}
           | EXPRESSION t_DIV EXPRESSION
           {division_asm();
            $$=$1+$3+1;}
           | t_Par_Ouv EXPRESSION t_Par_Ferm
           {$$=$2;}
           ;



%%
int main(){
    yyparse();
    return 1;
}

int yyerror(){
    printf("\n///On a un problème//\n");
}
