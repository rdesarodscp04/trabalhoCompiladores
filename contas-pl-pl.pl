
:- initialization((write('program: '),nl,load_apt(T),nl, halt)).

load_apt(T) :-
    read(X),
    load_apt(X, [], T).


load_apt(end_of_file, Acumulador, Acumulador) :- !.
 

load_apt(_Esquerda - Direita, Acumulador, OUT) :- 
    Direita = [Instrucao | _],
    number(Instrucao), !,
    write('PUSH '), write(Instrucao), write(''), nl,
    read(X),
    load_apt(X, [push(Instrucao) | Acumulador], OUT).


load_apt('Op' - Direita, Acumulador, OUT) :- 
    Direita = [Instrucao | _],
    member(Instrucao, [+, -, *, /]), !,
    converte_op(Instrucao, NomeInt),
    write(NomeInt),  nl,
    read(X),
    load_apt(X, [op(Instrucao) | Acumulador], OUT).

load_apt(_Esquerda - Direita, Acumulador, OUT) :-
    Direita = [print | _], !,
    write('printf("%d\\n", pop());'), nl,
    read(X),
    load_apt(X, [print | Acumulador], OUT).

load_apt(fim, Acumulador, OUT) :-
    read(X),
    % write('Acabou-se'),nl,
    load_apt(X, Acumulador, OUT).

load_apt(A, Acumulador, OUT) :-
    read(X),
    % write('isto foi ignorado: '), write(A), nl,
    load_apt(X, Acumulador, OUT).

converte_op('+', 'ADD').
converte_op('-', 'SUB').
converte_op('*', 'MUL').
converte_op('/', 'DIV').




