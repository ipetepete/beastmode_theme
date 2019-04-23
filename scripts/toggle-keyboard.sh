#!/bin/bash
DISPLAY=":0"
HOME=/home/peter
XAUTH=$HOME/.Xauthority

export DISPLAY HOME XAUTH

if [ ! -f $HOME/.keyboardid ]; then
  xinput list --id-only 'AT Translated Set 2 keyboard' > $HOME/.keyboardid
fi

KEYBOARDID=$(cat $HOME/.keyboardid)


while getopts "ed" flag; do
case $flag in
    e)
        # enable keyboard
        enabled=1
        ;;
    d)
        # disable keyboard
        enabled=0
        ;;
esac
done

 
 if [[ enabled -eq 0 ]]; then
     /usr/bin/xinput float $KEYBOARDID
 else
     /usr/bin/xinput reattach $KEYBOARDID 3
     rm $HOME/.keyboardid
 fi





