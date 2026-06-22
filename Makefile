PROG=calcPP

CFLAGS=-DPROG="$(PROG)"

all: $(PROG)

clean:
	rm -f *.tab.* lex.yy.*
	rm -f *.o $(PROG)
	rm -f *~ \#*

$(PROG).tab.c $(PROG).tab.h: $(PROG).y
	bison -d $<

lex.yy.c: $(PROG).l
	flex $<

$(PROG): $(PROG).tab.o lex.yy.o
	gcc -o $@ $(PROG).tab.o lex.yy.o -lfl
	chmod +x $@
