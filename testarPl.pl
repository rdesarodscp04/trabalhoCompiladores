load_apt(TermoCompleto, Acumulador, OUT) :-
    split_string(TermoCompleto, "_","", Termos),
    Termos = [Esquerda, Direita],
    
    split_string(Esquerda, "-", "", Var),
   
    split_string(Direita, "-", "", Val),
    
    Var = [_, NomeVar],
    Val = [_, ValorVar],
    
    write('PUSH '), write(ValorVar), nl,
    write('STORE '), write(NomeVar), nl.

    