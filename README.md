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
