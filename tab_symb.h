#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define TAILLE 100


struct symbole{
    char* name;
    bool initialized;
    bool isConstant;
};

int find_symbol(char* name);

void push_symbol(char* name,bool initialized, bool isConstant);

int isConst(char* name);

int isInitialized(char* name);

void initialize_symbol(char* name);

void pop_symbol();

void push_temp();

int pop_temp();

int get_temp();

void print_table();
