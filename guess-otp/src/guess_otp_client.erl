-module(guess_otp_client).
-export([start_link/0, init/1]).

-behaviour(gen_statem).
-export([callback_mode/0, initializing/3, playing/3]).
-define(SERVER_NAME, ?MODULE).

%% Public API
%% ------------------------
start_link() ->
    gen_statem:start_link({local, ?SERVER_NAME}, ?MODULE, {}, []).

%% Private API
%% ------------------------
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

%% Callback implementations
%% ------------------------
init(_Args) ->
    io:format("[client] Booting up...~n"),
    {ok, initializing, {}}.

callback_mode() ->
    % we'll have individual handlers for each state
    [state_functions, state_enter].

%% State functions
%% -----------------------
%% Initialization state
initializing(enter, _EventContent, Data) ->
    %% force trigger the state handler
    gen_statem:cast(?SERVER_NAME, {start}),
    {next_state, initializing, Data};
initializing(_EventType, _EventContent, _Data) ->
    io:format("[client] Starting a new game~n"),
    case guess_otp_server:join() of
        {ready, ServerPid} ->
            io:format("[client] Joined the game server with pid ~w~n", [ServerPid]),
            {next_state, playing, {ServerPid}};
        Other ->
            io:format("[client] Received unexpected response ~w from server, terminating~n...", [Other]),
            {stop, {unknown, Other}}
    end.

%% In-game state
playing(enter, _OldState, Data) ->
    %% force trigger the state handler
    gen_statem:cast(?SERVER_NAME, {}),
    {next_state, playing, Data};
playing(_EventType, _OldState, Data) ->
    Guess = read_guess(),
    case guess_otp_server:guess(Guess) of
        {try_again} ->
            io:format("Aww, that's not correct, please try again.~n"),
            {repeat_state, Data};
        {win} ->
            case ask_for_restart() of
                {ok} ->
                    guess_otp_server:restart(),
                    {repeat_state, Data};
                _ ->
                    guess_otp_server:leave(),
                    {stop, normal}
            end;
        _ -> {keep_state, Data}
    end.
