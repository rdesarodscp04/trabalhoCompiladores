
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

prints(0).
nVariaveis(0).
dicionario(_).


load_apt(T) :-
    read(X),
    load_apt(X, [], T).


load_apt(end_of_file, Acumulador, Acumulador) :- !,
    write(';end'),nl,
    write('jump'), nl.
    
 

load_apt(_Esquerda - Direita, Acumulador, OUT) :- 
    Direita = [Instrucao | _],
    number(Instrucao), !,
    write('PUSH '), write(Instrucao), write(''), nl,
    read(X),
    load_apt(X, [push(Instrucao) | Acumulador], OUT).

load_apt('op' - Direita, Acumulador, OUT) :- 
    Direita = [Instrucao | _],
    member(Instrucao, [+, -, *, /]), !,
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
    insert(DictAntigo, NomeVar, N),         
    assert(dicionario(DictAntigo)),
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

converte_op('+', 'ADD').
converte_op('-', 'SUB').
converte_op('*', 'MUL').
converte_op('/', 'DIV').

insert(DICT, K, V) :- var(DICT ), !, DICT=[K=V|_].
insert([K=_|_], K, _) :- !, fail.
insert([_|DICT], K, V) :- insert(DICT, K, V).

lookup(DICT, _, _) :- var(DICT ), !, fail.
lookup([K=V|_], K, V).
lookup([_|DICT], K, V) :- lookup(DICT, K, V).




