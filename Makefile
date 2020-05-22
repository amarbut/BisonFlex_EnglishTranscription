CC=g++
CFLAGS=-I -O3 -std=c++11

all: engParser.out

engParser.tab.c: engParser.y
	bison -d engParser.y

lex.yy.c: engParser.l
	flex -Ca -i engParser.l

engParser.out: engParser.l engParser.y engParser.tab.c lex.yy.c
	$(CC) $(CFLAGS) engParser.tab.c lex.yy.c -lfl -o engParser.out