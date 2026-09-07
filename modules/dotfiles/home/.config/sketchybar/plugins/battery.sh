#!/bin/zsh
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  PWR="$(system_profiler SPPowerDataType 2>/dev/null)"
  COND="$(echo "$PWR" | awk -F': ' '/Condition/{print $2; exit}')"
  CYCLES="$(echo "$PWR" | awk -F': ' '/Cycle Count/{print $2; exit}')"
  MAXCAP="$(echo "$PWR" | awk -F': ' '/Maximum Capacity/{print $2; exit}')"
  sketchybar --set battery.1 icon=$'\uf05a' label="Condition  ${COND:-—}"
  sketchybar --set battery.2 icon=$'\uf021' label="Cycles     ${CYCLES:-—}"
  sketchybar --set battery.3 icon=$'\uf0e7' label="Health     ${MAXCAP:-—}"
  sketchybar --set "$NAME" popup.drawing=on
  exit 0
fi
if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo '[0-9]+%' | cut -d% -f1)"
[ -z "$PERCENTAGE" ] && exit 0

ON_AC="$(echo "$BATT" | grep -q 'AC Power' && echo 1 || echo 0)"

# Hide when plugged in and nearly full — not actionable
if [ "$ON_AC" = 1 ] && [ "$PERCENTAGE" -ge 95 ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

case "$PERCENTAGE" in
  9[0-9]|100) ICON=$'\uf240'; COLOR=$GREEN ;;
  [6-8][0-9]) ICON=$'\uf241'; COLOR=$GREEN ;;
  [3-5][0-9]) ICON=$'\uf242'; COLOR=$YELLOW ;;
  [1-2][0-9]) ICON=$'\uf243'; COLOR=$PEACH ;;
  *)          ICON=$'\uf244'; COLOR=$RED ;;
esac

LABEL="${PERCENTAGE}%"
if [ "$ON_AC" = 1 ]; then
  LABEL="AC · ${PERCENTAGE}%"
  ICON=$'\uf0e7'
  COLOR=$GREEN
elif TIME="$(echo "$BATT" | grep -Eo '[0-9]+:[0-9]+' | head -1)" && [ -n "$TIME" ]; then
  LABEL="${PERCENTAGE}% · ${TIME} left"
fi

sketchybar --animate tanh 15 --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" drawing=on
