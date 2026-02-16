#!/usr/bin/env bash

set -euo pipefail

DISPLAY=:1
export DISPLAY

PIDS=()

setup_colors() {
    if [[ -n "${FORCE_COLOR:-}" ]]; then
        USE_COLOR=true
    elif [[ -n "${NO_COLOR:-}" ]]; then
        USE_COLOR=false
    elif [[ -t 1 ]]; then
        USE_COLOR=true
    else
        USE_COLOR=false
    fi

    if [[ "$USE_COLOR" == true ]]; then
        red=$'\e[31m'
        green=$'\e[32m'
        blue=$'\e[34m'
        reset=$'\e[0m'
    else
        red='' green='' blue='' reset=''
    fi
}

log() {
    local level=$1
    shift
    local color
    case "$level" in
        info) color="$blue" ;;
        success) color="$green" ;;
        error) color="$red" ;;
        *) color="" ;;
    esac
    if [[ "$level" == "error" ]]; then
        echo "${color}[${level}]${reset} $*" >&2
    else
        echo "${color}[${level}]${reset} $*"
    fi
}

cleanup() {
    for pid in "${PIDS[@]}"; do
        kill "$pid" 2>/dev/null || true
    done
    wait
}

wait_for_display() {
    for _ in 1 2 3 4 5; do
        [[ -e /tmp/.X11-unix/X1 ]] && return 0
        sleep 1
    done
    log error "Xvfb display socket never appeared"
    return 1
}

start_xvfb() {
    log info "Starting Xvfb on $DISPLAY"
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
    Xvfb :1 -screen 0 1024x768x24 -ac &
    PIDS+=($!)
    wait_for_display
    log success "Xvfb ready"
}

start_vnc() {
    log info "Starting x11vnc"
    x11vnc -display :1 -nopw -shared -forever -rfbport 5900 &
    PIDS+=($!)
    sleep 1

    log info "Starting noVNC proxy"
    /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
    PIDS+=($!)
    log success "VNC stack ready on port 6080"
}

main() {
    setup_colors
    trap cleanup TERM INT

    start_xvfb
    start_vnc

    log info "Starting OpenClaw gateway"
    exec node dist/index.js gateway --bind lan --port 18789 --allow-unconfigured
}

main "$@"
