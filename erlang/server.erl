%%%
%%% @author Paul
%%% @doc RPC over TCP sever.
%%% This module defines that listens on TCP and executes RCP commands
%%% @end
-module(server).

-behaviour(gen_server).

%% API
-export([start_link/0,bytes/1,get_count/0,stop/0]).

%% gen_server callabacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-define(SERVER,?MODULE).

-record(state,{count=0}).

%% API

%% @doc Starts the server.
%% @spec start_link(Port::integer()) -> {ok,Pid}
%% where
%%  Pid = pid()
%% @end
start_link() ->
	gen_server:start_link({local,?SERVER},?MODULE,[],[]).

%% @doc Fetches the number of requests made
%% @spec get_count() -> {ok,Count}
%% where
%%  Count = integer()
%% @end
get_count() -> gen_server:call(?SERVER,get_count).

bytes(Count) -> gen_server:cast(?SERVER,{bytes,Count}).

%% @doc stops the server
%% @spec stop() -> ok
%% @end
stop() -> gen_server:cast(?SERVER,stop).

%% gen_server callbacks
init(_Params) ->
	{ok,#state{count=0}}.

handle_call(_Request,_From,State) -> 
	{reply,{ok,State#state.count},State}.

handle_cast(stop,State) -> {stop,normal,State};
handle_cast({bytes,Count},State) ->
	UpdatedCount = State#state.count+Count,
	{noreply,State#state{count=UpdatedCount}}.

handle_info(_Msg,State) ->
	{noreply,State}.

terminate(_Reason,_State) -> ok.

code_change(_OLdVersion,State,_Extra) ->
	{ok,State}.
