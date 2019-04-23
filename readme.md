# Beastmode Theme for AwesomeWM

### Dependancies
- [compton with blur](https://github.com/tryone144/compton)
- pywal
- feh
- imagemagick (for generating colored icons)

### Setting up

Copy the configs to their respective locations. Then edit `~/.config/awesome/autorun.sh` to suit your system.

For example I use `light-locker` to lock my screenånd I also have a couple of locker scripts in the `/scripts` directory to help with that. 

Also take a look at `.config/awesome/thangs/keys.lua` and adjust your keybindings to suit your needs.

I suggest using Xephyr to test the config/settings:(Ctl+Shift to capture keyboard/mouse)

`Xephyr -screen 1440x990 :5 & sleep 1; DISPLAY=:5 awesome`

### Setting/changing theme

Run the script `/scripts/setbg.sh` with the full path to your image....

`~/scripts/setbg.sh ~/Pictures/Wallpaper/BeastMode.jpg` - for example

The script will create a pywal scheme, set the wallpaper and tweak the color of the icons in `.config/awesome/themes`

Restart Awesome to see the changes to the icons (default keymap is Mod+Ctl+r)

Sometimes the colors will not have enough contrast, adjust `.config/rofi` and `.config/awesome/rc.lua` to adjust.


## Enjoy!

Included is a colors.html file which loads the wal colors.css file. This is good for reference as it displays the colors, color-name and it's hex value. Just remember to _change the path_ in the `link` tag to your home directory

