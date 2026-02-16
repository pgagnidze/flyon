#!/bin/sh
set -e

export DISPLAY=:1

Xvfb :1 -screen 0 1024x768x24 &
sleep 1

x11vnc -display :1 -nopw -shared -forever -rfbport 5900 &

/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

exec node dist/index.js gateway --bind lan --port 18789 --allow-unconfigured
