#!/bin/sh
set -e

export DISPLAY=:1

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

Xvfb :1 -screen 0 1024x768x24 &

timeout=10
while [ $timeout -gt 0 ]; do
  [ -e /tmp/.X11-unix/X1 ] && break
  sleep 1
  timeout=$((timeout - 1))
done

if [ $timeout -eq 0 ]; then
  echo "Xvfb failed to start" >&2
  exit 1
fi

x11vnc -display :1 -nopw -shared -forever -rfbport 5900 &
sleep 1

/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

trap 'kill $(jobs -p) 2>/dev/null; wait' TERM INT

exec node dist/index.js gateway --bind lan --port 18789 --allow-unconfigured
