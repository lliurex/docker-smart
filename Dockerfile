FROM i386/ubuntu:14.04
MAINTAINER M.Angel Juan <m.angel.juan@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_X11_NO_MITSHM=1
ARG REPO=http://lliurex.net/trusty
RUN apt-get update && apt-get install wget grep python -y
#RUN wget -q -O /etc/apt/trusted.gpg.d/lliurex.gpg "https://github.com/lliurex/lliurex-keyring/raw/master/keyrings/lliurex-archive-keyring-gpg.gpg"
RUN echo deb [trusted=yes] $REPO trusty main universe multiverse > /etc/apt/sources.list.d/lliurex.list && apt-get update
RUN mkdir /usr/share/applications -p && mkdir /usr/share/desktop-directories -p
RUN apt-get install lliurex-smart adobe-flashplugin -y
RUN apt-get install dbus dbus-x11 pulseaudio gstreamer0.10 alsa-utils -y && apt-get clean
RUN install -d -m755 -o pulse -g pulse /run/pulse
RUN mkdir /var/run/dbus && chown messagebus:messagebus /var/run/dbus/
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./sw/decompressed/data/usr/sbin/nwfermi_daemon* /usr/sbin/
ENTRYPOINT [ "/docker-entrypoint.sh" ]
