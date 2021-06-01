Monexe: y.tab.c lex.yy.c tab_symb.c trad_asm.c
	gcc y.tab.c lex.yy.c tab_symb.c trad_asm.c -o Monexe

y.tab.c: an_gram.y
	yacc -d an_gram.y

lex.yy.c: an_lex.lex
	flex an_lex.lex


clean:
	rm *.o
	rm Monexe
