-module(bar).
-export([start/0]).

start() ->
    % notice how we can transparently send our `Pid` to remote node
    % without having to specify anything
    {foo_handler, 'foo@erlang.example'} ! {self(), hello},
    io:format("[bar] Sent `hello` from ~w to `foo_handler` at 'foo@erlang.example'~n", [node()]),
    receive
        {goodbye} ->
            io:format("[bar] Received `goodbye`, terminating...~n"),
            self() ! stop
    end.
