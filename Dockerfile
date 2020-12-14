FROM lliurex/lliurex-smart:1.2
MAINTAINER M.Angel Juan <m.angel.juan@gmail.com>
RUN rm /usr/sbin/nwfermi_daemon* && rm '/etc/xdg/SMART Technologies Drivers.conf'
COPY nwfermi-daemon_0.6.5.1-0+lliurex5_i386.deb /
RUN dpkg -i /nwfermi-daemon_0.6.5.1-0+lliurex5_i386.deb && rm /nwfermi-daemon_0.6.5.1-0+lliurex5_i386.deb
RUN apt install -y firefox && apt purge -y adobe-flashplugin adobe-flash-properties-gtk && apt-get clean
COPY sm-service /usr/sbin/sm-service
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
