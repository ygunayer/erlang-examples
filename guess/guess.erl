-module(guess).
-export([start/0]).

-import(game, [init/0]).

start() ->
    Game = spawn_link(game, init, []),
    Game ! {self(), play},
    receive
        {finished} -> io:format("[program] Game has finished, exiting~n:")
    end.
