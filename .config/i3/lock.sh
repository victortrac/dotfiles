#!/usr/bin/env bash

killall xidlehook

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer 600 \
    'brightnessctl --save; brightnessctl set 10%' \
    'brightnessctl --restore' \
  `# Undim & lock after 10 more seconds` \
  --timer 10 \
    'betterlockscreen -l -w dim -b 1' \
    'brightnessctl --restore' \
  `# turn off screen` \
  --timer 300 \
    'xset dpms force off' \
    'brightnessctl --restore' \
  &
