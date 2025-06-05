#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Input validation
if [ -z "$1" ]; then
    echo -e "${RED}❌ Usage: $0 <target>${NC}"
    exit 1
fi

target="$1"
echo -e "${CYAN}[*] Starting full TCP port scan on ${target}...${NC}"

# Fast scan for open ports
ports=$(nmap -p- --min-rate 1000 "$target" | grep "^ *[0-9]" | grep "open" | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

if [ -z "$ports" ]; then
    echo -e "${YELLOW}⚠️  No open ports found.${NC}"
    exit 0
fi

echo -e "${GREEN}✅ Open ports found: ${YELLOW}$ports${NC}"
echo -e "${CYAN}[*] Running detailed scan on open ports...${NC}"

# Full service version & script scan
nmap -p "$ports" -sC -sV -A "$target" | tee port-enum.txt

echo -e "${GREEN}✅ Detailed scan complete. Results saved to ${CYAN}port-enum.txt${NC}"
