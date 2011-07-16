-module(server2).

-export([start_link/0,bytes/1,get_count/0,stop/0]).

-define(SERVER,?MODULE).

start_link() ->
	PID = spawn(fun()-> serve_request(0) end),
	register(?SERVER,PID).
	
stop() -> 
	?SERVER ! exit,
	unregister(?SERVER).

get_count() -> 
	?SERVER ! {get_count,self()},
	receive
		X -> X
	end.

bytes(Count) -> 
	?SERVER ! {bytes,Count},
	ok.

serve_request(State) ->
	receive
		{bytes,Count} -> 
			UpdatedState = State + Count,
			serve_request(UpdatedState);
		{get_count,PID} -> 
			PID ! State,
			serve_request(State);
		exit -> ok
	end.