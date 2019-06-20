-module(handler).
-export([init/0]).

decide(N) when (N rem 3 == 0) and (N rem 5 == 0) -> "FizzBuzz";
decide(N) when (N rem 3 == 0) -> "Fizz";
decide(N) when (N rem 5 == 0) -> "Buzz";
decide(N) -> integer_to_list(N).

loop() ->
    receive
        {Sender, {handle, X}} ->
            Result = decide(X),
            Sender ! {self(), {result, X, Result}},
            loop()
    end.

init() ->
    loop().
