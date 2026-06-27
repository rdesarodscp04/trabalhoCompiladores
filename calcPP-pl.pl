
:- initialization((write('program: '),nl,load_apt(T),nl, halt)).

:- dynamic prints/1.
prints(0).


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
    write('CALL print_int'), nl,
    read(X),
    load_apt(X, [print | Acumulador], OUT).

load_apt(fim, Acumulador, OUT) :-
    read(X),
    % write('Acabou-se'),nl,
    load_apt(X, Acumulador, OUT).

%Variaveis
load_apt(TermoCompleto, Acumulador, OUT) :-
    term_to_atom(TermoCompleto, Atom),
   
    sub_atom(Atom, _, _, _, 'var-'), !,
    
    split_string(Atom, "_", "", Termos),
    Termos = [Esquerda, Direita],
    split_string(Esquerda, "-", "", Var),
    split_string(Direita, "-", "", Val),
    
    Var = [_, NomeVar],
    Val = [_, ValorVar],
    
    write('PUSH '), write(ValorVar), nl,
    write('STORE '), write(NomeVar), nl,
    read(X),
    load_apt(X, Acumulador, OUT).

converte_op('+', 'ADD').
converte_op('-', 'SUB').
converte_op('*', 'MUL').
converte_op('/', 'DIV').




