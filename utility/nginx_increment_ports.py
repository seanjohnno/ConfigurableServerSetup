import re
import fileinput

minimumPort = 4000 
maximumPort = 5000

lineArr = []

def highestPort():
    curHighestPort = minimumPort - 1

    for line in lineArr:
        match = re.search('proxy_pass\s+http://.*:(\d+);', line)
        if match is not None:
            port = int(match.group(1))
            if port > curHighestPort:
                curHighestPort = port

    return modifyToBeWithinRange(curHighestPort)

def modifyToBeWithinRange(port):
    if port > maximumPort:
        port = minimumPort
    return int(port)

def printLinesWithStartingPort(port):
    for line in lineArr:
        match = re.search('(\s*proxy_pass\s+http://.*:)\d+(;.*)', line)
        if match is None:
            print(line)
        else:
            print(match.group(1) + str(port) + match.group(2))
            port = modifyToBeWithinRange(port + 1)

if __name__ == "__main__":
    for line in fileinput.input():
        lineArr.append(line)

    intHighestPort = highestPort()
    nextPort = modifyToBeWithinRange(intHighestPort + 1)
    printLinesWithStartingPort(nextPort)