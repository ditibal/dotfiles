#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		$@ &
	fi
}

run "setxkbmap -layout us,ru -variant -option grp:caps_toggle"

if [ "$HOSTNAME" = "laptop" ]; then
    run "xfce4-power-manager --daemon"
fi

if [ "$HOSTNAME" = "comp" ]; then
    run "xset dpms 0 0 0"
fi
