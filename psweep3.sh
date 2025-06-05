#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to validate CIDR
validate_cidr() {
    local cidr=$1
    if [[ $cidr =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}\/([0-9]|[1-2][0-9]|3[0-2])$ ]]; then
        return 0
    else
        return 1
    fi
}

# Input check
if [ -z "$1" ]; then
    echo -e "${RED}❌ Usage: ./ping_sweep.sh <CIDR>${NC}"
    exit 1
fi

CIDR="$1"
BASENAME="sweep_$(date +%Y%m%d-%H%M%S)"

# Validate CIDR
if validate_cidr "$CIDR"; then
    echo -e "${GREEN}✅ Valid CIDR: $CIDR${NC}"
else
    echo -e "${RED}❌ Invalid CIDR format. Expected format: xxx.xxx.xxx.xxx/xx${NC}"
    exit 1
fi

echo -e "${CYAN}[*] Starting nmap ping sweep on $CIDR...${NC}"

# Run nmap and output in all formats
nmap -n -sn "$CIDR" -oA "$BASENAME" > /dev/null

# Filter live hosts from grepable output
grep "Up" "${BASENAME}.gnmap" | awk '{print $2}' > live_hosts.txt

# Display results
if [ -s live_hosts.txt ]; then
    echo -e "${GREEN}✅ Live hosts found:${NC}"
    cat live_hosts.txt
else
    echo -e "${YELLOW}⚠️ No live hosts found.${NC}"
fi

# Summary
echo -e "${YELLOW}[*] Reports generated:${NC}"
echo -e "  ${CYAN}- Raw:      ${BASENAME}.nmap${NC}"
echo -e "  ${CYAN}- Grepable: ${BASENAME}.gnmap${NC}"
echo -e "  ${CYAN}- XML:      ${BASENAME}.xml${NC}"
echo -e "  ${CYAN}- IPs Only: live_hosts.txt${NC}"
