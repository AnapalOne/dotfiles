#!/bin/sh
#Derived from https://github.com/druskus20/eugh/blob/master/notification-revealer/notifications.sh, modified for playerctl.

print_notification() {
  content=$(echo "$1" | tr '\n' ' ' | sed "s/'/\`/g")
  content="(label :text '🎵 $content')"
  echo "{\"show\": $2, \"content\": \"$content\"}"
}

lastsong=
while true; do
  currentsong=\"$(playerctl metadata --ignore-player=firefox,vlc,mpv --format "{{ artist }} - {{ title }}" 2> /dev/null)\"

  print_notification "" "false"

  if [[ "$currentsong" != "$lastsong" ]] && [[ "$currentsong" != "\"\"" ]]; then
      line=$(echo $currentsong | sed 's/"//g')
      print_notification "$line" "true"
      kill "$pid" 2> /dev/null
      (sleep 8; print_notification "$line" "false") &
      pid="$!"
      line=
  fi
  lastsong=$currentsong
  
  sleep 10;
done
