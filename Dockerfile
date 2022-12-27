FROM debian:11
RUN apt-get update && apt-get install -y
RUN apt-get install -y \
    libdbus-glib-1-2 libgtk-3-0 \
    wget bzip2 unzip \
    dbus-x11 alsa-utils \
    pulseaudio pulseaudio-utils \
    libavcodec-extra
RUN adduser root pulse-access
RUN wget -O firefoxsetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
RUN tar -xf firefoxsetup.tar.bz2 --directory /opt
RUN mkdir /opt/firefox/browser/extensions
RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
RUN apt-get install -y fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core
COPY launch-firefoxc.sh ./
RUN wget https://github.com/mi-g/vdhcoapp/releases/download/v1.6.3/net.downloadhelper.coapp-1.6.3-1_amd64.tar.gz -O /tmp/vdhcoapp_1_6_3.tar.gz
RUN tar xf /tmp/vdhcoapp_1_6_3.tar.gz -C /root/
RUN /root/net.downloadhelper.coapp-1.6.3/bin/net.downloadhelper.coapp-linux-64 install --system
CMD ["/launch-firefoxc.sh"]