#!/usr/bin/env bash
#Usage: IRC.sh nick "#channel"
#Use with logging: IRC.sh nick "#channel" | tee irc.log
nick="$1"
channel="$2"
server="/dev/tcp/irc.libera.chat/6667"

exec 3<>$server

echo "USER ${nick} * ${nick} ${nick}" >&3
echo "NICK ${nick}" >&3
echo "JOIN ${channel}" >&3

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
