#!/bin/sh
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$CONFIG_DIR/plugins/icons.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set clock.1 icon="$(icon f017)" label="Local  $(date '+%H:%M:%S  %Z')"
  sketchybar --set clock.2 icon="$(icon f0ac)" label="UTC    $(TZ=UTC date '+%H:%M  %a %-d %b')"
  sketchybar --set clock.3 icon="$(icon f073)" label="Week $(date +%V) · Day $(date +%-j)"
  sketchybar --set "$NAME" popup.drawing=on
  exit 0
fi
if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi

sketchybar --set "$NAME" \
  icon="$(icon f073)" \
  label="$(date '+%a %-d %b  %H:%M')"
