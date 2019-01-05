import fileinput
import re

for line in fileinput.input():
    match = re.search('\S+\s+\S+\s+(\w+)', line)
    print(match.group(1))