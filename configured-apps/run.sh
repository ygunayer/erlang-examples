#!/usr/bin/env sh
set -e

ENV="$1"

if [ -z "$ENV" ]; then
    echo "Please specify an environment name"
    exit 1
fi

if [ ! -f "config/$ENV/sys.config" ]; then
    echo "File 'config/$ENV/sys.config' does not exist. Make sure the environment name is valid"
    exit 1
fi

mkdir -p ebin
rm -f ebin/*.beam
erlc -W0 +debug_info -o ebin/ src/*.erl
erl -pa ebin -config "config/$ENV/sys.config" -noshell -eval 'application:start(foo)'