main:-
	open('Entrada.txt',read,Input),
	read(Input,Bord_size),
	tabuleiro(Size) = Bord_size,
	read_mines(List_minas,Input),
	close(Input),

	search_board(Size,List_minas,Size,List_board),

	open('Saida.txt',write,Output),

	print_output(List_board,Output),

	close(Output),!.

read_mines([X|L],File):- 
	read(File,X),
	not(X = end_of_file),
	read_mines(L,File),!.

read_mines([],_):-!.


print_output([X|L],File):-
	write(File,X), write(File,'.'), nl(File),
	print_output(L,File),!.

print_output([],_):-!.


search_board(1,List_minas,Size,List_board):-
	search_Col(1,Size,Size,List_minas,List_board),
	!.
search_board(Row,List_minas,Size,List_board):-
	R is Row - 1,
	search_board(R,List_minas,Size,List_board_Row),
	search_Col(Row,Size,Size,List_minas,List_board_Col),
	append(List_board_Row,List_board_Col,List_board),
	!.
	
search_Col(Row,1,Size,List_minas,Element):-
	get_element_Valor(Row,1,Size,List_minas,Element),
	!.
search_Col(Row,Col,Size,List_minas,List_board):-
	C is Col - 1,
	search_Col(Row,C,Size,List_minas,List_Temp),
	get_element_Valor(Row,Col,Size,List_minas,Element),
	append(List_Temp,Element,List_board),
	!.

get_element_Valor(Row,Col,_,List_minas,[]):- member(mina(Row,Col),List_minas),!.
get_element_Valor(Row,Col,Size,List_minas,[valor(Row,Col,K)]):- mine_neighbor(valor(Row,Col,K),List_minas,Size),!.


mine_neighbor(valor(Row,Col,K),List_in,Size):-
		Row =< Size, Row >= 1,
		Col =< Size, Col >= 1,
		Aux is 0,
		there_is_mine(Row,Col,1,List_in,Mina1),
		Aux1 is Aux + Mina1,
		there_is_mine(Row,Col,2,List_in,Mina2),
		Aux2 is Aux1 + Mina2,
		there_is_mine(Row,Col,3,List_in,Mina3),
		Aux3 is Aux2 + Mina3,
		there_is_mine(Row,Col,4,List_in,Mina4),
		Aux4 is Aux3 + Mina4,
		there_is_mine(Row,Col,5,List_in,Mina5),
		Aux5 is Aux4 + Mina5,
		there_is_mine(Row,Col,6,List_in,Mina6),
		Aux6 is Aux5 + Mina6,
		there_is_mine(Row,Col,7,List_in,Mina7),
		Aux7 is Aux6 + Mina7,
		there_is_mine(Row,Col,8,List_in,Mina8),
		Aux8 is Aux7 + Mina8,
		K = Aux8
		.

there_is_mine(Row,Col,1,List_in,1):-
	Y is Col - 1,
	X is Row + 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,2,List_in,1):-
	Y is Col,
	X is Row + 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,3,List_in,1):-
	Y is Col + 1,
	X is Row + 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,4,List_in,1):-
	Y is Col + 1,
	X is Row,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,5,List_in,1):-
	Y is Col + 1,
	X is Row - 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,6,List_in,1):-
	Y is Col,
	X is Row - 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,7,List_in,1):-
	Y is Col - 1,
	X is Row - 1,
	member(mina(X,Y),List_in),!.

there_is_mine(Row,Col,8,List_in,1):-
	Y is Col - 1,
	X is Row,
	member(mina(X,Y),List_in),!.

there_is_mine(_,_,_,_,0).




gera_valores(Row,Col,Size,List_minas,[]):-
	not(mine_neighbor(valor(Row,Col,_),List_minas,Size)),
	!.

gera_valores(Row,Col,Size,List_minas,[valor(Row,Col,K)]):-
	mine_neighbor(valor(Row,Col,K),List_minas,Size),
	K > 0,
	!.

gera_valores(Row,Col,Size,List_minas,[valor(Row,Col,K)|L]):-
	mine_neighbor(valor(Row,Col,K),List_minas,Size),

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

	gera_valores(R1,C1,Size,List_minas,L1),
	gera_valores(R2,C2,Size,List_minas,L2),
	gera_valores(R3,C3,Size,List_minas,L3),
	gera_valores(R4,C4,Size,List_minas,L4),
	gera_valores(R5,C5,Size,List_minas,L5),
	gera_valores(R6,C6,Size,List_minas,L6),
	gera_valores(R7,C7,Size,List_minas,L7),
	gera_valores(R8,C8,Size,List_minas,L8),

	append(L1,L2,Aux1),
	append(Aux1,L3,Aux2),
	append(Aux2,L4,Aux3),
	append(Aux3,L5,Aux4),
	append(Aux4,L6,Aux5),
	append(Aux5,L7,Aux6),
	append(Aux6,L8,L),
	!.

posicao(Row,Col):-

	open('Entrada.txt',read,Input),
	read(Input,Bord_size),
	tabuleiro(Size) = Bord_size,
	read_mines(List_minas,Input),
	close(Input),

	gera_valores(Row,Col,Size,List_minas,Novo_Ambiente),
	/*
	alex_func(Novo_Ambiente,Ambiente),
	*/

	open('Saida.txt',write,Output),

	print_output(Novo_Ambiente,Output),


	close(Output),!.





