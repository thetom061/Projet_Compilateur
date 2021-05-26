#include <stdio.h>
#include <string.h>

void start_trad();

void print_asm(char* arg);

void push_temp_asm(int val);

void affectation_asm(char *arg,int val);

void cop_asm(char* arg,char* arg2);

void copie_asm(char* arg);

void temporisation_asm(char* arg);

void if_cond(int instr);

void if_else_cond(int nbre1, int nbre2);

void while_cond(int instr,int cond);

void addition_asm();

void multiplication_asm();

void soustraction_asm();

void division_asm();

void cond_equal();

void cond_inf();

void cond_inf_eq();

void cond_sup();

void cond_sup_eq();