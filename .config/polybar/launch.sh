#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

monitors="$(polybar --list-monitors)"
echo "${monitors}" | while read -r m; do
    if echo "$m" | grep -q "primary"; then
        MONITOR=$(echo "$m" | cut -d":" -f1) polybar --reload primary &
    else
        MONITOR=$(echo "$m" | cut -d":" -f1) polybar --reload secondary &
    fi
done

## Launch Polybar, using default config location ~/.config/polybar/config
#polybar bar1 2>/tmp/polybar.log &

# Fix background image
~/.fehbg

echo "Polybar launched..."
