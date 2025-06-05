#!/bin/bash
# Enhancements over vhost-fuzzer2.sh
# Enhancements:
# ✅ Domain resolution check before running ffuf
# ✅ Wildcard DNS detection to reduce false positives
# ✅ Automatic timestamped output logging
# ✅ Clean separation of logic with clear comments
# Function to display script usage
show_help() {
    echo "Usage: $0 <DOMAIN> <WORDLIST> <URL> <FS_FILTER>"
    echo "   -h, --help     Display this help and exit"
    echo
    echo "Description:"
    echo "  Fuzz subdomains of a target domain using ffuf with pre-checks for domain resolution,"
    echo "  wildcard DNS detection, and optional logging."
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

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Validate arguments
if [ "$#" -ne 4 ]; then
    echo "❌ Error: Incorrect number of arguments."
    show_help
    exit 1
fi

# Assign arguments
DOMAIN="$1"
WORDLIST="$2"
URL="$3"
FS_FILTER="$4"

# Check for domain resolution
echo "[*] Checking if domain $DOMAIN resolves..."
if ! dig +short "$DOMAIN" | grep -qE '^[0-9.]+'; then
    echo "❌ Domain $DOMAIN does not resolve. Check your DNS or input."
    exit 1
fi
echo "✅ Domain resolves."

# Wildcard DNS detection
echo "[*] Checking for wildcard DNS..."
RANDOM_SUB=$(head /dev/urandom | tr -dc a-z0-9 | head -c 12)
WILDCARD_CHECK=$(dig +short "$RANDOM_SUB.$DOMAIN")

if [[ -n "$WILDCARD_CHECK" ]]; then
    echo "⚠️ Wildcard DNS detected for $DOMAIN (random subdomain resolves to: $WILDCARD_CHECK)"
    echo "Results may contain false positives. Consider filtering or validating manually."
else
    echo "✅ No wildcard DNS detected."
fi

# Timestamp for output file
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_FILE="ffuf_${DOMAIN}_${TIMESTAMP}.json"

# Run ffuf with output logging
echo "[*] Running ffuf..."
ffuf -H "Host: FUZZ.$DOMAIN" \
     -H "User-Agent: PENTEST" \
     -c \
     -w "$WORDLIST" \
     -u "$URL" \
     -fs "$FS_FILTER" \
     -o "$OUTPUT_FILE" \
     -of json

# Report completion
echo "✅ ffuf completed. Results saved to $OUTPUT_FILE"
