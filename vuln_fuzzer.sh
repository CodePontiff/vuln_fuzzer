#!/bin/bash

# Vuln Fuzzer - An automated tool to discover and test potential vulnerabilities on a target domain.
# This script gathers parameters and URLs from various sources, then performs scanning using Nuclei and validation with Httpx.
# Configurable options include specifying the target (-u), output file (-o), search depth (-d), specific tools (-c or -A for all), and list of targets (-l).

# Banner
clear
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
echo "            Automated Vulnerability Discovery Tool"
echo "                 By: C0d3p0nt1f | @C0d3p0nt1f"
echo ""
#Ad Maiorem Dei Gloriam


# Ensure all required tools are installed
tools=(paramspider waybackurls hakrawler katana nuclei httpx)
for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo "$tool not found. Please install it first."
        exit 1
    fi
done

# Default values
target=""
target_list=""
output_file="output.txt"
nuclei_result="result.txt"
httpx_result="result_status.txt"
hakrawler_depth=3
katana_depth=5
selected_tools=()

# Parse options
while getopts "u:o:d:c:Al:" opt; do
    case ${opt} in
        u ) target=$OPTARG ;;
        o ) httpx_result=$OPTARG ;;
        d ) hakrawler_depth=$OPTARG; katana_depth=$OPTARG ;;
        c ) IFS=',' read -r -a selected_tools <<< "$OPTARG" ;;
        A ) selected_tools=(paramspider waybackurls hakrawler katana assetfinder) ;;
        l ) target_list=$OPTARG ;;
        * ) echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth> -c <tools> -A -l <target_list>"; exit 1 ;;
    esac
done

if [ -z "$target" ] && [ -z "$target_list" ]; then
    echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth> -c <tools> -A -l <target_list>"
    exit 1
fi

# Process single target
if [ -n "$target" ]; then
    targets=($target)
fi

# Process multiple targets
if [ -n "$target_list" ]; then
    mapfile -t targets < "$target_list"
fi

for t in "${targets[@]}"; do
    for tool in "${selected_tools[@]}"; do
        case $tool in
            assetfinder ) assetfinder --subs-only "$t" >> $output_file ;;
            paramspider ) paramspider -d "$t" -o $output_file --exclude "png,jpg,gif" --level high --quiet ;;
            waybackurls ) waybackurls "$t" >> $output_file ;;
            hakrawler ) echo "$t" | hakrawler -d "$hakrawler_depth" -subs -u >> $output_file ;;
            katana ) katana -u "$t" -jc -d "$katana_depth" >> $output_file ;;
        esac
    done

done

sort -u $output_file -o $output_file

nuclei -list $output_file -dast -rl 50 -o $nuclei_result
httpx -list $nuclei_result -sc -o $httpx_result
echo "[+] Process complete! Check results in $httpx_result"
