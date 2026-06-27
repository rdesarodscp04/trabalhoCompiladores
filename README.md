# INSTRUÇÕES PARA EXECUÇÃO:

1. Utilizar o `make all` para dar build no projeto

2. Executar o binário `calcPP` com `build/./calcPP > build/output`

3. Utilizar o output como input para o programa calcPP-pl.pl para gerar o código sim com
    `swipl -s calcPP-pl.pl < build/output > program.sim`

4. Gerar o código C com `docker run -i rodalvas/sim2c < program.sim > program.c`
    ATENÇÃO: Por motivos desconhecidos a secção das instructions do código C fica no topo do ficheiro e por essa razão deve ser colocada na secção correta.

5. Finalmente, compilar o ficheiro C e executar o binário do mesmo com:
    `gcc -o program program.c | ./program`

# Comandos

## Resumo dos passos necessários

### Comando `make passo1`
    Aqui simplesmente lê-se o input e escreve em build/output através do bison

### Comando `make passo2`
    Aqui lê os comandos passados pelo bison no build/output e escreve o program.sim

### Comando `make passo3`
    O prolog lê o program.sim e gera codigo sim que depois é convertido para o program.c

### Comando `make passo4`
    Aqui compila-se o program.c, no entanto é preciso alterar o lugar onde o codigo está escrito para a aba instructions

### Comando `make correr`
    Aqui corre-se
