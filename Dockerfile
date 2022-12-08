FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    firefox 
RUN apt-get install -y \
    dbus-x11 alsa-base alsa-utils \
    pulseaudio pulseaudio-utils \
    libavcodec-extra
RUN adduser root pulse-access
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    language-pack-ja japan* \
    language-pack-zh* chinese* \
    language-pack-ko korean* \
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core
COPY launch-firefoxc.sh .
CMD ["/launch-firefoxc.sh"]