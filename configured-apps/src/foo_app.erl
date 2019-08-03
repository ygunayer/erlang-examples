-module(foo_app).
-behaviour(application).
-export([start/2, stop/1, do_print/0]).

do_print() ->
    {ok, Color} = application:get_env(foo, color),
    {ok, Animal} = application:get_env(foo, animal),
    io:format("Look, a ~s ~s!~n", [Color, Animal]),
    init:stop().

start(_StartType, _StartArgs) ->
    Pid = spawn_link(?MODULE, do_print, []),
    {ok, Pid}.

stop(_State) ->
    ok.
