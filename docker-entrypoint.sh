#!/bin/bash
set -e
if [ -z "$USER" -o -z "$UID" ]; then
    echo "USER NOT DEFINED"
    exit 1
fi
if [ -z "$GROUP" -o -z "$GID" ]; then
    echo "GROUP NOT DEFINED"
    exit 1
fi
SERVICES="/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMARTBoardService_elf;/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/usr/bin/pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
rm -rf /tmp/*
bash /usr/sbin/nwfermi_daemon.sh
rm -f /var/run/dbus/pid > /dev/null 2>&1
sleep 2
IFS=';'
for s in $SERVICES; do
    echo $s
    bash -c $s &
done
export LANG=es_ES.UTF-8
addgroup --gid ${GID} ${GROUP} || true
adduser  --home /home/${USER} --shell /bin/false --gecos "UserAccount" --uid ${UID} --ingroup ${GROUP} --disabled-password --disabled-login ${USER} || true
exec su ${USER} -s /bin/bash -c '/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf'
