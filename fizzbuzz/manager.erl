-module(manager).
-export([init/0]).

init() ->
    idle().

idle() ->
    receive
        {go, N} ->
            Handler = spawn_link(handler, init, []),
            Numbers = lists:seq(1, N),
            lists:foreach(
                fun(X) ->
                    Handler ! {self(), {handle, X}}
                end,
                Numbers
            ),
            waiting_for_results(Numbers)
    end.

waiting_for_results(Numbers) ->
    receive
        {Handler, {result, Number, Output}} ->
            io:format("~s~n", [Output]),
            Remaining = lists:delete(Number, Numbers),
            case length(Remaining) of
                0 -> io:format("Finished processing all numbers.~n"), Handler ! stop, idle();
                _ -> waiting_for_results(Remaining)
            end;
        {go, _} -> io:format("Manager is currently busy~n"), waiting_for_results(Numbers)
    end.
