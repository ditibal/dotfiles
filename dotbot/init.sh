#!/usr/bin/env bash

mkdir -p "$HOME/.local/awesome/"{calendar,habitica}

keepassxc-cli attachment-export "$HOME/Sync/keepass/keepass-passwords.kdbx" 'awesome wm' 'calendar-token.json' \
 "$HOME/.local/awesome/calendar/token.json" <<< "$PASSWORD"

keepassxc-cli attachment-export "$HOME/Sync/keepass/keepass-passwords.kdbx" 'awesome wm' 'habitica-auth.json' \
 "$HOME/.local/awesome/habitica/auth.json" <<< "$PASSWORD"
