#!/bin/bash

# Vuln Fuzzer - An automated tool to discover and test potential vulnerabilities on a target domain.
# This script gathers parameters and URLs from various sources, then performs scanning using Nuclei and validation with Httpx.
# Configurable options include specifying the target (-u), output file (-o), and search depth (-d).

clear
trap "echo -e '\n[!] Process interrupted. Exiting...'; exit 1" SIGINT

echo ""
echo " ▄               ▄  ▄         ▄  ▄            ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ "
echo "▐░▌             ▐░▌▐░▌       ▐░▌▐░▌          ▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
echo " ▐░▌           ▐░▌ ▐░▌       ▐░▌▐░▌          ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌"
echo "  ▐░▌         ▐░▌  ▐░▌       ▐░▌▐░▌          ▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌          ▐░▌          ▐░▌▐░▌          ▐░▌       ▐░▌"
echo "   ▐░▌       ▐░▌   ▐░▌       ▐░▌▐░▌          ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌"
echo "    ▐░▌     ▐░▌    ▐░▌       ▐░▌▐░▌          ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
echo "     ▐░▌   ▐░▌     ▐░▌       ▐░▌▐░▌          ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀ "
echo "      ▐░▌ ▐░▌      ▐░▌       ▐░▌▐░▌          ▐░▌    ▐░▌▐░▌▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌          ▐░▌     ▐░▌  "
echo "       ▐░▐░▌       ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░▐░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ "
echo "        ▐░▌        ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌"
echo "         ▀          ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀            ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀ "
echo ""
echo "                                          Automated Vulnerability Discovery Tool"
echo "                                              By: C0d3pont1ff | @C0d3pont1ff"
echo ""                                                                                                                   #Ad Maiora Natus Sum

                                                                             
# Ensure all required tools are installed
tools=(waybackurls hakrawler katana nuclei httpx)
for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo "$tool not found. Please install it first."
        exit 1
    fi
done

# Default values
target=""
output_file="output.txt"
hakrawler_depth=3
katana_depth=5

# Parse options
while getopts "u:o:d:" opt; do
    case ${opt} in
        u ) target=$OPTARG ;;
        o ) output_file=$OPTARG ;;
        d ) hakrawler_depth=$OPTARG; katana_depth=$OPTARG ;;
        * ) echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth>"; exit 1 ;;
    esac
done

# Check if the target is provided
if [ -z "$target" ]; then
    echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth>"
    exit 1
fi

#WaybackUrls
echo "[+] Running WaybackURLs..."
waybackurls "$target" > "$output_file"

#Hakrawler
echo "[+] Running Hakrawler..."
echo "$target" | hakrawler -d "$hakrawler_depth" -subs -u >> "$output_file"

#Katana
echo "[+] Running Katana..."
katana -u "$target" -jc -d "$katana_depth" >> "$output_file"

#Sort
echo "[+] Sorting..."
sort -u "$output_file" >> "$output_file"

#Nuclei
echo "[+] Running Nuclei..."
nuclei -list "$output_file" -no-mhe -dast -rl 50 -o "$nuclei_result"

echo "[+] Running Httpx for validation..."
httpx -list "$nuclei_result" -sc > $output_file

echo "[+] Process complete! Check results in $output_file"
