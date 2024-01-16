from rofi import Rofi
import os
import subprocess
import awesome


def start_phpstorm(env_name):
    dir = os.getenv(env_name)
    if dir is None:
        rofi.error(f'Не указан путь {env_name}')
        return

    if not os.path.isdir(dir):
        rofi.error(f'Неверный путь {env_name}')
        return

    subprocess.Popen(['phpstorm', dir])


def switch_tag_group():
    options = awesome.get_groups()

    index, key = rofi.select('Group', options, rofi_args=['-i'])

    if index < 0 or index > len(options):
        return

    option = options[index].lower()
    awesome.set_group(option)


def run_action(actions):
    options = [action['label'] for action in actions]
    index, key = rofi.select('Run', options, rofi_args=['-i', '-markup-rows'])

    if 0 <= index < len(actions):
        obj = actions[index]
        action_func = obj['action']
        action_func()


global_actions = [
    {
        'label': 'Restart Awesome',
        'name': 'awesome_restart',
        'group': '*',
        'action': lambda: os.system("awesome-client 'awesome.restart()'"),
    },
    {
        'label': 'Выход <span size="x-small"><i>(Quit)</i></span>',
        'name': 'awesome_quit',
        'group': '*',
        'action': lambda: os.system("awesome-client 'awesome.quit()'"),
    },
    {
        'label': 'Edit hosts',
        'name': 'edit_hosts',
        'group': '*',
        'action': lambda: os.system("alacritty -e /bin/nvim /etc/hosts"),
    },
    {
        'label': 'Suspend',
        'name': 'suspend',
        'group': '*',
        'action': lambda: os.system("systemctl suspend"),
    },
    {
        'label': 'Help',
        'name': 'help',
        'group': '*',
        'action': lambda: os.system("alacritty -e frogmouth ~/dotfiles/cheatsheet.md"),
    },
    {
        'label': 'Switch tag group',
        'name': 'awesome_restart',
        'group': '*',
        'action': switch_tag_group,
    },
    {
        'label': 'PhpStorm Backend',
        'group': 'work',
        'action': lambda: start_phpstorm('CRDB_PROJECT_DIR'),
    },
    {
        'label': 'PhpStorm Frontend',
        'group': 'work',
        'action': lambda: start_phpstorm('CRDF_PROJECT_DIR'),
    },
    {
        'label': 'PhpStorm',
        'group': 'shop',
        'action': lambda: start_phpstorm('SHOP_PROJECT_DIR'),
    },
    {
        'label': 'PhpStorm Autoshina',
        'group': 'autoshina',
        'action': lambda: start_phpstorm('ATSH_PROJECT_DIR'),
    },
    {
        'label': 'PhpStorm Rembox',
        'group': 'autoshina',
        'action': lambda: start_phpstorm('RMBX_PROJECT_DIR'),
    },
]

rofi = Rofi()

group_name = awesome.get_group()

global_actions = [action for action in global_actions if action['group'] == group_name or action['group'] == '*']
global_actions.sort(key=lambda d: d['label'])

run_action(global_actions)
