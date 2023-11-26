#!/bin/python

from rofi import Rofi
import os

def awesome_restart():
    os.system("awesome-client 'awesome.restart()'")


def awesome_quit():
    os.system("awesome-client 'awesome.quit()'")


def edit_hosts():
    os.system("alacritty -e /bin/nvim /etc/hosts")

def help():
    os.system("alacritty -e frogmouth ~/dotfiles/cheatsheet.md")


def suspend():
    os.system("systemctl suspend")

actions = [
    {
        'label': 'Restart Awesome',
        'name': 'awesome_restart',
        'action': awesome_restart,
    },
    {
        'label': 'Quit',
        'name': 'awesome_quit',
        'action': awesome_quit,
    },
    {
        'label': 'Edit hosts',
        'name': 'edit_hosts',
        'action': edit_hosts,
    },
    {
        'label': 'Suspend',
        'name': 'suspend',
        'action': suspend,
    },
    {
        'label': 'Help',
        'name': 'help',
        'action': help,
    },
]


def run_action(index):
    if index >= 0 and index < len(actions):
        obj = actions[index]
        action_func = obj['action']
        action_func()


def show():
    r = Rofi()
    options = [action['label'] for action in actions]
    index, key = r.select('Run', options, rofi_args=['-i'])
    run_action(index)

show()