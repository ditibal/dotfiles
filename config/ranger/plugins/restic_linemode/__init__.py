from ranger.core import linemode
from ranger.ext.human_readable import human_readable
from .devicons import *
import ranger.api
import fnmatch
import os

SEPARATOR = os.getenv('RANGER_DEVICONS_SEPARATOR', ' ')

@ranger.api.register_linemode
class ResticLinemode(linemode.LinemodeBase):
  name = "restic"

  def __init__(self):
    self.exclude_list = []

    try:
      import yaml
      with open(os.environ.get('HOME') + "/dotfiles/config/resticprofile/comp.yaml", "r") as comp_yaml:
        data = yaml.safe_load(comp_yaml)
        self.exclude_list = data['comp']['backup']['exclude']
    except:
      pass

  def filebackuped(self, fobf):
    for path in self.exclude_list:
      if fnmatch.fnmatch(fobf.path, path):
        return False

    return True

  def filetitle(self, file, metadata):
    return devicon(file) + SEPARATOR + file.relative_path

  def infostring(self, fobj, metadata):
    emojiSymbol = "❗"

    if fobj.stat is None:
      return '?'

    if fobj.is_directory and not fobj.cumulative_size_calculated:
      if fobj.size is None:
        sizestring = ''
      else:
        sizestring = fobj.size
    else:
      sizestring = human_readable(fobj.size)

    is_backup = ' '

    if not self.filebackuped(fobj):
      is_backup = emojiSymbol

    return "%s %1s" % (sizestring, is_backup)