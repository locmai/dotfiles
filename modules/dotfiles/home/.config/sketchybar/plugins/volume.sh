#!/bin/zsh
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$CONFIG_DIR/colors.sh"

VOLUME="$INFO"
if [ -z "$VOLUME" ]; then
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
[ -z "$VOLUME" ] && exit 0

case "$VOLUME" in
  [5-9][0-9]|100)    ICON=$'\uf028'; COLOR=$TEXT ;;
  [1-9]|[1-4][0-9])  ICON=$'\uf027'; COLOR=$SUBTEXT ;;
  *)                 ICON=$'\uf026'; COLOR=$OVERLAY ;;
esac

sketchybar --animate tanh 15 --set "$NAME" icon="$ICON" icon.color=$COLOR label="vol ${VOLUME}%"
