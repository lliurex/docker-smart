#!/bin/bash
set -e
#set -x
USER_SUPPORT=1
if [ -z "$USER" -o -z "$UID" ]; then
    echo "USER NOT DEFINED"
    USER_SUPPORT=0
fi
if [ -z "$GROUP" -o -z "$GID" ]; then
    echo "GROUP NOT DEFINED"
    USER_SUPPORT=0
fi
SERVICES="/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/usr/bin/pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
screen -S nwfermi -d -m bash /usr/sbin/nwfermi_daemon.sh
rm -f /var/run/dbus/pid > /dev/null 2>&1
sleep 1
IFS=';'
for s in $SERVICES; do
    echo $s
    bash -c $s &
done
if [ ! $USER_SUPPORT ]; then
    addgroup --quiet --gid ${GID} ${GROUP} || true
    adduser  --quiet --home /home/${USER} --shell /bin/false --gecos "UserAccount" --uid ${UID} --ingroup ${GROUP} --disabled-password --disabled-login ${USER} || true
    if [ ! -L '/root/lliurex-smart-storage' ]; then
        ln -s /home/${USER} /root/lliurex-smart-storage || true
    fi
fi
export LANG=es_ES.UTF-8
screen -S service -d -m bash /usr/sbin/sm-service &
/opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf
if [ ! $USER_SUPPORT ];then
    chown -R $USER:$GROUP /home/${USER} || true
fi