#!/bin/bash
# original source from Tyler Ramsbey | https://github.com/TeneBrae93/offensivesecurity/blob/main/vhost-fuzzer.sh
# Function to display script usage
show_help() {
    echo "Usage: $0 <DOMAIN> <WORDLIST> <URL> <FS_FILTER>"
    echo "   -h, --help     Display this help and exit"
    echo
    echo "Description:"
    echo "  Fuzz subdomains of a target domain using ffuf."
    echo "  This script simplifies the ffuf command syntax for users."
    echo
    echo "Arguments:"
    echo "  DOMAIN         Target domain (e.g., example.com)"
    echo "  WORDLIST       File containing subdomain guesses"
    echo "  URL            Base URL to fuzz (e.g., http://example.com)"
    echo "  FS_FILTER      File size filter (e.g., 1234)"
    echo
    echo "Example:"
    echo "  $0 example.com subdomains.txt http://example.com 1234"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Validate arguments
if [ "$#" -ne 4 ]; then
    echo "Error: Incorrect number of arguments."
    show_help
    exit 1
fi

# Assign arguments to variables
DOMAIN="$1"
WORDLIST="$2"
URL="$3"
FS_FILTER="$4"

# Run ffuf with specified parameters
ffuf -H "Host: FUZZ.$DOMAIN" \
     -H "User-Agent: PENTEST" \
     -c \
     -w "$WORDLIST" \
     -u "$URL" \
     -fs "$FS
