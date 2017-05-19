

file_to_list(Nome,Atr,List):-
	open(Nome,read,File),
	file_to_list_(File,Atr,List),
	write(List),nl,
	close(File)
	.

file_to_list_(File,_,[]):- at_end_of_stream(File).

file_to_list_(File,posicao,[posicao(Row,Col)|List]):-
	read(File,posicao(Row,Col)),
	file_to_list_(File,posicao,List),
	!.
file_to_list_(File,posicao,List):-
	file_to_list_(File,posicao,List),
	!.
	
file_to_list_(File,mina,[mina(Row,Col)|List]):-
	read(File,mina(Row,Col)),
	file_to_list_(File,mina,List),
	!.
file_to_list_(File,mina,List):-
	file_to_list_(File,mina,List),
	!.