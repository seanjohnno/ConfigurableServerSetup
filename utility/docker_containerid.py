import fileinput
import re

for line in fileinput.input():
    match = re.search('(\w+)\s+', line)
    print(match.group(1))