programa: sintatico.y lexico.l;  bison -Wall -Wcounterexamples -dv sintatico.y;  flex lexico.l; gcc sintatico.tab.c lex.yy.c -Wall -g -o programa.out
#;valgrind -v --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file="logfile.out" ./program.out Testes/analisadorLexico_certo1.txt
# programa: lexico.l; flex lexico.l; gcc lex.yy.c -Wall -g -o programa.out
