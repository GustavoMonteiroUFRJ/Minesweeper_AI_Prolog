start_game:- % Programa 1
	open('Mina.txt',read,Mina_file),
	read(Mina_file,Board_size),
	tabuleiro(Size) = Board_size,
	read_mines(List_minas,Mina_file),
	close(Mina_file),

	search_board(Size,List_minas,Size,List_board),

	open('Board.txt',write,Board_file),
	write_values(List_board,Board_file),
	close(Board_file),
	open('Ambiente.txt',write,Temp),close(Temp), % zera o ambiente
	!.

/*Le uma lista de um arquivo*/
read_list([X|L],File):- 
	read(File,X),
	not(X = end_of_file),
	read_list(L,File),
	!.
read_list([],_):-!.
read_mines(List_minas,File):- read_list(List_minas,File).
read_values(List_values,File):- read_list(List_values,File).


/*Imprime uma lista em um arquivo com '.' e quebra de linha*/
print_list([X|L],File):-
	write(File,X), write(File,'.'), nl(File),
	print_list(L,File),
	!.
print_list([],_):-!.
write_values(L,File):- print_list(L,File).

write_screen(X):- write(X),write('.'),nl.
write_list_screen([]).
write_list_screen([X|L]):- write_screen(X), write_list_screen(L).

/*Percorre as linhas da matriz*/
search_board(1,List_minas,Size,List_board):-
	search_Col(1,Size,Size,List_minas,List_board),
	!.
search_board(Row,List_minas,Size,List_board):-
	R is Row - 1,
	search_board(R,List_minas,Size,List_board_Row),
	search_Col(Row,Size,Size,List_minas,List_board_Col),
	append(List_board_Row,List_board_Col,List_board),
	!.
	
/*Percorre as colunas da linha*/
search_Col(Row,1,Size,List_minas,Element):-
	get_element_Valor(Row,1,Size,List_minas,Element),
	!.
search_Col(Row,Col,Size,List_minas,List_board):-
	C is Col - 1,
	search_Col(Row,C,Size,List_minas,List_Temp),
	get_element_Valor(Row,Col,Size,List_minas,Element),
	append(List_Temp,Element,List_board),
	!.

/*Gera cada elemento valor(Row,Col,K) */
get_element_Valor(Row,Col,_,List_minas,[]):- member(mina(Row,Col),List_minas),!.
get_element_Valor(Row,Col,Size,List_minas,[valor(Row,Col,K)]):- mine_neighbor(valor(Row,Col,K),List_minas,Size),!.

/*Descobre valor K de bonbas ao redor de um campo*/
mine_neighbor(valor(Row,Col,K),List_minas,Size):-
		Row =< Size, Row >= 1,
		Col =< Size, Col >= 1,
		Aux is 0,
		there_is_mine(Row,Col,1,List_minas,Mina1), Aux1 is Aux  + Mina1,
		there_is_mine(Row,Col,2,List_minas,Mina2), Aux2 is Aux1 + Mina2,
		there_is_mine(Row,Col,3,List_minas,Mina3), Aux3 is Aux2 + Mina3,
		there_is_mine(Row,Col,4,List_minas,Mina4), Aux4 is Aux3 + Mina4,
		there_is_mine(Row,Col,5,List_minas,Mina5), Aux5 is Aux4 + Mina5,
		there_is_mine(Row,Col,6,List_minas,Mina6), Aux6 is Aux5 + Mina6,
		there_is_mine(Row,Col,7,List_minas,Mina7), Aux7 is Aux6 + Mina7,
		there_is_mine(Row,Col,8,List_minas,Mina8), Aux8 is Aux7 + Mina8,
		K = Aux8
		.

/*there_is_mine: diz se tem mina em um determinado vizinho*/
there_is_mine(Row,Col,1,List_minas,1):-
	Y is Col - 1,
	X is Row + 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,2,List_minas,1):-
	Y is Col,
	X is Row + 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,3,List_minas,1):-
	Y is Col + 1,
	X is Row + 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,4,List_minas,1):-
	Y is Col + 1,
	X is Row,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,5,List_minas,1):-
	Y is Col + 1,
	X is Row - 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,6,List_minas,1):-
	Y is Col,
	X is Row - 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,7,List_minas,1):-
	Y is Col - 1,
	X is Row - 1,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,8,List_minas,1):-
	Y is Col - 1,
	X is Row,
	member(mina(X,Y),List_minas),
	!.
there_is_mine(_,_,_,_,0).


get_element_from_List_board(Row,Col,[X|_],X):- X = valor(Row,Col,_),!.
get_element_from_List_board(Row,Col,[_|List_board],X):- get_element_from_List_board(Row,Col,List_board,X).

/*Gera os campos que serão abertos apos uma jogada*/
gera_valores(Row,Col,_,_,List_minas,['jogo encerrado']):- % campo com mina 
	member(mina(Row,Col),List_minas), /*Falta implementar a ação de limbar o tabuleiro!*/
	!.
gera_valores(Row,Col,Size,_,_,[]):- % campo fora do limite do tabuleiro
	( Row > Size ; Row < 1 ; Col > Size ; Col < 1) ,
	write('Campo fora do tabuleiro'),
	!.
gera_valores(Row,Col,_,List_board,_,[valor(Row,Col,K)]):- % campo com K>0 minas vizinhas
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)), K > 0,
	!.
gera_valores(Row,Col,Size,List_board,_,[valor(Row,Col,K)|L]):- % campo com 0 minas vizinhas
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)),

	R1 is Row + 1,
	C1 is Col - 1,

	R2 is Row + 1,
	C2 is Col,

	R3 is Row + 1,
	C3 is Col + 1,
	
	R4 is Row,
	C4 is Col + 1,
	
	R5 is Row - 1,
	C5 is Col + 1,

	R6 is Row - 1,
	C6 is Col,

	R7 is Row - 1,
	C7 is Col - 1,
	
	R8 is Row,
	C8 is Col - 1,

	Ambiente1 = [valor(Row,Col,K)],
	gera_valores(R1,C1,Size,List_board,_,Ambiente1,L1), add_fields_zeros(Ambiente1,L1,Ambiente2), 
	gera_valores(R2,C2,Size,List_board,_,Ambiente2,L2), add_fields_zeros(Ambiente2,L2,Ambiente3), 
	gera_valores(R3,C3,Size,List_board,_,Ambiente3,L3), add_fields_zeros(Ambiente3,L3,Ambiente4),
	gera_valores(R4,C4,Size,List_board,_,Ambiente4,L4), add_fields_zeros(Ambiente4,L4,Ambiente5), 
	gera_valores(R5,C5,Size,List_board,_,Ambiente5,L5), add_fields_zeros(Ambiente5,L5,Ambiente6), 
	gera_valores(R6,C6,Size,List_board,_,Ambiente6,L6), add_fields_zeros(Ambiente6,L6,Ambiente7), 
	gera_valores(R7,C7,Size,List_board,_,Ambiente7,L7), add_fields_zeros(Ambiente7,L7,Ambiente8), 
	gera_valores(R8,C8,Size,List_board,_,Ambiente8,L8),

	append(L1,L2,Aux1),
	append(Aux1,L3,Aux2),
	append(Aux2,L4,Aux3),
	append(Aux3,L5,Aux4),
	append(Aux4,L6,Aux5),
	append(Aux5,L7,Aux6),
	append(Aux6,L8,Aux7),

	retira_elemento(valor(Row,Col,K),Aux7,Aux8),
	limpar_list(Aux8,L),
	!.

/*gera_valores/7 faz o mesmo que gera_valores/6. Existe para resolver loop infinito*/
gera_valores(Row,Col,Size,_,_,_,[]):- % campo fora do limite do tabuleiro
	( Row > Size ; Row < 1 ; Col > Size ; Col < 1) ,
	!.
gera_valores(Row,Col,_,List_board,_,_,[valor(Row,Col,K)]):- % campo com K>0 minas vizinhas
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)), K > 0,
	!.
gera_valores(Row,Col,_,List_board,_,Ambiente,[valor(Row,Col,K)]):- % campo com 0 minas vizinhas que já foi visitado.
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)),
	member(valor(Row,Col,K),Ambiente),
	!.
gera_valores(Row,Col,Size,List_board,_,Ambiente,[valor(Row,Col,K)|L]):- % campo com 0 minas vizinhas novo
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)),

	R1 is Row + 1,
	C1 is Col - 1,

	R2 is Row + 1,
	C2 is Col,

	R3 is Row + 1,
	C3 is Col + 1,
	
	R4 is Row,
	C4 is Col + 1,
	
	R5 is Row - 1,
	C5 is Col + 1,

	R6 is Row - 1,
	C6 is Col,

	R7 is Row - 1,
	C7 is Col - 1,
	
	R8 is Row,
	C8 is Col - 1,
	
	append(Ambiente,[valor(Row,Col,K)],Ambiente1),
	gera_valores(R1,C1,Size,List_board,List_minas,Ambiente1,L1), add_fields_zeros(Ambiente1,L1,Ambiente2), 
	gera_valores(R2,C2,Size,List_board,List_minas,Ambiente2,L2), add_fields_zeros(Ambiente2,L2,Ambiente3), 
	gera_valores(R3,C3,Size,List_board,List_minas,Ambiente3,L3), add_fields_zeros(Ambiente3,L3,Ambiente4),
	gera_valores(R4,C4,Size,List_board,List_minas,Ambiente4,L4), add_fields_zeros(Ambiente4,L4,Ambiente5), 
	gera_valores(R5,C5,Size,List_board,List_minas,Ambiente5,L5), add_fields_zeros(Ambiente5,L5,Ambiente6), 
	gera_valores(R6,C6,Size,List_board,List_minas,Ambiente6,L6), add_fields_zeros(Ambiente6,L6,Ambiente7), 
	gera_valores(R7,C7,Size,List_board,List_minas,Ambiente7,L7), add_fields_zeros(Ambiente7,L7,Ambiente8), 
	gera_valores(R8,C8,Size,List_board,List_minas,Ambiente8,L8),

	append(L1,L2,Aux1),
	append(Aux1,L3,Aux2),
	append(Aux2,L4,Aux3),
	append(Aux3,L5,Aux4),
	append(Aux4,L6,Aux5),
	append(Aux5,L7,Aux6),
	append(Aux6,L8,Aux7),

	limpar_list(Aux7,L),
	!.

/*Adiciona na Lout apenas campos com 0 minas ao redor*/
add_fields_zeros(L,[],L).
add_fields_zeros(L,[X|Lin],Lout):- X = valor(_,_,K), K > 0, add_fields_zeros(L,Lin,Lout),!.
add_fields_zeros(L,[X|Lin],Lout):- member(X,L), add_fields_zeros(L,Lin,Lout),!.
add_fields_zeros(L,[X|Lin],Lout):- member(X,Lin), add_fields_zeros(L,Lin,Lout),!.
add_fields_zeros(L,[X|Lin],[X|Lout]):- X = valor(_,_,0), add_fields_zeros(L,Lin,Lout),!.

/*Tira elementos repetidos*/
limpar_list([],[]).
limpar_list([X|L],Lout):- member(X,L), limpar_list(L,Lout),!.
limpar_list([X|L],[X|Lout]):- limpar_list(L,Lout),!.

retira_elemento(_,[],[]).
retira_elemento(X,[X|L],Lout):- retira_elemento(X,L,Lout),!.
retira_elemento(X,[Y|L],[Y|Lout]):- retira_elemento(X,L,Lout),!.

/*Cada Jogada*/
posicao(Row,Col):- % Programa 2 

	open('Mina.txt',read,Mina_file),
	read(Mina_file,Board_size),
	tabuleiro(Size) = Board_size,
	read_mines(List_minas,Mina_file),
	close(Mina_file),

	open('Board.txt',read,Board_file),
	read_values(List_board,Board_file),
	close(Board_file),

	gera_valores(Row,Col,Size,List_board,List_minas,Novo_Ambiente),
	imrpimr_ambiente(Novo_Ambiente,List_board),

	!.

imrpimr_ambiente(Novo_Ambiente,List_board):-
  open('Ambiente.txt',read,Ambiente),
  read_values(List_Ambiente,Ambiente),
  close(Ambiente),

  uniao_lista(Novo_Ambiente,List_Ambiente,Ambiente_final),

  is_game_over(List_board,Ambiente_final),

  open('Ambiente.txt',write,Output),
  write_values(Ambiente_final,Output),
  close(Output).

uniao_lista([],L,L).
uniao_lista([X|L1],L2,L3):-
	member(X,L2),
	uniao_lista(L1,L2,L3),
	!.
uniao_lista([X|L1],L2,[X|L3]):-
    not(member(X,L2)),
    write_screen(X),
    uniao_lista(L1,L2,L3),
    !.

contains_list([],_).
contains_list([X|L1],L2):- member(X,L2), contains_list(L1,L2).

is_game_over(List_board,List_ambiente):- contains_list(List_board,List_ambiente), write('You win! Game Over!'), nl.
is_game_over(_,_).




/** Problema 3 - Jogar!  **/


jogue:-
	
	
	
	
	.


