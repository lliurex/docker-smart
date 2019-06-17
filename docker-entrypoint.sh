#!/bin/bash
set -e
SERVICES="SMARTBoardService;dbus-uuidgen --ensure;dbus-daemon --system --fork;pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
IFS=';'
for s in $SERVICES; do
    echo $s
    bash -c "$s" &
done
export LANG=es_ES.UTF-8
exec /opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf
