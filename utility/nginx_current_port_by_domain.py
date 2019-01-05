import re
import sys

configLocation = sys.argv[1]
domain = sys.argv[2]

def currentPort(): 
    with open(configLocation) as nginxConf:
        for line in nginxConf.readlines():
            if ("proxy_pass" in line) and (domain in line): 
                match = re.search(':(\d+);', line)
                return match.group(1)
    return "unknown"
                
if __name__ == "__main__":
    print(currentPort())