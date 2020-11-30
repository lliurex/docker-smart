#!/bin/bash
# Funcionamiento que se ha observado sobre ".SMARTBoardService_elf" en MAX9.
# - Para que funcione correctamente hay que ejecutarlo en la sesión de usuario
#   y necesita que la variable DISPLAY esté definida. Se encarga de actualiar
#   el estado del icono de la barra de tareas creado por "SMART Board Tool".
# - Al ejecutarlo llama erroneamente al programa "nwfermi_daemon", por ejemplo:
#   "nwfermi_daemon /instanceid2". El error es que no deja un espacio entre el
#   parámetro "/instancdid" y el número "2" en este ejemplo.
#   La llamada correcta sería: "nwfermi_daemon /instanceid 2"
# - Si se desconecta la pizarra no se entera del cambio y el icono sigue
#   indicando que la pizarra está conectada.
# - Si se conecta la pizarra tampoco reconoce la nueva instacia de
#   "nwfermi_daemon" por lo que la pizarra sigue sin funcionar.
# - Si se elimina el proceso entonces el icono se entera de que la pizarra
#   no está conectaday aunque realmente lo que detecta es que el servicio
#   no está activo por lo que ninguna pizarra puede ser detectada e igualmente
#   se pone el icono con el aspa roja.
# - El programa ".SMARTBoardService_elf" no ejecuta "nwfermi_daemon" si detecta
#   que ya está en ejecución, por lo que ejecutandolo despues de "nwfermi_daemon"
#   con los parámetros correstos sí funciona.

#   Teniendo en cuenta este funcionamiento este script lanza el proceso nwfermi_daemon
# y después elimina el proceso ".SMARTBoardService_elf" que se ejecuta como un
# servicio de systemd en el espacio de usuario /usr/lib/systemd/user/smartboar.service
# el cual se encarga de volver ejecutarlo. De esta manera cada vez que se conecte
# la pizarra se resetea ".SMARTBoardService_elf".

# Se elimina la instancia que haya de "nwfermi_daemon" por si en algún caso
# se ha podido ejecutar por ".SMARTBoardService_elf" u otro caso.
##killall nwfermi_daemon
# Se muestran los parámetros que le pasa el servicio nwfermi.service aunque
# realmente no se usan en este script, finalmente la instancia se averigua
# por el nombre del dispositivo /dev/nwfermi? pero también valdría utilizar
# la que se pasa por parámetro.
# echo "$(date) Parametros de entrada: $@" >> /tmp/nwfermi_daemon.sh.log
# Se guarda el número que sirve como "instanceid"

DEBUG_FILE=/tmp/nwfermi_daemon.sh.log
:> $DEBUG_FILE
exit_now=0
exitting(){
    echo "---- exit signal for nwfermi_daemon.sh ----" >> $DEBUG_FILE
    pkill -9 nwfermi_daemon
    exit_now=1
}
trap exitting SIGINT
trap exitting SIGTERM
trap exitting SIGQUIT

while [ $exit_now -ne 1 ];do 
    IID=$(ls -1 /dev/nwfermi* 2>/dev/null| head -n 1 | sed "s,/dev/nwfermi,,")
    if [ -z "$IID" ];then
        echo -n "." >> /tmp/nwfermi_daemon.sh.log
    fi
    if [ ! -z "$IID" -a -z "$(pgrep -x nwfermi_daemon)" ] ; then
        echo Executing nwfermi_daemon /instanceid $IID >> $DEBUG_FILE
        echo "---- startlog nwfermi_daemon output ----" >> $DEBUG_FILE
        nwfermi_daemon /daemon /instanceid $IID > $DEBUG_FILE 2>&1 
        echo "---- endlog nwfermi_daemon output ----" >> $DEBUG_FILE
        sleep 2
        # Se elimina la instancia de ".SMARTBoardService_elf" pero el servicio
        # /usr/lib/systemd/user/smartboar.service la vuelve a cargar, así se
        # sincroniza con la nueva ejecución de nwfermi_daemon.
        pkill -9 -f .SMARTBoardService_elf
    fi
    sleep 10
done;
exit 0
