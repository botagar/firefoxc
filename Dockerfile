FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    firefox alsa-base alsa-utils pulseaudio socat ffmpeg libasound2-dev libglib2.0-dev
CMD ["/usr/bin/firefox"]