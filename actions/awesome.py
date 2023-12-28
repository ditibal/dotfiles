import subprocess
import re


def run_awesome_command(cmd):
    return subprocess.check_output(['awesome-client', cmd]).decode('utf-8').strip()


def get_groups():
    return [
        'Default',
        'Work',
        'Autoshina',
        'Shop',
    ]


def set_group(group_name):
    run_awesome_command("require('lib.awful.tag').set_group('" + group_name + "')")


def get_group():
    output = run_awesome_command("return require('lib.awful.tag').get_group()")
    result = re.search(r"string \"(\w+)\"", output)
    return result.group(1)
