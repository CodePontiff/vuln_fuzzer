# Vuln Fuzzer 🛠️🔍  

**Vuln Fuzzer** is an automated vulnerability discovery tool that gathers parameters and URLs from multiple sources and scans for potential security issues.  
It integrates with **ParamSpider, WaybackURLs, Hakrawler, Katana, Nuclei, and Httpx** to streamline the reconnaissance and scanning process.  

---

## 🚀 Features  

✅ Collect URLs and parameters from multiple sources  
✅ Filter out unnecessary extensions  
✅ Perform active vulnerability scanning using **Nuclei**  
✅ Validate findings using **Httpx**  
✅ Adjustable depth levels for **Hakrawler** and **Katana**  
✅ Simple CLI with customizable options  

---

## 🔧 Installation  

Ensure the required tools are installed before running:  

```sh
git clone https://github.com/CodePontiff/vuln_fuzzer
cd vuln_fuzzer
chmod +x vuln_fuzzer.sh
```

## 📌 Usage

```sh
./vuln_fuzzer.sh -u <target_domain> -o <output_file> -d <depth>
```
##-u → Target domain
##-o → Output file for validated results
##-d → Depth level for Hakrawler and Katana

## Example 📖

```sh
./vuln_fuzzer.sh -u example.com -o final_results.txt -d 5
```

## Contributions & Issues 💡
Feel free to submit issues or contribute by creating a pull request!
