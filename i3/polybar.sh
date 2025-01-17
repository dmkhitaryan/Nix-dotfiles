#!/usr/bin/env bash
pkill polybar
while pgrep -x polybar >/dev/null; do sleep 1; done
polybar top -c $HOME/dotfiles/i3/config.ini &