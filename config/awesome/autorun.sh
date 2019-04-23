#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi
# System-config-printer-applet is not installed in minimal edition
if (command -v system-config-printer-applet && ! pgrep applet.py ); then
  system-config-printer-applet &
fi

run xfsettingsd
run nm-applet
run light-locker
run compton 
run thunar --daemon
run pa-applet
run pamac-tray
# blueman-applet and msm_notifier are not installed in minimal edition
run blueman-applet
run msm_notifier

# reset wallpaper
$HOME/.fehbg


# I swap my ctl, alt keys and turn my CapsLock into another control
# I then use xcape to assign Escape to Ctrl when tapped
# This is more ergonomic IMHO
#
# clear any previous xcape settings
#killall xcape
#$HOME/scripts/space_mod.sh
#xcape -e 'Caps_Lock=Escape;Control_L=Escape'

# enable natural scrolling and tapping
#xinput set-prop 12 278 1
#xinput set-prop 12 286 1
