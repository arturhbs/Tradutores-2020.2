programa: sintatico.y lexico.l;  bison -Wall -Wcounterexamples -dv sintatico.y;  flex lexico.l; gcc sintatico.tab.c lex.yy.c -Wall -g -o programa.out
#valgrind -v --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file="logfile.out" ./programa.out Testes/analisadorSintatico_certo4.c
# -fsanitize=address 