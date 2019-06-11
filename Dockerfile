FROM ubuntu:16.04
MAINTAINER M.Angel Juan <m.angel.juan@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_X11_NO_MITSHM=1
RUN apt-get update && apt-get install wget -y
RUN wget -q -O /etc/apt/trusted.gpg.d/lliurex.gpg "https://github.com/lliurex/lliurex-keyring/raw/master/keyrings/lliurex-archive-keyring-gpg.gpg"
RUN dpkg --add-architecture i386 && echo deb http://lliurex.net/xenial xenial main universe multiverse >> /etc/apt/sources.list.d/lliurex.list && apt-get update
RUN apt-get install grep python -y
RUN mkdir /usr/share/applications -p && mkdir /usr/share/desktop-directories -p
RUN apt-get install lliurex-smart64 -y
WORKDIR /opt/lliurex-smart/smart-product-drivers
#CMD ["bash"]
CMD [ "bash -c 'SMARTBoardService & /opt/SMART\ Technologies/SMART\ Product\ Drivers/bin/.SMART\ Board\ Tools_elf' " ]