-module(guess_otp_server).
-export([join/0, guess/1, restart/0, leave/0]).

-behaviour(gen_server).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(SERVER_NAME, ?MODULE).

%% Public API
%% ------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER_NAME}, ?MODULE, {}, []).

join() ->
    gen_server:call(?SERVER_NAME, {join}).

guess(N) ->
    gen_server:call(?SERVER_NAME, {guess, N}).

restart() ->
    gen_server:call(?SERVER_NAME, {restart}).

leave() ->
    gen_server:call(?SERVER_NAME, {leave}).

%% Private API
%% ------------------------
generate_number() ->
    Number = rand:uniform(100),
    io:format("[server] Correct number is ~w~n", [Number]),
    Number.

%% Callback implementations
%% ------------------------
init(_Args) ->
    io:format("[server] Booting up...~n"),
    {ok, {idle}}.

%% Call handler for the idle state
handle_call(Request, {Pid, _Tag}, State = {idle}) ->
    case Request of
        {join} ->
            Number = generate_number(),
            {reply, {ready, self()}, {playing, Number, Pid}};
        _ -> {reply, {nack, Request}, State}
    end;
%% Call handler for playing state, with a guard to only accept request if the sender is the player
handle_call(Request, {Pid, _Tag}, State = {playing, Number, Player}) when Pid == Player ->
    case Request of
        {guess, X} when X == Number -> {reply, {win}, {finished, Player}};
        {guess, _} -> Player ! {reply, {try_again}, State};
        {leave} ->
            io:format("[server] Player has left the game. Terminating...~n"),
            {stop, normal, State};
        _ -> {reply, {nack, Request}, State}
    end;
%% Call handler for finished state, with a guard to only accept request if the sender is the player
handle_call(Request, {Pid, _Tag}, State = {finished, Player}) when Pid == Player ->
    case Request of
        {restart} ->
            io:format("[server] Restarting the game with a new number.~n"),
            Number = generate_number(),
            {reply, {ready}, {playing, Number, Player}};
        {leave} ->
            io:format("[server] Player has left the game, terminating server.~n"),
            init:stop(), % force graceful exit
            {stop, normal, State};
        _ -> {reply, {nack, Request}, State}
    end;
%% Catch-all call handler for other cases
handle_call(Request, _From, State) ->
    {reply, {nack, Request}, State}.

%% No-op cast handler
handle_cast(_Msg, State) ->
    {noreply, State}.

%% Hook that gets called before termination
terminate(Reason, State) ->
    io:format("[server] Terminating due to ~w with state ~w~n", [Reason, State]).
