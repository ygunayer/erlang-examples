-module(game).
-export([init/0]).

init() ->
    idle().

idle() ->
    receive
        {Program, play} ->
            Player = spawn_link(player, init, []),
            Player ! {ready, self()},
            playing(Program, Player, generate_number())
    end.

generate_number() ->
    Number = rand:uniform(100),
    io:format("[server] Correct number is ~w~n", [Number]),
    Number.

playing(Program, Player, N) ->
    receive
        {guess, X} when X == N -> Player ! {win}, playing(Program, Player, N);
        {guess, _} -> Player ! {try_again}, playing(Program, Player, N);
        {restart} ->
            io:format("[server] Restarting the game with a new number.~n"),
            Player ! {ready, self()},
            playing(Program, Player, generate_number());
        {leave} -> io:format("[server] Player has left the game. Terminating...~n"), Program ! {finished}, self() ! stop
    end.
