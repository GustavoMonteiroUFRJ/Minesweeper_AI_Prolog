main(Value):-
  open('listadevalores.txt',read,Input),
  read_values(List_values,Input),
  close(Input),
  compareLists(Value,List_values,FinalList),
  open('listadevalores.txt',write,Output),
  writeValues(FinalList,Output),
  close(Output).


read_values([X|L],File):-
	read(File,X),
	not(X = end_of_file),
	read_values(L,File),!.

read_values([],_):-!.

writeSingle([X|L]):-
  write(X),write('.'),nl,
	writeSingle(L),!.

writeSingle([]):-!.


writeValues([X|L],File):-
	write(File,X),write(File,'.'),nl(File),
	writeValues(L,File),!.

writeValues([],_):-!.

compareLists([],L,L).

compareLists([X1|L1],L2,L3):-
  member(X1,L2),
  compareLists(L1,L2,L3).

compareLists([X1|L1],L2,[X1|L3]):-
    not(member(X1,L2)),
    write(X1),write('.'),nl,
    compareLists(L1,L2,L3).
