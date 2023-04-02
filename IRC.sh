#!/usr/bin/env bash

nick="$1"
room="$2"
server="/dev/tcp/irc.libera.chat/6667"

exec 3<>$server

echo "USER ${nick} * ${nick} ${nick}" >&3
echo "NICK ${nick}" >&3
echo "JOIN ${room}" >&3

function quit() {
    echo "QUIT" >&3
    exec 3<&-
    exit 1
}

trap quit SIGINT

while true; do
    read in <&3
    [[ -n "$in" ]] && echo "${in}"
    [[ "$in" = PING* ]] && printf "${in/PING/PONG}" >&3
done