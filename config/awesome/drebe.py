import re
import os
import sys

path = os.path.dirname(sys.argv[0])

f = open(path + "/drebe.sh", "r")
cmd = f.read()
f.close()

stream = os.popen(cmd)
out = stream.read()

out = out.replace("\n", "")
out = out.replace("\t", "")

pattern = r'<div.*><span.*>Итого<\/span>.*<div\s+class=\"sum\"><div\s+class=\"s\">(.*?)<span.*?>(.*?)</span><\/div>'

result = re.search(pattern, out, re.UNICODE)

amount = result.group(1).replace('&nbsp;', ' ')
amount += result.group(2)
amount += ' Р'

print(amount)
