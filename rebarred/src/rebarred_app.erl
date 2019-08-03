%%%-------------------------------------------------------------------
%% @doc rebarred public API
%% @end
%%%-------------------------------------------------------------------

-module(rebarred_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    rebarred_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
