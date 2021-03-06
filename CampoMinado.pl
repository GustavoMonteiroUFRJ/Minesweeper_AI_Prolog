/*
O programa le um arquivo com nome Mina.txt com a primeira linha contendo " tabuleiro(N)."
Com N numerico, e depois uma sequencia de elmentos " mina(R,C) " com 0 < R,C <= N.

Apos executar start_gama/0 ou start_gama/1 é gerado um arquivo Board.txt com todos os elementos
" valor(R,C,K). " sendo K o nuemro de minas ao redor da casa [R,C].

O codigo implementa uma solução para jogar Campo Minado na seguinta idiea:
É jogado primeiramente uma posição aleatória sem nenhuma prioridade.
Apos, é analizado todas as casas abertas e criado uma conjuntção (chamado de clausulas)
para cada realidade possivel de existencia ou não de minas nos campos ao redor de cada casa. 
Então, é criado uma disjunção com todas essas clausulas. E então é juntado todas as disjunções
em uma grande conjunção. Simplificamos essa grande cojunção em apenas uma disjunção e então analizamos
o resultado. Consideramos um literal [R,C] como mina e barra([R,C]) como não mina.
Caso algum literal apareça em todas as clausulas da disjunção simplificada, consideramos que seu valor
já é definido, e apontamos a casa como mina ou como um campo a ser jogado.

Cada jogada abre o valor de pelo menos uma casa e isso é gravado em um arquivo chamado Ambiente.txt. 
Caso seja mina o programa perde e o jogo termina, caso contrario, o jogo só termina quando o arquivo 
Ambiente.txt tiver todos os elementos que o arquivo Bord.txt e assim o programa ganha.

Cada jogada é registrado em um arquivo chamado Jogadas.txt como " posicao(R,C). " e caso consiga
provar que há uma mina, é registrado " mina(R,C) ".

*/


start_game:- start_game(Size), write("Size" = Size), nl.

start_game(Size):- % Programa 1
	open('Mina.txt',read,Mina_file),
	read(Mina_file,Board_size),
	tabuleiro(Size) = Board_size,
	read_mines(List_minas,Mina_file),
	close(Mina_file),

	search_board(Size,List_minas,Size,List_board), % Busca em profundidade pelo tabuleiro.

	open('Board.txt',write,Board_file), % OutPut do problema 1.
	write_values(List_board,Board_file),
	close(Board_file),

	open('Ambiente.txt',write,Temp),close(Temp), % zera o Ambiente.
	open('Jogadas.txt',write, File),close(File), % zera o Jogadas.
	!.

/*Le uma lista de um arquivo*/
read_list([X|L],File):- % recebe um stream  
	read(File,X),
	not(X = end_of_file),
	read_list(L,File),
	!.
read_list([],_):-!.
read_mines(List_minas,File):- read_list(List_minas,File).
read_values(List_values,File):- read_list(List_values,File).
file_to_list(Nome,List):- % recebe o nome de um arquivo
	open(Nome,read,File),
  	read_list(List,File),
  	close(File)
	.


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
	search_Col(1,Size,List_minas,List_board),
	!.
search_board(Row,List_minas,Size,List_board):-
	R is Row - 1,
	search_board(R,List_minas,Size,List_board_Row),
	search_Col(Row,Size,List_minas,List_board_Col),
	append(List_board_Row,List_board_Col,List_board),
	!.
	
/*Percorre as colunas da linha*/
search_Col(Row,1,List_minas,Element):-
	get_element_Valor(Row,1,List_minas,Element),
	!.
search_Col(Row,Col,List_minas,List_board):-
	C is Col - 1,
	search_Col(Row,C,List_minas,List_Temp),
	get_element_Valor(Row,Col,List_minas,Element),
	append(List_Temp,Element,List_board),
	!.

/*Gera cada elemento valor(Row,Col,K) */
get_element_Valor(Row,Col,List_minas,[]):- member(mina(Row,Col),List_minas),!.
get_element_Valor(Row,Col,List_minas,[valor(Row,Col,K)]):- mine_neighbor(valor(Row,Col,K),List_minas),!.

/*Descobre valor K de bonbas ao redor de um campo*/
mine_neighbor(valor(Row,Col,K),List_minas):-
		Aux is 0,
		there_is_mine(Row,Col,posicao1,List_minas,Mina1), Aux1 is Aux  + Mina1,
		there_is_mine(Row,Col,posicao2,List_minas,Mina2), Aux2 is Aux1 + Mina2,
		there_is_mine(Row,Col,posicao3,List_minas,Mina3), Aux3 is Aux2 + Mina3,
		there_is_mine(Row,Col,posicao4,List_minas,Mina4), Aux4 is Aux3 + Mina4,
		there_is_mine(Row,Col,posicao5,List_minas,Mina5), Aux5 is Aux4 + Mina5,
		there_is_mine(Row,Col,posicao6,List_minas,Mina6), Aux6 is Aux5 + Mina6,
		there_is_mine(Row,Col,posicao7,List_minas,Mina7), Aux7 is Aux6 + Mina7,
		there_is_mine(Row,Col,posicao8,List_minas,Mina8), Aux8 is Aux7 + Mina8,
		K = Aux8
		.

/*Diz se tem mina em um determinado vizinho*/
there_is_mine(Row,Col,posicao1,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao1,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao2,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao2,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao3,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao3,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao4,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao4,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao5,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao5,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao6,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao6,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao7,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao7,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(Row,Col,posicao8,List_minas,1):-
	cordenadas_da_posicao(Row,Col,posicao8,X,Y),
	member(mina(X,Y),List_minas),
	!.
there_is_mine(_,_,_,_,0).

cordenadas_da_posicao(Row,Col,posicao1,R,C):-
	C is Col - 1,
	R is Row + 1.
cordenadas_da_posicao(Row,Col,posicao2,R,C):-
	C is Col,
	R is Row + 1.
cordenadas_da_posicao(Row,Col,posicao3,R,C):-
	C is Col + 1,
	R is Row + 1.
cordenadas_da_posicao(Row,Col,posicao4,R,C):-
	C is Col + 1,
	R is Row.
cordenadas_da_posicao(Row,Col,posicao5,R,C):-
	C is Col + 1,
	R is Row - 1.
cordenadas_da_posicao(Row,Col,posicao6,R,C):-
	C is Col,
	R is Row - 1.
cordenadas_da_posicao(Row,Col,posicao7,R,C):-
	C is Col - 1,
	R is Row - 1.
cordenadas_da_posicao(Row,Col,posicao8,R,C):-
	C is Col - 1,
	R is Row.

/*Retorna o elemento valor(Row,Col,K), se existir, para (Row,Col) definidas*/
get_element_from_List_board(Row,Col,[X|_],X):- X = valor(Row,Col,_),!.
get_element_from_List_board(Row,Col,[_|List_board],X):- get_element_from_List_board(Row,Col,List_board,X).

/*Gera os campos que serão abertos apos uma jogada*/
gera_valores(Row,Col,_,_,List_minas,['game_over(loose)']):- % campo com mina 
	member(mina(Row,Col),List_minas), /*Falta implementar a ação de limbar o tabuleiro!*/
	!.
gera_valores(Row,Col,Size,_,_,[]):- % campo fora do limite do tabuleiro
	( Row > Size ; Row < 1 ; Col > Size ; Col < 1) ,
	write('Campo fora do tabuleiro'),
	!.
gera_valores(Row,Col,_,List_board,_,[valor(Row,Col,K)]):- % campo com K>0 minas vizinhas.
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)), K > 0,
	!.
gera_valores(Row,Col,Size,List_board,_,[valor(Row,Col,K)|L]):- % campo com 0 minas vizinhas
	get_element_from_List_board(Row,Col,List_board,valor(Row,Col,K)),

	cordenadas_da_posicao(Row,Col,posicao1,R1,C1),
	cordenadas_da_posicao(Row,Col,posicao2,R2,C2),
	cordenadas_da_posicao(Row,Col,posicao3,R3,C3),
	cordenadas_da_posicao(Row,Col,posicao4,R4,C4),
	cordenadas_da_posicao(Row,Col,posicao5,R5,C5),
	cordenadas_da_posicao(Row,Col,posicao6,R6,C6),
	cordenadas_da_posicao(Row,Col,posicao7,R7,C7),
	cordenadas_da_posicao(Row,Col,posicao8,R8,C8),

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

	% Nem sempre Aux7 tem o elemento valor(Row,Col,K). Isso ele precisa ser adicionado
	% porem, para não ter esse elemento repetido, é preciso sempre checar e retirar.
	retira_elemento(valor(Row,Col,K),Aux7,Aux8), 
	limpar_list(Aux8,L),
	!.

/*gera_valores/7 faz o mesmo que gera_valores/6, porem existe uma memoria das casas com k=0 já vizitadas*/
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

	cordenadas_da_posicao(Row,Col,posicao1,R1,C1),
	cordenadas_da_posicao(Row,Col,posicao2,R2,C2),
	cordenadas_da_posicao(Row,Col,posicao3,R3,C3),
	cordenadas_da_posicao(Row,Col,posicao4,R4,C4),
	cordenadas_da_posicao(Row,Col,posicao5,R5,C5),
	cordenadas_da_posicao(Row,Col,posicao6,R6,C6),
	cordenadas_da_posicao(Row,Col,posicao7,R7,C7),
	cordenadas_da_posicao(Row,Col,posicao8,R8,C8),
	
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

/*Procedimento para cada Jogada*/
posicao(Row,Col):- % Programa 2 

	open('Mina.txt',read,Mina_file),
	read(Mina_file,Board_size),
	tabuleiro(Size) = Board_size,
	read_mines(List_minas,Mina_file),
	close(Mina_file),

	file_to_list('Board.txt',List_board),

	gera_valores(Row,Col,Size,List_board,List_minas,Novo_Ambiente),
	imprimir_ambiente(Novo_Ambiente,List_board),
	!.


/* Guarda no arquivo Ambiente, o novo embiente apos uma jogada, e imprime na tela apenas as novas casas aberas */
imprimir_ambiente(Novo_Ambiente,List_board):-
	file_to_list('Ambiente.txt',List_Ambiente),

	uniao_lista_and_print(Novo_Ambiente,List_Ambiente,Ambiente_temp),

	is_game_over(List_board,Ambiente_temp,Ambiente_final),

	open('Ambiente.txt',write,Output),
	write_values(Ambiente_final,Output),
	close(Output).

uniao_lista_and_print([],L,L).
uniao_lista_and_print([X|L1],L2,L3):-
	member(X,L2),
	uniao_lista_and_print(L1,L2,L3),
	!.
uniao_lista_and_print([X|L1],L2,[X|L3]):-
    not(member(X,L2)),
    write_screen(X), %% Para imprimir na tela apenas os elementos novos!
    uniao_lista_and_print(L1,L2,L3),
    !.

/* Verifica se L1 está contido em L2*/
contains_list([],_).
contains_list([X|L1],L2):- member(X,L2), contains_list(L1,L2).

is_game_over(List_board,List_ambiente,[game_over(win)|List_ambiente]):-
	contains_list(List_board,List_ambiente),
	write('You_win_Game_Over'), nl,
	!.
is_game_over(_,L,L).

/** Problema 3 - Jogar!  **/

joga:- start_game(Size), joga(Size).

joga(Size):- joga_aleatorio(Size,[],List_Ambiente), joga_(Size,List_Ambiente).

joga_(_,List_Ambiente):- member(game_over(_),List_Ambiente),!.
joga_(Size,List_Ambiente):-
  	
  	criando_disjuncoes(List_Ambiente,Disjuncoes_temp,Size),
  	remove_lista_vazia(Disjuncoes_temp,Disjuncoes),
  	
  	simplifica(Disjuncoes, [Disj]), 

  	get_information(Disj,List_literais),
  	
  	find_mina(List_literais),
  	find_play(List_literais,List_posicoes),
  	play_all(List_posicoes,Size,List_Ambiente,Nova_List_Ambiente),

	joga_(Size,Nova_List_Ambiente),
	!.

/* 
	Dado a lista de anbiente. Para cada casa com valor(Row,Col,K) com K > 0
	o programa cria esperaços booleanas de todas as possiveis combinaçoes de 
	minas ao redor da casa (Row,Col).
*/

/* criando_disjuncoes/3 é auxiliar para chamr criando_disjuncoes/4*/
criando_disjuncoes(List_Ambiente,Disjuncoes,Size):-
	criando_disjuncoes(List_Ambiente,List_Ambiente,Disjuncoes,Size),
	!.
/* Cria uma conjunção de dijunções de cada elemento valor(Row,Col,K) */
criando_disjuncoes(_,[],[],_):-!.
criando_disjuncoes(List_Ambiente,[valor(_,_,0)|Board],Resto,Size):- criando_disjuncoes(List_Ambiente,Board,Resto,Size),!.
criando_disjuncoes(List_Ambiente,[valor(Row,Col,K)|Board],[Disj|Resto],Size):-
	
	cordenadas_da_posicao(Row,Col,posicao1,R1,C1), 
	cordenadas_da_posicao(Row,Col,posicao2,R2,C2), 
	cordenadas_da_posicao(Row,Col,posicao3,R3,C3), 
	cordenadas_da_posicao(Row,Col,posicao4,R4,C4), 
	cordenadas_da_posicao(Row,Col,posicao5,R5,C5), 
	cordenadas_da_posicao(Row,Col,posicao6,R6,C6), 
	cordenadas_da_posicao(Row,Col,posicao7,R7,C7), 
	cordenadas_da_posicao(Row,Col,posicao8,R8,C8), 

	gera_literal(R1,C1,Literal1,List_Ambiente,Size), append(Literal1,[],Aux1), 
	gera_literal(R2,C2,Literal2,List_Ambiente,Size), append(Literal2,Aux1,Aux2), 
	gera_literal(R3,C3,Literal3,List_Ambiente,Size), append(Literal3,Aux2,Aux3), 
	gera_literal(R4,C4,Literal4,List_Ambiente,Size), append(Literal4,Aux3,Aux4), 
	gera_literal(R5,C5,Literal5,List_Ambiente,Size), append(Literal5,Aux4,Aux5), 
	gera_literal(R6,C6,Literal6,List_Ambiente,Size), append(Literal6,Aux5,Aux6), 
	gera_literal(R7,C7,Literal7,List_Ambiente,Size), append(Literal7,Aux6,Aux7), 
	gera_literal(R8,C8,Literal8,List_Ambiente,Size), append(Literal8,Aux7,Aux8), 
	List_literais = Aux8,

	criando_disjucao(List_literais,K,Disj,Size),

	criando_disjuncoes(List_Ambiente,Board,Resto,Size),
	!.

/* Retorna um literal no formato [Row,Col] caso seja uma casa fechada */
gera_literal(Row,Col,[],List_Ambiente,Size):-
	( Row > Size ; Row < 1 ; Col > Size ; Col < 1 ; member(valor(Row,Col,_),List_Ambiente)), 
	!.
gera_literal(Row,Col,[Literal],_,_):- Literal = [Row,Col],!.

/* Cria uma disjunção, que são as conbinações de todas as situações possiveis dado um valor(Row,Col,K) */
criando_disjucao([],_,[[]],_).
criando_disjucao([Literal|List_literais],0,[[barra(Literal)|List_restante]],Size):-
	criando_disjucao(List_literais,0,[List_restante],Size),
	!.
criando_disjucao(List_literais,K,[List_literais],_):-
	list_len(List_literais,K),
	!.
criando_disjucao([Literal|List_literais],K,Disj_final,Size):-
	
	criando_disjucao(List_literais,K,Temp_1,Size),
	add_literal(barra(Literal),Temp_1,Disj_1),

	K2 is K - 1,
	
	criando_disjucao(List_literais,K2,Temp_2,Size),
	add_literal(Literal,Temp_2,Disj_2),
	append(Disj_1,Disj_2,Disj_final),
	!.

/* Adiciona um litral em todas as clausulas de uma disjunção */
add_literal(_,[],[]).
add_literal(Literal,[Clau|Disj_1],[[Literal|Clau]|Disj_2]):-
	add_literal(Literal,Disj_1,Disj_2),
	!.

/* Tamanho de uma lista */
list_len([],0).
list_len([_|L],N):-list_len(L,M), N is M+1.

/* Dado uma lista de literais já filtradas pela get_information/2, procura todos os elementos [Row,Col] que representa mina*/
find_mina([]).
find_mina([barra(_)|List_literais]):- find_mina(List_literais),!.
find_mina([[Row,Col]|List_literais]):- 
	file_to_list('Jogadas.txt',List_minas),
	not(member(mina(Row,Col),List_minas)),

	Mina = mina(Row,Col), write(Mina),write('.'),nl,
	open('Jogadas.txt', append, File),
	write(File,Mina),write(File,'.'),nl(File), close(File),
	
	find_mina(List_literais),
	!.
find_mina([[_,_]|List_literais]):- find_mina(List_literais),!. 

/* Dado uma lista de literais já filtradas pela get_information/2, procura elementos barra([Row,Col]) que representa não tem mina*/
find_play([],[]).
find_play([barra(Literal)|List_literais],[Literal|Resto]):- find_play(List_literais,Resto),!.
find_play([_|List_literais],Resto):- find_play(List_literais,Resto),!.

/* Joga todas as posições achadas pelo find_play */
/*  LA = List_Ambiente  */
play_all([],Size,LA,Nova_LA):- 
	joga_aleatorio(Size,LA,Nova_LA),
	!.
play_all([[Row,Col]],_,LA,Nova_LA):- 
	joga_na_posicao(Row,Col,LA,Nova_LA),
	!.
play_all([[Row,Col]|List],_,LA,Nova_LA):- 
	joga_na_posicao(Row,Col,LA,Nova_LA_temp), 
	play_all(List,_,Nova_LA_temp,Nova_LA),!.

/* Joga aleatoriamente, evitando lugares onde já foram jogados e lugares que se sabe que é mina */
joga_aleatorio(S,LA,Nova_LA):- Size is S + 1, random(1,Size,Row), random(1,Size,Col), joga_na_posicao(Row,Col,LA,Nova_LA).
joga_na_posicao(_,_,List_Ambiente,List_Ambiente):- member(game_over(_),List_Ambiente),!.
joga_na_posicao(Row,Col,List_Ambiente,Nova_List_Ambiente):-
	file_to_list('Jogadas.txt',List_jogadas_e_minas),
	
	not(member(valor(Row,Col,_),List_Ambiente)),  % checa se está aberta.
	not(member(posicao(Row,Col),List_jogadas_e_minas)), % checa se já foi jogada antes.
	not(member(mina(Row,Col),List_jogadas_e_minas)),  % checa se já se sabe que é uma mina.

	open('Jogadas.txt', append, File),
	nl,write(posicao(Row,Col)),write('.'),nl, % imprime na tela.
	write(File,posicao(Row,Col)),write(File,'.'),nl(File), % imprime no arquivo.
	close(File),

	posicao(Row,Col),
	file_to_list('Ambiente.txt', Nova_List_Ambiente),
	!.
joga_na_posicao(_,_,List_Ambiente,List_Ambiente).

/* Auxicliar */
remove_lista_vazia([],[]).
remove_lista_vazia([ [[]] |L],Lout):- remove_lista_vazia(L,Lout).
remove_lista_vazia([X|L],[X|Lout]):- remove_lista_vazia(L,Lout).

/* INICIO DO CODIGO QUE RESOLVE AS DIJUSNÇOES */

	/* Dado uma disjunção, retorna uma lista com todos os literias que estão em todas as clausulas */
	get_information([Clau],Clau):-!.
	get_information([Clausula|Clausulas],List_literais):-
		get_information(Clausulas,Clausula,List_literais),
		!.

	get_information(_,[],[]).
	get_information(Disj,[Literal|Literais],[Literal|Resto]):-
		is_there_all_list(Literal,Disj),
		get_information(Disj,Literais,Resto),
		!.
	get_information(Disj,[_|Literais],Resto):-	
		get_information(Disj,Literais,Resto),
		!.

	/* Checa se um elemento está em todas as listas */
	is_there_all_list(Literal,[Clau]):-
		member(Literal,Clau),
		!.
	is_there_all_list(Literal,[Clau|Clausulas]):-
		member(Literal,Clau),
		is_there_all_list(Literal,Clausulas),
		!.

	/* Simplifica uma lista de disjuncoes em apenas uma disjuncao*/
	simplifica([Disj],[Disj]).
	simplifica([Disjuncao1, Disjuncao2 |List_disj],Resultado):- 
		fusao_disjuncoes(Disjuncao1,Disjuncao2,Disj_temp),
		simplifica([Disj_temp|List_disj],Resultado),
		!.

	/* Junta duas disjunções */
	fusao_disjuncoes([],_,[]).
	fusao_disjuncoes([Clau|Clausulas], Disj, Elemento ):- 
		distributiva(Clau,Disj,[]),
		fusao_disjuncoes(Clausulas,Disj,Elemento),
		!.
	fusao_disjuncoes([Clau|Clausulas], Disj, Elemento ):-
		distributiva(Clau,Disj,Disj_temp),
		fusao_disjuncoes(Clausulas,Disj,Disj_resultante),
		append(Disj_temp, Disj_resultante, Elemento),
		!.

	/* Aplica distributiva de uma clausula em uma disjunção */
	distributiva(_,[],[]).
	distributiva(Clausula,[Clau|Clausulas],Retorno):- 
		multiplica_expresao_boleana(Clausula,Clau,[]), 
		distributiva(Clausula,Clausulas,Retorno),
		!.
	distributiva(Clausula,[Clau|Clausulas],[Clau_resultante|Retorno]):- 
		multiplica_expresao_boleana(Clausula,Clau,Clau_resultante), 
		distributiva(Clausula,Clausulas,Retorno),
		!.

	/* Junta duas clausulas se possivel */
	/* multiplica_expresao_boleana_ é quando a clausula resultante é [] */
	/* multiplica_expresao_boleana é quando a clausula resultante é diferente de [] */
	/* A diferença de das funções foi por uma questão de otimização! */
	multiplica_expresao_boleana_([barra(Literal)|_],Clausula):- member(Literal,Clausula),!.
	multiplica_expresao_boleana_([Literal|_],Clausula):- member(barra(Literal),Clausula),!.
	multiplica_expresao_boleana_([_|Literais],Clausula):- multiplica_expresao_boleana_(Literais,Clausula),!.

	multiplica_expresao_boleana(Clausula1,Clausula2,[]):-
		multiplica_expresao_boleana_(Clausula1,Clausula2),
		!.
	multiplica_expresao_boleana(Clausula1,Clausula2,Clau_resultante):-
		uniao_lista(Clausula1,Clausula2,Clau_resultante),
		!. 

	/* Junta duas Listas em uma sem repetição */
	uniao_lista([],L,L).
	uniao_lista([X|L1],L2,L3):-
		member(X,L2),
		uniao_lista(L1,L2,L3),
		!.
	uniao_lista([X|L1],L2,[X|L3]):-
	    not(member(X,L2)),
	    uniao_lista(L1,L2,L3),
	    !.

/* FIM DO CODIGO QUE RESOLVE AS DIJUSNÇOES*/