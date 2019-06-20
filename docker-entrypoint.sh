#!/bin/bash
set -e
SERVICES="/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMARTBoardService_elf;/usr/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/usr/bin/pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
bash /usr/sbin/nwfermi_daemon.sh
sleep 2
IFS=';'
for s in $SERVICES; do
    echo $s
    bash -c $s &
done
export LANG=es_ES.UTF-8
exec /opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf
