-module(generator).
-export([start_link/0, loop/0]).

start_link() ->
    Pid = spawn_link(?MODULE, loop, []),
    Pid ! generate,
    {ok, Pid}.

loop() ->
    receive
        generate ->
            Uuid = uuid:get_v4(),
            UuidString = uuid:uuid_to_string(Uuid),
            io:format("[generator] New UUID: ~s~n", [UuidString]),
            timer:send_after(5000, self(), generate),
            loop()
    end.
