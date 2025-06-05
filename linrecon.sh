#!/bin/bash
# Linux Recon Script.  
# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# Input check
if [ -z "$1" ]; then
    echo -e "${RED}❌ Usage: ./recon.sh <IP or Hostname>${NC}"
    exit 1
fi

# Strip http:// or https:// if present
INPUT=$(echo "$1" | sed -E 's~^(http[s]?://)~~')

# Detect if it's an IP address
if [[ "$INPUT" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    RESOLVED_IP="$INPUT"
else
    # Resolve domain name to IP
    RESOLVED_IP=$(dig +short "$INPUT" | tail -n 1)
fi

# Verify resolution
if [[ -z "$RESOLVED_IP" ]]; then
    echo -e "${RED}❌ Could not resolve IP for: $INPUT${NC}"
    exit 1
fi

OUTPUT="scan_results.txt"

echo -e "${CYAN}[*] Target: ${YELLOW}$INPUT${NC}"
echo -e "${CYAN}[*] Resolved IP: ${YELLOW}$RESOLVED_IP${NC}"
echo -e "${CYAN}[*] Output will be saved to: ${YELLOW}$OUTPUT${NC}"
echo -e "${CYAN}[*] $(timestamp) - Starting Nmap service scan...${NC}"

# Run and log Nmap output
{
    echo "=== $(timestamp) - NMAP SCAN ==="
    nmap -sV "$RESOLVED_IP"
} > "$OUTPUT"

echo -e "${GREEN}✅ $(timestamp) - Nmap scan completed.${NC}"

# Check for open port 445 (SMB)
if grep 445 "$OUTPUT" | grep -iq open; then
    echo -e "${YELLOW}[!] SMB Port 445 is open. Running enum4linux...${NC}"
    {
        echo "=== $(timestamp) - ENUM4LINUX SMB ENUMERATION ==="
        enum4linux -U -S "$RESOLVED_IP"
    } >> "$OUTPUT"
    echo -e "${GREEN}✅ $(timestamp) - SMB enumeration completed and logged.${NC}"
else
    echo -e "${CYAN}[*] $(timestamp) - Port 445 is closed or filtered. Skipping SMB enumeration.${NC}"
fi

echo -e "${YELLOW}[*] Done. To view results: ${CYAN}cat $OUTPUT${NC}"
