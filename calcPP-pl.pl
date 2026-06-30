
:- initialization((
    write('.data'), nl,
    write('foo:	.word	10'),nl,
    write('.word	20'),nl,
    write('.word	30'),nl,
    write('.text'), nl,
    write('program: '), nl,
    load_apt(_T),
    nl,
    halt)).

:- dynamic prints/1.
:- dynamic nVariaveis/1.
:- dynamic dicionario/1.
:- dynamic nLabels/1.
:- dynamic stackLabels/1.

nLabels(0).
prints(0).
nVariaveis(0).
dicionario([]).
stackLabels([]).


load_apt(T) :-
    read(X),
    load_apt(X, [], T).


load_apt(end_of_file, Acumulador, Acumulador) :- !,
    write(';end'),nl,
    write('jump'), nl.
    
load_apt(_Esquerda - Direita, Acumulador, OUT) :- 
    Direita = ['io' | _], !,
    write('DUP'), nl,
    write('PUSH read_int'), nl,
    write('CALL'), nl, 
    read(X),
    load_apt(X, ['input' | Acumulador], OUT).

load_apt(_Esquerda - Direita, Acumulador, OUT) :- 
    Direita = [Instrucao | _],
    number(Instrucao), !,
    write('PUSH '), write(Instrucao), write(''), nl,
    read(X),
    load_apt(X, [push(Instrucao) | Acumulador], OUT).

load_apt('op' - Direita, Acumulador, OUT) :-
    Direita = [Instrucao | _],
    member(Instrucao, [+, -, *, /, '%']), !,
    converte_op(Instrucao, NomeInt),
    write(NomeInt),  nl,
    read(X),
    load_apt(X, [op(Instrucao) | Acumulador], OUT).

load_apt(_Esquerda - Direita, Acumulador, OUT) :-
    Direita = [print | _], !,
    write('PUSH print_int'), nl,
    write('CALL'), nl,
    write('POP'),nl,
    read(X),
    load_apt(X, [print | Acumulador], OUT).

load_apt('var' - Direita, Acumulador, OUT) :-
    Direita = [NomeVar | _],
    dicionario(Dict),
    lookup(Dict, NomeVar, Val), !,
    write('PUSH '),write(Val), nl,
    write('STORE '), nl,
    read(X),
    load_apt(X, Acumulador, OUT).
   

%Guardar valor
load_apt('var' - Direita, Acumulador, OUT) :-
    Direita = [NomeVar | _],
    nVariaveis(N),
    N1 is N + 1,
    retract(nVariaveis(N)),
    assert(nVariaveis(N1)),
    retract(dicionario(DictAntigo)),         
    
    % ADICIONAMOS A VARIÁVEL DIRETAMENTE À CABEÇA DA LISTA:
    DictNovo = [NomeVar=N | DictAntigo],         
    assert(dicionario(DictNovo)),
    
    write('PUSH '),write(N), nl,
    write('STORE '), nl,
    read(X),
    load_apt(X, Acumulador, OUT).

%Carregar valor
load_apt('val' - Direita, Acumulador, OUT) :-
    Direita = [NomeVar | _],
    dicionario(Dict),         
    lookup(Dict, NomeVar, N),         
    write('PUSH '),write(N), nl,
    write('LOAD '),nl,
    read(X),
    load_apt(X, Acumulador, OUT).


load_apt('condicao' - [fim | _], Acumulador, OUT) :- ! ,
    
    nLabels(N),
    NFim is N + 1,
    N2 is N + 2,
    retract(nLabels(N)),
    assert(nLabels(N2)),

    write('DUP'),nl,
    write('DUP'),nl,
    write('SKIPZ'), nl,
    write('PUSH L'), write(N), nl,
    write('SWAP'),nl,
    write('SKIPZ'),nl,
    write('SWAP'),nl,
    write('SKIPZ'), nl,
    write('JUMP'), nl,
    
    write('PUSH L'), write(NFim), nl,
    write('JUMP'), nl,
    
    write('L'),write(N), write(':'), nl,

    stackLabels(Sl),
    insere_na_stack(NFim,Sl, Sl1),
    retract(stackLabels(Sl)),
    assert(stackLabels(Sl1)),
    read(X),
    load_apt(X, Acumulador, OUT).
    

load_apt('bloco' - [abre | _], Acumulador, OUT) :- !,
    read(Proximo),
    load_apt(Proximo, Acumulador, OUT).

load_apt('bloco' - [fecha | _], Acumulador, OUT):- !,
    read(Proximo),
    trata_fecho_bloco(Proximo, Acumulador, OUT).

trata_fecho_bloco('cond' - [else | _], Acumulador, OUT) :- !,
    nLabels(N),
    LEnd is N + 1,
    retract(nLabels(N)),
    assert(nLabels(LEnd)),

    write('PUSH L'), write(LEnd), nl,
    write('JUMP'), nl,

    stackLabels(Sl),
    remove_da_stack(Sl, LabelStartElse, Sl2),
    write('L'), write(LabelStartElse), write(':'), nl,

    insere_na_stack(LEnd, Sl2, Sl3),
    retract(stackLabels(Sl)),
    assert(stackLabels(Sl3)),

    read(DepoisDoElse),
    load_apt(DepoisDoElse, Acumulador, OUT).

trata_fecho_bloco(Proximo, Acumulador, OUT) :-
    stackLabels(Sl),
    remove_da_stack(Sl, Label, Sl2),
    retract(stackLabels(Sl)),
    assert(stackLabels(Sl2)),
    

    write('L'), write(Label), write(':'), nl,
    load_apt(Proximo, Acumulador, OUT).

converte_op('+', 'ADD').
converte_op('-', 'SUB').
converte_op('*', 'MUL').
converte_op('/', 'DIV').
converte_op('%', 'MOD').

lookup(DICT, _, _) :- var(DICT ), !, fail.
lookup([K=V|_], K, V).
lookup([_|DICT], K, V) :- lookup(DICT, K, V).

insere_na_stack(X, Lista, [X|Lista]).
remove_da_stack([X|L],X, L).


