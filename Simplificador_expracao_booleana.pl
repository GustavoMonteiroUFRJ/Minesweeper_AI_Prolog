/* \/ Definições \/ */
% [  [ [ LITERAL ,barra(LITERAL) ],[] ] , [] , []  ] -----> LITERAL = a , b , c ... .

% [  [ CLAUSULA , [] ] , [] , []  ] -----> CLAUSULASULA = [ LITERAL | LITERAIS ].

% [  DISJUNCAO , [] , []  ]  -----> DISJUNCAO = [ CLAUSULA | CLAUSULAS ].


/* \/ Testes \/ */
% fusao_disjuncoes([ [a,barra(b)] , [barra(a),b] ] , [ [a,b,barra(c)] , [a,barra(b),c] , [barra(a),b,c] ] , Disj ).

% simple([ [ [a,barra(b)] , [barra(a),b] ] , [ [a,b,barra(c)] , [a,barra(b),c] , [barra(a),b,c] ] , [ [b,barra(c),barra(d)] , [barra(b),c,barra(d)] , [barra(b),barra(c),d] ]  ] , Ret ).

% fusao_disjuncoes([[a,barra(b),c],[barra(a),b,c]] , [ [b,barra(c),barra(d)] , [barra(b),c,barra(d)] , [barra(b),barra(c),d] ], RET).

% fusao_disjuncoes([ [a,barra(b)] , [barra(a),b] ] , [ [a,b,barra(c)] , [a,barra(b),c] , [barra(a),b,c] ] , Disj ), get_information(Disj,List).

get_information([Clausula|Clausulas],List_literais):-
	get_information(Clausulas,Clausula,List_literais)
	.

get_information(_,[],[]).
get_information(Disj,[Literal|Literais],[Literal|Resto]):-
	is_there_all_list(Literal,Disj),
	get_information(Disj,Literais,Resto),
	!.
get_information(Disj,[_|Literais],Resto):-	
	get_information(Disj,Literais,Resto),
	!.

is_there_all_list(Literal,[Clau]):-
	member(Literal,Clau),
	!.
is_there_all_list(Literal,[Clau|Clausulas]):-
	member(Literal,Clau),
	is_there_all_list(Literal,Clausulas),
	!.


simple([Disj],[Disj]).
simple([Disjuncao1, Disjuncao2 |List_disj],Resultado):- 
	fusao_disjuncoes(Disjuncao1,Disjuncao2,Disj_temp),
	simple([Disj_temp|List_disj],Resultado)
	.

fusao_disjuncoes([], _ , [] ).
fusao_disjuncoes([Clau|Clausulas], Disj, Disj_resultante ):- 
	distributiva(Clau,Disj,[]),
	fusao_disjuncoes(Clausulas,Disj,Disj_resultante),
	!.
fusao_disjuncoes([Clau|Clausulas], Disj, [Clau_resultante|Disj_resultante] ):-
	distributiva(Clau,Disj,[Clau_resultante]),
	fusao_disjuncoes(Clausulas,Disj,Disj_resultante),
	!.

distributiva(Clausula,[],[]).
distributiva(Clausula,[Clau|Clausulas],Retorno):- 
	multiplica_expresao_boleana(Clausula,Clau,[]), 
	distributiva(Clausula,Clausulas,Retorno),
	!.
distributiva(Clausula,[Clau|Clausulas],[Clau_resultante|Retorno]):- 
	multiplica_expresao_boleana(Clausula,Clau,[Clau_resultante]), 
	distributiva(Clausula,Clausulas,Retorno),
	!.

multiplica_expresao_boleana([barra(Literal)|_],Clausula,[]):- member(Literal,Clausula).
multiplica_expresao_boleana([Literal|_],Clausula,[]):- member(barra(Literal),Clausula).
multiplica_expresao_boleana([Literal|Literais],Clausula,[]):- multiplica_expresao_boleana(Literais,Clausula,[]),!.

multiplica_expresao_boleana(Clausula1,Clausula2,[Clau_resultante]):-  uniao_lista(Clausula1,Clausula2,Clau_resultante). 

uniao_lista([],L,L).
uniao_lista([X|L1],L2,L3):-
	member(X,L2),
	uniao_lista(L1,L2,L3),
	!.
uniao_lista([X|L1],L2,[X|L3]):-
    not(member(X,L2)),
    uniao_lista(L1,L2,L3),
    !.
