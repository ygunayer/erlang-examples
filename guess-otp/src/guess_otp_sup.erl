-module(guess_otp_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-define(SUPERVISOR_NAME, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SUPERVISOR_NAME}, ?MODULE, {}).

init(_Args) ->
    io:format("[supervisor] Booting up...~n"),

    % fail altogether if either the client or the server gets restarted
    % see http://erlang.org/doc/design_principles/sup_princ.html#supervisor-flags for more info
    SupFlags = #{strategy => one_for_all, intensity => 0},

    % start server and client respectively, and don't attempt to restart them when they shut down gracefully
    % see http://erlang.org/doc/design_principles/sup_princ.html#child-specification for more info
    ChildSpecs = [
        #{id => server, start => {guess_otp_server, start_link, []}, restart => transient},
        #{id => worker, start => {guess_otp_client, start_link, []}, restart => transient}
    ],

    {ok, {SupFlags, ChildSpecs}}.
