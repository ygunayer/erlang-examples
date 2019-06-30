-module(bar).
-export([start/0]).

start() ->
    {foo_handler, 'foo@erlang.example'} ! {self(), hello},
    io:format("Sent hello to foo_handler at foo@erlang.example~n"),
    receive
        {goodbye} -> io:format("bar received `goodbye` and will terminate~n"), self() ! stop
    end.
