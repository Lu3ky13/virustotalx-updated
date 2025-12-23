# VirusTotalX

VirusTotalX is a lightweight Bash tool for querying VirusTotal domain reports with
improved stability, API key rotation, and null-safe JSON parsing.

It supports scanning a single domain or a list of domains from a file and is
useful for bug bounty hunting, OSINT, CTFs, and security research.

This is the original tool I have made some edits
https://github.com/orwagodfather/virustotalx
Thank you very much , orwagodfather
---

## Features

- VirusTotal v2 domain report lookup
- Multiple API key rotation
- Safe `jq` parsing (no crashes on null responses)
- Scan a single domain or a file of domains
- Clean, colored terminal output
- Rate-limit aware execution

---

## Requirements

Install required packages:

```bash
sudo apt update
sudo apt install -y curl jq
```
---

## Installation

```
git clone https://github.com/Lu3ky13/virustotalx.git
cd virustotalx
chmod +x Lu3ky13.sh
```

##  Configuration (API Keys)

```
API_KEYS=(
  "API_KEY_1"
  "API_KEY_2"
  "API_KEY_3"
)
```
You can get free API keys from: https://www.virustotal.com/

## Usage

## Scan a single domain
```
./Lu3ky13.sh example.com
```
## Scan multiple domains from a file

```
./Lu3ky13.sh domains.txt
```
## Example input file (domains.txt)
```
example.com
test.example.org
sub.domain.net
```

## Blank lines are ignored
```
http:// and https:// are stripped automatically
```
## Output Example
```
[+] Domain: example.com (API key 1)
[✓] Undetected URLs:
http://example.com/login
http://example.com/admin
```

## If no data is available:
```
[-] No data or rate-limited
```
Very slow scanning
This is expected due to VirusTotal limits.
You can safely reduce sleep time inside the script:
```
SLEEP_SECONDS=5
```

## Disclaimer

This tool is provided for educational and research purposes only.
You are fully responsible for how you use it and must comply with
VirusTotal’s Terms of Service and all applicable laws.


