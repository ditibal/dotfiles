#
# ~/.bash_profile
#

if [ ! -z "$DISPLAY" ]
then
    xrdb -merge ~/.Xresources
fi

# Keyboard layouts
if [ ! -z "$DISPLAY" ]
then
    setxkbmap -layout us,ru -variant -option grp:caps_toggle
fi

# Turn off beep
xset b off
