#include "trad_asm.h"
#include "tab_symb.h"

FILE* trad;
int open=0;
int instructions=0;
int BUFFER=1000;

void start_trad(){
    if (open==0){
        trad=fopen("./input.txt","w+");
        open=1;
        }    
}

void print_asm(char* arg){
    int pos=find_symbol(arg), ini=isInitialized(arg);
    //gestion des erreurs possibles
    if (pos==(-1)){
        printf("Erreur: Print d'une variable non déclaré\n");
        exit(-1);
        }
    if (ini==0){
        printf("Erreur: Print d'une variable non initialisé\n");
        exit(-1);
        }
    fprintf(trad,"PRI ");
    fprintf(trad,"%d\n",pos);
    instructions++;
}

//on affecte une nouvelle variable temporaire à une valeur val avant de la copier en variable temporaire
//IMPORTANT: On a uniquement besoin de mettre qd on push et pas qd on pop en asm
// car la gestion des variable temp est fait dans tab_symb
void push_temp_asm(int val){
    fprintf(trad,"AFC %d %d\n",get_temp(),val);
    push_temp();
    instructions++;
}

//pour affecter un entier à une variable
//utilisé lors de déclaration avec affectation
void affectation_asm(char* arg,int val){
    int pos = find_symbol(arg);
    if (pos==(-1)){
        printf("Erreur: La variable %s n'est pas déclaré",arg);
        exit(-1);
    }
    fprintf(trad,"AFC %d %d\n",pos,val);
    instructions++;
}


//pour affecter une variable à une autre variable
//utilise lors de l'affectation de type int x=y; 
void cop_asm(char* arg,char* arg2){
    int pos=find_symbol(arg);
    int pos2=find_symbol(arg2);
    if (isInitialized(arg2)==(0)){
        printf("Erreur: La variable %s n'est pas initialisé\n",arg2);
        exit(-1);
        }
    fprintf(trad,"COP ");
    fprintf(trad,"%d %d\n",pos,pos2);
    instructions++;
}

//lors de l'affectation sous forme d'instruction de forme y=2*3*4;
void copie_asm(char* arg){
    int pos=find_symbol(arg);
    if (pos==(-1)){
        printf("Erreur: Affectation vers une variable non déclaré\n");
        exit(-1);
        }
    if (isConst(arg)==1 && isInitialized(arg)==1){
        printf("Erreur: On peut pas affecter une valeur à une constante\n");
        exit(-1);
    }
    fprintf(trad,"COP ");
    fprintf(trad,"%d %d\n",pos,pop_temp());
    instructions++;
}

//pour mettre valeur d'une variable dans la pile temporaire
//lorsqu'on veut faire un calcul du type x=2*y;
void temporisation_asm(char* arg){
    int pos=find_symbol(arg),ini=isInitialized(arg);
    if (pos==(-1)){
        printf("Erreur: Utilisation d'une variable non déclaré dans une expression\n");
        exit(-1);
        }
    if (ini==0){
        printf("Erreur: Utilisation d'une variable non initialisé dans une expression\n");
        exit(-1);
        }
    fprintf(trad,"COP ");
    fprintf(trad,"%d %d\n",get_temp(),pos);
    //on incrémente la valeur de la position dans la pile
    push_temp(); 
    instructions++;
}

//on va en arrière du nombre d'instruction requis
void if_cond(int nbr){
    int instr=nbr;
    int chars=1;
    int i=0;
    //on veut retourne juste après la cond avec le nombre de char auquel il faut retourner
    while (instr>0){
        fseek(trad,-2, SEEK_CUR);
        char c=getc(trad);
        if (c=='\n'){
            instr--;
        } 
        chars++;
        i++;
    }
    //on copie ce qui se situe après
    int pos=ftell(trad);
    char copy [BUFFER];
    printf("%d\n",chars+1);
    int num=0;
    while (!feof(trad)){
        int temp,nvinstr;
        //il faut aussi incrémenter tout les instructions de jump dans ce qu'on copie (conditionnelles ou non) par 1 car on rajoute une instruction avant tout ce qu'il y avait
        fgets(&copy[num],100,trad);
        if (sscanf(&copy[num],"JMF %d %d\n",&temp,&nvinstr)>0){
            sprintf(&copy[num],"JMF %d %d\n",temp,nvinstr+1);
        }
        if (sscanf(&copy[num],"JMP %d\n",&nvinstr)>0){
            sprintf(&copy[num],"JMP %d\n",nvinstr+1);
        }
        num=strlen(copy);
        printf("Voici num:%d\n",num);
    }

    //on retourne la ou on ou voulais (juste après la condition)
    fseek(trad, pos, SEEK_SET);
    //on print l'instruction du jump conditionnelle
    fprintf(trad,"JMF %d %d\n",pop_temp(),instructions-instr+1);
    //on paste ce qu'on avait copiée
    fputs(copy,trad);
    instructions++;
}

void if_else_cond(int nbre1, int nbre2){
    int instr=nbre2;
    int chars=1;
    int i=0;
     //on veut retourne juste avant la 1 ere instruction du else en comptant le nombre de char auquel il faut retourner
    while (instr>0){
        fseek(trad,-2, SEEK_CUR);
        char c=getc(trad);
        if (c=='\n'){
            instr--;
        } 
        chars++;
        i++;
    }
    int pos=ftell(trad);
    char copy [BUFFER];
    int num=0;
    while (!feof(trad)){
        int temp,nvinstr;
        //il faut aussi incrémenter tout les instructions de jump (conditionnelles ou non) par 1 car l'on rajoute une instruction
        fgets(&copy[num],100,trad);
        if (sscanf(&copy[num],"JMF %d %d\n",&temp,&nvinstr)>0){
            sprintf(&copy[num],"JMF %d %d\n",temp,nvinstr+1);
        }
        if (sscanf(&copy[num],"JMP %d\n",&nvinstr)>0){
            sprintf(&copy[num],"JMP %d\n",nvinstr+1);
        }
        num=strlen(copy);
    }

    //on retourne la ou on ou voulais 
    fseek(trad, pos, SEEK_SET);
    //on print l'instruction du jump non conditionnelle
    fprintf(trad,"JMP %d\n",instructions);
    instructions++;
    //on remet ce qu'on avait copié
    fputs(copy,trad);
    

    instr=nbre2+nbre1+1;
    chars=1;
    i=0;
     //on veut retourne juste après la cond (avant la 1ère instruction du if)avec le nombre de char auquel il faut retourner
    while (instr>0){
        fseek(trad,-2, SEEK_CUR);
        char c=getc(trad);
        if (c=='\n'){
            instr--;
        } 
        chars++;
        i++;
    }
    pos=ftell(trad);
    copy [BUFFER];
    num=0;
    while (!feof(trad)){
        int temp,nvinstr;
        //il faut aussi incrémenter tout les instructions de jump (conditionnelles ou non) par 1 parceque on rajoute une instruction
        fgets(&copy[num],100,trad);
        if (sscanf(&copy[num],"JMF %d %d\n",&temp,&nvinstr)>0){
            sprintf(&copy[num],"JMF %d %d\n",temp,nvinstr+1);
        }
        if (sscanf(&copy[num],"JMP %d\n",&nvinstr)>0){
            sprintf(&copy[num],"JMP %d\n",nvinstr+2);
        }
        num=strlen(copy);
      
    }
    //on retourne la ou on ou voulais 
    fseek(trad, pos, SEEK_SET);
    //on print l'instruction du jump conditionnelle
    fprintf(trad,"JMF %d %d\n",pop_temp(),instructions-nbre2+1);
    instructions++;
    fputs(copy,trad);
    
}

void while_cond(int instr,int cond){
    int instre=instr;
    int chars=1;
    int i=0;
     //on veut retourne juste après la cond avec le nombre de char auquel il faut retourner
    while (instre>0){
        fseek(trad,-2, SEEK_CUR);
        char c=getc(trad);
        if (c=='\n'){
            instre--;
        } 
        chars++;
        i++;
    }
    int pos=ftell(trad);
    char copy [BUFFER];
    int num=0;
    while (!feof(trad)){
        int temp,nvinstr;
        //il faut aussi incrémenter tout les instructions de jump (conditionnelles ou non) par 1
        fgets(&copy[num],100,trad);
        if (sscanf(&copy[num],"JMF %d %d\n",&temp,&nvinstr)>0){
            sprintf(&copy[num],"JMF %d %d\n",temp,nvinstr+1);
        }
        if (sscanf(&copy[num],"JMP %d\n",&nvinstr)>0){
            sprintf(&copy[num],"JMP %d\n",nvinstr+1);
        }
        num=strlen(copy);
    }
    //on retourne la ou on ou voulais 
    fseek(trad, pos, SEEK_SET);
    //on print l'instruction du jump non conditionnelle
    instructions++;
    //si la condition n'est pas remplie on skip ce qu'il y a dans le while
    fprintf(trad,"JMF %d %d\n",pop_temp(),instructions+1);
    fputs(copy,trad);
    instructions++;
    //a la fin du while on retourne au début de la condition pour voir si elle est toujours vrai
    fprintf(trad,"JMP %d\n",instructions-instr-(cond+2));
}

//Pour toutes les opération qu'on réalise on remet la valeur généré
//dans la variable qu'on utilise au niveau le plus bas de la pile (bas de la pile= plus grande valeur)
//On additionne  les 2 dernières variables temporaires
void addition_asm(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"ADD ");
    fprintf(trad,"%d %d %d\n",pos2,pos1,pos2);
    //on push car on utilise mtn l'emplacement de pos2 pour garder le resultat 
    //  de la multiplication
    push_temp();
    instructions++;
}

//On multiplie les 2 dernières variables temporaires
void multiplication_asm(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"MUL ");
    fprintf(trad,"%d %d %d\n",pos2,pos1,pos2);
    //on push car on utilise mtn l'emplacement de pos2 pour garder le resultat 
    //  de la multiplication
    push_temp();
    instructions++;
}
//On soustrait les 2 dernières variables temporaires
void soustraction_asm(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"SOU ");
    fprintf(trad,"%d %d %d\n",pos2,pos1,pos2);
    //on push car on utilise mtn l'emplacement de pos2 pour garder le resultat 
    //  de la multiplication
    push_temp();
    instructions++;
}

//On divise les 2 dernières variables temporaires
void division_asm(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"DIV ");
    fprintf(trad,"%d %d %d\n",pos2,pos1,pos2);
    //on push car on utilise mtn l'emplacement de pos2 pour garder le resultat 
    //  de la multiplication
    push_temp();
    instructions++;
}


void cond_equal(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"EQU ");
    fprintf(trad,"%d %d %d\n",pos2,pos1,pos2);
    //on stock le résultat intermédiaire dans pos 2 donc on push
    push_temp();
    instructions++;
}

void cond_inf(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"INF ");
    fprintf(trad,"%d %d %d\n",pos2,pos2,pos1);
    //on stock le résultat intermédiaire dans pos 2 donc on push
    push_temp();
    instructions++;
}

//pour cond_inf_eq et con_sup_eq, on vérifie les 2 conditions dans des variable differentes
//on ajoute leur résultat (1 si vrai 0 si faux) 
//si la somme est supérieur à 0 cela veut dire que la condition est remplie
void cond_inf_eq(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    push_temp();
    push_temp();
  
    fprintf(trad,"INF %d %d %d\n",get_temp(),pos2,pos1);
    push_temp();
    fprintf(trad,"EQU %d %d %d\n",get_temp(),pos1,pos2);
    push_temp();
    addition_asm();
    fprintf(trad,"AFC %d %d\n",get_temp(),0);
    push_temp();
    int pos3=pop_temp();
    int pos4=pop_temp();
    //on met le résultat de la condition 2 variable temporaires plus bas car on a plus besoin de 2 intermediares
    fprintf(trad,"SUP %d %d %d\n",pos4+2,pos4,pos3);
    pop_temp();
    
    instructions+=4;
}

void cond_sup(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    fprintf(trad,"SUP ");
    fprintf(trad,"%d %d %d\n",pos2,pos2,pos1);
    //on stock le résultat intermédiaire dans pos 2 donc on push
    push_temp();
    instructions++;
}

void cond_sup_eq(){
    int pos1=pop_temp();
    int pos2=pop_temp();
    push_temp();
    push_temp();
  
    fprintf(trad,"SUP %d %d %d\n",get_temp(),pos2,pos1);
    push_temp();
    fprintf(trad,"EQU %d %d %d\n",get_temp(),pos1,pos2);
    push_temp();
    addition_asm();
    fprintf(trad,"AFC %d %d\n",get_temp(),0);
    push_temp();
    int pos3=pop_temp();
    int pos4=pop_temp();
    //on met le résultat de la condition 2 variable temporaires plus bas car on a plus besoin de 2 intermediares
    fprintf(trad,"SUP %d %d %d\n",pos4+2,pos4,pos3);
    pop_temp();
   
    instructions+=4;
}
