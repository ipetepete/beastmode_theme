spare_modifier="ISO_Level3_Shift"
xmodmap -e "keycode 65 = $spare_modifier"
#xmodmap -e "remove mod4 = $spare_modifier"
# hyper_l is mod4 by default
#xmodmap -e "add Control = $spare_modifier"

#Next, map space to an unused keycode (to keep it around for xcape to use).

xmodmap -e "keycode any = space"

#Finally use xcape to cause the space bar to generate a space when tapped.

xcape -e "$spare_modifier=space"

