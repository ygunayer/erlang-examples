-module(fizzbuzz).
-import(manager, [init/0]).
-export([start/0]).

get_user_input() ->
    case io:fread("Please enter a number to count towards: ", "~d") of
        {ok, [N]} -> N;
        _ -> io:format("You have entered an invalid number, please try again.~n"), get_user_input()
    end.

start() ->
    Limit = get_user_input(),
    Manager = spawn_link(manager, init, []),
    Manager ! {go, Limit},
    Manager ! {go, Limit}. % consciously send duplicate messages to demonstrate statefulness
