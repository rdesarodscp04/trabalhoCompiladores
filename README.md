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

Comando para gerar o codigo c : docker run -i rodalvas/sim2c < program.sim > program.c

Comando para gerar o codigo sim: swipl -s calcPP-pl.pl < siuu > program.sim

Comando para escrever as coisas do contas-pl para o siuu: ./calcPP > siuu

Comando para escrever o que resulta do bison:
