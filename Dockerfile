FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    firefox 
RUN apt-get install -y \
    dbus-x11 alsa-base alsa-utils \
    pulseaudio pulseaudio-utils
RUN adduser root pulse-access
COPY launch-firefoxc.sh .
CMD ["/launch-firefoxc.sh"]