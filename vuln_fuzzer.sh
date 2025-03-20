#!/bin/bash

# Vuln Fuzzer - An automated tool to discover and test potential vulnerabilities on a target domain.
# This script gathers parameters and URLs from various sources, then performs scanning using Nuclei and validation with Httpx.
# Configurable options include specifying the target (-u), output file (-o), and search depth (-d).

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
output_file="output.txt"
nuclei_result="result.txt"
httpx_result="result_status.txt"
hakrawler_depth=3
katana_depth=5

# Parse options
while getopts "u:o:d:" opt; do
    case ${opt} in
        u ) target=$OPTARG ;;
        o ) httpx_result=$OPTARG ;;
        d ) hakrawler_depth=$OPTARG; katana_depth=$OPTARG ;;
        * ) echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth>"; exit 1 ;;
    esac
done

# Check if the target is provided
if [ -z "$target" ]; then
    echo "Usage: $0 -u <target_domain> -o <output_file> -d <depth>"
    exit 1
fi

excluded_extensions="png,jpg,gif,jpeg,swf,woff,svg,pdf,json,css,js,webp,woff,woff2,eot,ttf,otf,mp4,txt"

echo "[+] Running ParamSpider..."
paramspider -d "$target" --exclude "$excluded_extensions" --level high --quiet -o $output_file

echo "[+] Running WaybackURLs..."
waybackurls "$target" >> $output_file

echo "[+] Running Hakrawler..."
echo "$target" | hakrawler -d "$hakrawler_depth" -subs -u >> $output_file

echo "[+] Running Katana..."
katana -u "$target" -jc -d "$katana_depth" >> $output_file

# Remove duplicates
sort -u $output_file -o $output_file

echo "[+] Running Nuclei..."
nuclei -list $output_file -dast -rl 50 -o $nuclei_result

echo "[+] Running Httpx for validation..."
httpx -list $nuclei_result -sc -o $httpx_result

echo "[+] Process complete! Check results in $httpx_result"
