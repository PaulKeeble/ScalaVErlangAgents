-module(client).

-export([runTest/1]).

runTest(Size) -> 
	server:start_link(),
	Start=now(),
	Count=test(Size),
	Finish=now(),
	server:stop(),
	io:format("Count is ~p~n",[Count]),
	io:format("Test took ~p seconds~n",[elapsedTime(Start,Finish)]),
	io:format("Throughput=~p per sec~n",[throughput(Size,Start,Finish)]).

test(Size) ->
	plists:foreach(fun (_X)-> server:bytes(100) end,lists:seq(1,Size)),
	server:get_count().

elapsedTime(Start,Finish) -> 
	(toMicroSeconds(Finish) - toMicroSeconds(Start)) /1000000.

toMicroSeconds({MegaSeconds,Seconds,MicroSeconds}) -> 
	(MegaSeconds+Seconds) * 1000000 + MicroSeconds.

throughput(Size,Start,Finish) -> Size / elapsedTime(Start,Finish).