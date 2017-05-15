

criando_disjucao([],_,[]).

criando_disjucao([Literal|List_Literais],0,[[barra(Literal)|List_restante]]):-
	criando_disjucao(List_Literais,0,[List_restante]),
	!.

criando_disjucao(List_Literais,K,[List_Literais]):-
	list_len(List_Literais,K),
	!.

criando_disjucao([Literal|List_Literais],K,Disj_final):-
	criando_disjucao(List_Literais,K,Temp_1),
	add_literal(barra(Literal),Temp_1,Disj_1),

	K2 is K - 1,
	criando_disjucao(List_Literais,K2,Temp_2),
	add_literal(Literal,Temp_2,Disj_2),
	append(Disj_1,Disj_2,Disj_final),
	!.

add_literal(_,[],[]).
add_literal(Literal,[Clau|Disj_1],[[Literal|Clau]|Disj_2]):-
	add_literal(Literal,Disj_1,Disj_2),
	!.

list_len([],0).
list_len([_|L],N):-list_len(L,M), N is M+1.
