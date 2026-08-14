#!/bin/zsh
# Highlight the focused AeroSpace workspace in SketchyBar and show its app icons.
# Args: workspace id (e.g. term)
# ponytail: updates only fire on aerospace_workspace_change, so a window closing
# on an unfocused desk leaves stale icons until the next workspace switch.
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(/run/current-system/sw/bin/aerospace list-workspaces --focused 2>/dev/null)}"

APPS="$(/run/current-system/sw/bin/aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null)"
HAS_WINDOWS=0
[ -n "$APPS" ] && HAS_WINDOWS=1

# Unique app icons (sketchybar-app-font slug syntax)
ICONS=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  case "$ICONS" in
    *"$icon_result"*) ;;
    *) ICONS+="$icon_result" ;;
  esac
done <<< "$APPS"

LABEL_FONT="$APP_FONT:Regular:13.0"
if [ "$HAS_WINDOWS" = 0 ]; then
  ICONS="·"
  LABEL_FONT="$FONT:Regular:13.0"
fi

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --animate tanh 20 --set "$NAME" \
    drawing=on \
    background.drawing=on \
    background.color=$PILL_ACTIVE \
    icon.color=$BASE \
    icon.font="$FONT:Bold:12.0" \
    label="$ICONS" \
    label.font="$LABEL_FONT" \
    label.drawing=on
else
  # Always show persistent desks (even empty) so term/misc stay clickable
  sketchybar --animate tanh 20 --set "$NAME" \
    drawing=on \
    background.drawing=on \
    background.color=$PILL_BG \
    icon.color=$TEXT \
    icon.font="$FONT:Medium:12.0" \
    label="$ICONS" \
    label.font="$LABEL_FONT" \
    label.drawing=on
fi
