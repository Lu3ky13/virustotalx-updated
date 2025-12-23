#!/bin/bash

# ================= CONFIG =================
API_KEYS=(
  "API_KEY_1"
  "API_KEY_2"
)

SLEEP_SECONDS=2
ROTATE_EVERY=10
# ==========================================

fetch_domain() {
  local domain="$1"
  local key_index="$2"
  local api_key="${API_KEYS[$key_index]}"

  local URL="https://www.virustotal.com/api/v3/domains/$domain"

  echo -e "\n\033[1;34m[+] Domain:\033[0m $domain  \033[1;36m(API key $((key_index+1)))\033[0m"

  response=$(curl -s -H "x-apikey: $api_key" "$URL")

  if ! echo "$response" | jq . >/dev/null 2>&1; then
    echo -e "\033[1;31m[!] Invalid JSON\033[0m"
    return
  fi

  error=$(echo "$response" | jq -r '.error.message // empty')
  if [[ -n "$error" ]]; then
    echo -e "\033[1;33m[-] $error\033[0m"
    return
  fi

  urls=$(echo "$response" | jq -r '
    .data.attributes.last_analysis_results
    | to_entries[]
    | select(.value.category == "undetected")
    | .key
  ')

  if [[ -z "$urls" ]]; then
    echo -e "\033[1;33m[-] No undetected URLs\033[0m"
  else
    echo -e "\033[1;32m[✓] Undetected engines:\033[0m"
    echo "$urls"
  fi
}

countdown() {
  sleep "$1"
}

# ================= MAIN =================

if [[ -z "$1" ]]; then
  echo "Usage: $0 <domain | file.txt>"
  exit 1
fi

api_index=0
req_count=0

process_domain() {
  d=$(echo "$1" | sed 's|https\?://||' | tr -d '[:space:]')
  [[ -z "$d" ]] && return

  fetch_domain "$d" "$api_index"

  ((req_count++))
  if [[ $req_count -ge $ROTATE_EVERY ]]; then
    req_count=0
    api_index=$(( (api_index + 1) % ${#API_KEYS[@]} ))
  fi

  countdown "$SLEEP_SECONDS"
}

if [[ -f "$1" ]]; then
  while IFS= read -r line; do
    process_domain "$line"
  done < "$1"
else
  process_domain "$1"
fi

echo -e "\n\033[1;32m[✓] Done.\033[0m"
