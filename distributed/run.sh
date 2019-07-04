#!/usr/bin/env bash
set -e

case "$OSTYPE" in
    darwin*) IP=$(dscacheutil -q host -a name erlang.example | grep ip_address | head -n 1 | awk '{print $2}') ;;
    solaris|linux|msys|bsd*) IP=$(getent hosts erlang.example | head -n 1 | awk '{print $1}') ;;
    *) echo "Cannot retrieve IP for hostname erlang.example" && exit 1 ;;
esac

if [ "$IP" != "127.0.0.1" ]; then
    echo "The hostname erlang.example seems to point to $IP instead of 127.0.0.1"
    read -p "Are you sure you want to continue? (y/N) " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

rm -f *.beam
erl -compile foo
erl -compile bar
erl -noshell -name foo@erlang.example -s foo -s init stop & \
erl -noshell -name bar@erlang.example -s bar -s init stop
