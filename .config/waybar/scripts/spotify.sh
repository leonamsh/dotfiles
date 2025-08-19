#!/usr/bin/env bash
# Requer: playerctl
artist=$(playerctl -p spotify metadata artist 2>/dev/null)
title=$(playerctl -p spotify metadata title 2>/dev/null)
status=$(playerctl -p spotify status 2>/dev/null)

if [[ -z "$status" ]]; then
  echo '{"text":"  --","class":"stopped"}'
  exit 0
fi

icon=""
[[ "$status" == "Playing" ]] && icon="" || icon=""

text="$icon ${artist:-Spotify} - ${title:--}"
echo "{\"text\":\"$text\",\"class\":\"${status,,}\"}"
