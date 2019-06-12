FROM ubuntu:16.04
MAINTAINER M.Angel Juan <m.angel.juan@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_X11_NO_MITSHM=1
ARG REPO=http://lliurex.net/xenial
RUN apt-get update && apt-get install wget grep python -y
RUN wget -q -O /etc/apt/trusted.gpg.d/lliurex.gpg "https://github.com/lliurex/lliurex-keyring/raw/master/keyrings/lliurex-archive-keyring-gpg.gpg"
RUN dpkg --add-architecture i386 && echo deb $REPO xenial main universe multiverse >> /etc/apt/sources.list.d/lliurex.list && apt-get update
RUN mkdir /usr/share/applications -p && mkdir /usr/share/desktop-directories -p
RUN apt-get install lliurex-smart64 -y && apt-get clean
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /opt/lliurex-smart/smart-product-drivers
ENTRYPOINT [ "/docker-entrypoint.sh" ]
