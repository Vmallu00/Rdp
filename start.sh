#!/bin/bash
set -e

mkdir -p /run/dbus
dbus-daemon --system

mkdir -p /run/pulse
pulseaudio --system --disallow-exit --disable-shm --daemonize

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

/usr/sbin/xrdp-sesman
exec /usr/sbin/xrdp --nodaemon
