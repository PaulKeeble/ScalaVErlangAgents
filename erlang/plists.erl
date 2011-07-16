-module(plists).

-export([foreach/2]).


% Algorithm - Split into 4 lists, have each list and the fun run in a separate spawned process
foreach(Fun,List) -> 
	Splits = split(8,List),
	Pids = execute(Splits,Fun,self()),
	waitCompletion(Pids).

split(1,List) -> [List];
split(Pieces,List) -> 
	Length = length(List),
	N = round(Length/Pieces),
	{List1,Remainder} = lists:split(N,List),
	[List1|split(Pieces-1,Remainder)].

execute([],_Fun,_EndPid) -> [];
execute([L|Lists],Fun,EndPid) -> 
	Pid = spawn( fun()->runFun(Fun,L,EndPid) end ),
	[Pid|execute(Lists,Fun,EndPid)].

runFun(Fun,List,EndPid) -> lists:foreach(Fun,List),
	EndPid ! finished.

waitCompletion(Pids) -> 
	Times = lists:seq(1,length(Pids)),
	lists:foreach(fun (_X) -> 
			receive finished -> ok 
			end
		end, Times).