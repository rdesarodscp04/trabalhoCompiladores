PROG=calcPP
CFLAGS=-DPROG="$(PROG)"
BUILD_DIR=build
TARGET=$(BUILD_DIR)/$(PROG)

all: $(TARGET)

clean:
	rm -rf $(BUILD_DIR)/*
	rm -f *~ \#*
	rm program program.c

# Regra para o Bison (gera os ficheiros dentro de build/)
$(TARGET).tab.c $(TARGET).tab.h: $(PROG).y | $(BUILD_DIR)
	bison -d -o $(TARGET).tab.c $<

# Regra para o Flex (gera o lex.yy.c dentro de build/)
$(BUILD_DIR)/lex.yy.c: $(PROG).l $(TARGET).tab.h | $(BUILD_DIR)
	flex -o $@ $<

# Regras de compilação dos objetos .o
$(TARGET).tab.o: $(TARGET).tab.c | $(BUILD_DIR)
	gcc $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lex.yy.o: $(BUILD_DIR)/lex.yy.c | $(BUILD_DIR)
	gcc $(CFLAGS) -c $< -o $@

# Linkagem final do executável
$(TARGET): $(TARGET).tab.o $(BUILD_DIR)/lex.yy.o
	gcc -o $@ $^ -lfl
	chmod +x $@

passo1: $(TARGET)
	./$(TARGET) > $(BUILD_DIR)/output

passo2:
	swipl -s calcPP-pl.pl < $(BUILD_DIR)/output > program.sim

passo3:
	docker run -i rodalvas/sim2c < program.sim > program.c

passo4:
	gcc  program.c -o program

correr:
	./program
