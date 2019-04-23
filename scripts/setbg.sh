#!/usr/bin/bash

wal -i $@ --backend colorz --saturate 0.8
feh --bg-fill $@
magick convert $@ /usr/share/backgrounds/custom.jpg

echo "$@" > ~/.cache/wallpaper.txt
newcolor=$(cat ~/.cache/wal/colors.Xresources | grep "\*.color14" | cut -d " " -f 2)


# To change color of an image i.e. the awesomewm icons etc
# color14 is a nice contrast to everything else
# convert $name -fill '#hexcolor' -colorize 100% $name
for i in $(find ~/.config/awesome/themes/ -name "*.png"); do
  convert $i -fill "$newcolor" -colorize 100% $i
done

