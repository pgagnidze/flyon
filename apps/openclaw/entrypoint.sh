#!/bin/sh
set -e

export DISPLAY=:1

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

Xvfb :1 -screen 0 1024x768x24 &
XVFB_PID=$!

for i in 1 2 3 4 5; do
  [ -e /tmp/.X11-unix/X1 ] && break
  sleep 1
done

x11vnc -display :1 -nopw -shared -forever -rfbport 5900 &
X11VNC_PID=$!
sleep 1

/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
NOVNC_PID=$!

trap 'kill $XVFB_PID $X11VNC_PID $NOVNC_PID 2>/dev/null; wait' TERM INT

exec node dist/index.js gateway --bind lan --port 18789 --allow-unconfigured
