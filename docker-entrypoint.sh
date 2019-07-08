#!/bin/bash
set -e
set -x
if [ -z "$USER" -o -z "$UID" ]; then
    echo "USER NOT DEFINED"
    exit 1
fi
if [ -z "$GROUP" -o -z "$GID" ]; then
    echo "GROUP NOT DEFINED"
    exit 1
fi
SERVICES="/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/usr/bin/pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
#rm -rf /tmp/*
bash /usr/sbin/nwfermi_daemon.sh
rm -f /var/run/dbus/pid > /dev/null 2>&1
sleep 2

IFS=';'
for s in $SERVICES; do
    echo $s
    bash -c $s &
done
addgroup --quiet --gid ${GID} ${GROUP} || true
adduser  --quiet --home /home/${USER} --shell /bin/false --gecos "UserAccount" --uid ${UID} --ingroup ${GROUP} --disabled-password --disabled-login ${USER} || true
adduser --quiet lliurex video
if [ ! -L '/root/lliurex-smart-storage' ]; then
    ln -s /home/${USER} /root/lliurex-smart-storage || true
fi
export LANG=es_ES.UTF-8
/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMARTBoardService_elf &
/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf
chown -R $USER:$GROUP /home/${USER} || true

# Config has root perms
#chown -R $USER:$GROUP /root || true
