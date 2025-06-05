#!/bin/bash
# pingsweep.sh

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for input
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <subnet-prefix> (e.g. 192.168.143)${NC}"
    exit 1
fi

SUBNET=$1
echo -e "${CYAN}[*] Scanning ${SUBNET}.0/24 ...${NC}"

# Loop over IPs 1 to 254
for i in {1..254}; do
    IP="${SUBNET}.${i}"
    (
        if ping -c 1 -W 1 "$IP" &> /dev/null; then
            echo -e "${GREEN}[+] Host up: $IP${NC}"
        fi
    ) &
done

wait
echo -e "${YELLOW}[*] Scan complete.${NC}"
