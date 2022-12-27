#!/bin/bash

# Get dbus running
service dbus restart
export $(dbus-launch)

# Ensure packages are up to date
apt update
apt upgrade -y

# Clean out any existing Pulse Audio config
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse

# Setup Pulse Audio
umask 007
pulseaudio -D --system --disallow-exit -vvv

# Check for ALSA
echo "ALSA Devices"
aplay -l

# Check for Pulse Audio
echo "PulseAudio Info"
pactl info

mkdir -p /opt/firefox/distribution/extensions
cp /root/.mozilla/extensions/*.xpi /opt/firefox/distribution/extensions

echo "Starting FireFox"
/opt/firefox/firefox
