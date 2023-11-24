from rofi import Rofi
import os

def awesome_restart():
    os.system("awesome-client 'awesome.restart()'")


def awesome_quit():
    os.system("awesome-client 'awesome.quit()'")


actions = [
    {
        'label': 'Restart Awesome',
        'action': awesome_restart,
    },
    {
        'label': 'Quit',
        'action': awesome_quit,
    }
]


def run_action(index):
    if index >= 0 and index < len(actions):
        obj = actions[index]
        action_func = obj['action']
        action_func()
    else:
        print("Недопустимый индекс!")


def show():
    r = Rofi()
    options = [action['label'] for action in actions]
    index, key = r.select('Run', options)
    run_action(index)

show()