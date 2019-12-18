placeMirrors(LaserInd, Obstacles, MirList) :-
    mir(LaserInd, Obstacles, right, [1, LaserInd], [[1, LaserInd],[0, LaserInd]], [], MirList).

% checks that index is in bounds.
checkInd([X, Y]) :- X < 12, X >= 0, Y >= 0, Y < 10.

% ensures index is outside an obstacle.
outsideWall([A, B],[X, Width, Height]) :-
    D is X+Width,
    not(between(X,D,A));
    B < 10-Height.

notOnPerson([X, Y]) :- X < 5; X > 7; Y > 5.

% recursively check if a is inside any.
% obstacles in the list.
checkObs([_,_], []).
checkObs([X,Y], [H|T]) :-
	nth0(0, H, ObsX),
	nth0(1, H, Width),
	nth0(2, H, Height),
	notOnPerson([X, Y]),
	outsideWall([X, Y],[ObsX, Width, Height]),
    	checkObs([X, Y], T).

% checks that index has not been visited yet.
visited([_,_], []).
visited([CurrentX, CurrentY], [H|T]) :- [CurrentX, CurrentY] \= H, visited([CurrentX, CurrentY], T).

mir(A, _,_,[11, A],_,M,M).
mir(LaserInd, Obstacles, PrevDir, [X, Y], Visited, MirList, NewMirrors) :-
	move(LaserInd, PrevDir, NewPrev,[X,Y],[NewX,NewY],MirList,NewMir),
	checkInd([NewX, NewY]),
	checkObs([NewX, NewY], Obstacles),
	visited([NewX, NewY], Visited),
	mir(LaserInd, Obstacles, NewPrev, [NewX, NewY],[[NewX, NewY]|Visited], NewMir, NewMirrors).

% turn right.
move(_, up, NewPrev, [CurrentX, CurrentY], [NewX, CurrentY], MirList, NewMirList) :-
	NewX is CurrentX+1,
	NewPrev = right,
	NewMirList = [[CurrentX, CurrentY,/]|MirList].

move(_, down, NewPrev, [CurrentX, CurrentY], [NewX, CurrentY], MirList, NewMirList) :-
	NewX is CurrentX+1,
	NewPrev = right,
	NewMirList = [[CurrentX, CurrentY,\]|MirList].

move(_,right, NewPrev, [CurrentX, CurrentY], [NewX, CurrentY], MirList, MirList)  :-
	NewX is CurrentX+1,
	NewPrev = right.

% turn downwards.
move(Start, right, NewPrev, [CurrentX, CurrentY],[CurrentX, NewY], MirList, NewMirList) :-
	NewY is CurrentY-1,
	NewPrev = down,
	[CurrentX, NewY] \= [11, Start],
	NewMirList = [[CurrentX, CurrentY,\]|MirList].

move(Start, down, NewPrev, [CurrentX, CurrentY], [CurrentX, NewY], MirList, MirList) :-
	NewY is CurrentY-1,
	[CurrentX, NewY] \= [11, Start],
	NewPrev = down.

% turn upwards.
move(Start, right, NewPrev, [CurrentX, CurrentY],[CurrentX, NewY], MirList, NewMirList) :-
	NewY is CurrentY+1,
    	NewPrev = up,
    	[CurrentX, NewY] \= [11, Start],
    	NewMirList = [[CurrentX, CurrentY,/]|MirList].

move(Start, up, NewPrev, [CurrentX, CurrentY], [CurrentX, NewY], MirList, MirList)  :-
    	NewY is CurrentY+1,
    	[CurrentX, NewY] \= [11, Start],
    	NewPrev = up.

