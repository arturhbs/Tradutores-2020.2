program: tuts-lang.l; flex tuts-lang.l; gcc lex.yy.c -Wall -g -o program.out
#;valgrind -v --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file="logfile.out" ./program.out Testes/analisadorLexico_certo1.txt
