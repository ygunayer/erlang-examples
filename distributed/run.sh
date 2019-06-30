#!/usr/bin/env bash

IP=$(getent hosts erlang.example | head -n 1 | awk '{print $1}')

if [ "$IP" != "127.0.0.1" ]; then
    echo "The hostname erlang.example seems to point to $IP instead of 127.0.0.1"
    read -p "Are you sure you want to continue? (y/N) " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        rm *.beam
        erl -compile foo
        erl -compile bar
        erl -noshell -name foo@erlang.example -s foo -s init stop & \
        erl -noshell -name bar@erlang.example -s bar -s init stop
    fi
fi