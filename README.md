# Vuln Fuzzer 🛠️🔍  

**Vuln Fuzzer** is an automated vulnerability discovery tool that gathers parameters and URLs from multiple sources and scans for potential security issues.  
It integrates with **ParamSpider, WaybackURLs, Hakrawler, Katana, Nuclei, and Httpx** to streamline the reconnaissance and scanning process.  


## Credits & Dependencies  
This tool integrates the following open-source tools:  

- [ParamSpider](https://github.com/devanshbatham/ParamSpider) - Parameter extraction  
- [WaybackURLs](https://github.com/tomnomnom/waybackurls) - URL enumeration  
- [Hakrawler](https://github.com/hakluke/hakrawler) - Web crawling  
- [Katana](https://github.com/projectdiscovery/katana) - Web crawling  
- [Nuclei](https://github.com/projectdiscovery/nuclei) - Vulnerability scanning  
- [Httpx](https://github.com/projectdiscovery/httpx) - HTTP response validation  

These tools are created and maintained by their respective developers.  
Please refer to their repositories for licensing details.

---

## 🚀 Features  

✅ Collect URLs and parameters from multiple sources  
✅ Filter out unnecessary extensions  
✅ Perform active vulnerability scanning using **Nuclei**  
✅ Validate findings using **Httpx**  
✅ Adjustable depth levels for **Hakrawler** and **Katana**  
✅ Simple CLI with customizable options  

---
```text
## 🔧 Installation  

Ensure the required tools are installed before running:  
- [ParamSpider](https://github.com/devanshbatham/ParamSpider) - Parameter extraction  
- [WaybackURLs](https://github.com/tomnomnom/waybackurls) - URL enumeration  
- [Hakrawler](https://github.com/hakluke/hakrawler) - Web crawling  
- [Katana](https://github.com/projectdiscovery/katana) - Web crawling  
- [Nuclei](https://github.com/projectdiscovery/nuclei) - Vulnerability scanning  
- [Httpx](https://github.com/projectdiscovery/httpx) - HTTP response validation  
```
```sh
git clone https://github.com/CodePontiff/vuln_fuzzer
cd vuln_fuzzer
chmod +x vuln_fuzzer.sh
```

## 📌 Usage

```sh
./vuln_fuzzer.sh -u <target_domain> -o <output_file> -d <depth>
```
```text
-u → Target domain
-o → Output file for validated results
-d → Depth level for Hakrawler and Katana
```
## Example 📖

```sh
./vuln_fuzzer.sh -u example.com -o final_results.txt -d 5
```

## Contributions & Issues 💡
Feel free to submit issues or contribute by creating a pull request!
