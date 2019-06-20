-module(bar).
-export([start/0]).
-import(foo, [foo/0]).

start() ->
    io:write(foo:foo()),
    io:format("~n").
