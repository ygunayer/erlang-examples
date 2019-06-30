-module(foo).
-export([start/0]).

start() ->
    register(foo_handler, self()),
    io:format("foo is now registered with the name `foo_handler`~n"),
    receive
        {Sender, hello} -> io:format("foo received `hello` and will terminate after replying `goodbye` back~n"), Sender ! {goodbye}, self() ! stop
    end.
