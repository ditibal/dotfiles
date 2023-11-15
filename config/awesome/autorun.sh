#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		$@ &
	fi
}

run "setxkbmap -layout us,ru -variant -option grp:caps_toggle"
run "autocutsel -s PRIMARY"
run "autocutsel -s CLIPBOARD"
