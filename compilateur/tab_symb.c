#include "tab_symb.h"


struct symbole table[TAILLE];
int position=0;

int temporaire=255;

int find_symbol(char* name){
   for (int i=0;i<position;i++){
       if (!strcmp(table[i].name,name)){
           return i;
           } 
       } 
    return -1;
}

void push_symbol(char* name,bool initialized, bool isConstant){
    if (find_symbol(name)!=(-1)){
        printf("Erreur: Variable '%s' déjà déclaré\n",name);
        exit(-1);
    }
    struct symbole symb;
    symb.name = malloc(sizeof(char)*20);
    symb.initialized = malloc(sizeof(bool));
    symb.isConstant = malloc(sizeof(bool));

    (symb).name=name;
    (symb).initialized=initialized;
    (symb).isConstant=isConstant;
    table[position]=symb;
    position++;
}

//retourne 1 si initilialisé 0 sinon
int isInitialized(char* name){
    int pos=find_symbol(name);
    if (pos!=-1){
        if (table[pos].initialized==1){
            return 1;
        }
    }
    return 0;
}

int isConst(char* name){
    int pos=find_symbol(name);
    if (pos!=-1){
        return table[pos].isConstant;
    } else {
        return 0;
    }
   
}

void initialize_symbol(char* name){
    int pos=find_symbol(name);
    if (pos!=-1){
        table[pos].initialized=true;
        }
}

void pop_symbol(){
    free(&table[position-1]);
    position--;
}

void push_temp(){
    temporaire--;   
}

int pop_temp(){
    temporaire++; 
    return temporaire; 
}

int get_temp(){
    return temporaire;
}

void print_table(){
    for (int i=0;i<position;i++){
        printf("Variable name: %s, is initialized: %d, is constant: %d\n",table[i].name,table[i].initialized,table[i].isConstant);
    }
}



