-module(bar).
-export([start/0]).

start() ->
    % notice how we can transparently send our `Pid` to remote node
    % without having to specify anything
    {foo_handler, 'foo@erlang.example'} ! {self(), hello},
    io:format("Sent hello to foo_handler at foo@erlang.example~n"),
    receive
        {goodbye} ->
            io:format("bar received `goodbye` and will terminate~n"),
            self() ! stop
    end.
