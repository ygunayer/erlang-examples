-module(player).
-export([init/0]).

init() ->
    initializing().

initializing() ->
    receive
        {ready, Game} -> playing(Game)
    end.

playing(Game) ->
    Guess = read_guess(),
    Game ! {guess, Guess},
    receive
        {win} ->
            case ask_for_restart() of
                {ok} -> Game ! {restart}, initializing();
                _ -> Game ! {leave}, self() ! stop
            end;
        {try_again} -> io:format("Aww, that's not correct, please try again.~n"), playing(Game)
    end.

read_guess() ->
    case io:fread("Pick a number between 1 and 100 (inclusive): ", "~d") of
        {ok, [N]} when (N > 0) and (N < 100) -> N;
        _ -> io:format("You have entered an invalid number.~n"), read_guess()
    end.

ask_for_restart() ->
    case io:fread("You win! Play another round? (y/N) ", "~s") of
        {ok, [C]} when (C == "y") or (C == "Y") -> {ok};
        _ -> {cancel}
    end.
