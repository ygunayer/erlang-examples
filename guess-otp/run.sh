#!/usr/bin/env sh
mkdir -p ebin
rm -f ebin/*.beam
erlc -W0 +debug_info -o ebin/ src/*.erl
erl -pa ebin -noshell -eval 'application:start(guess_otp)'