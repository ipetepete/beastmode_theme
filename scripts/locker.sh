#!/bin/sh

xautolock -detectsleep -time 5 -locker "$HOME/scripts/lock_screen.sh" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'"
