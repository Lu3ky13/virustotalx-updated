#!/bin/bash

# ================= CONFIG =================
API_KEYS=(
  "62d65005eb"
  "hdfg434534"
  "hrhrh455665"
)

SLEEP_SECONDS=5       # safe & faster
ROTATE_EVERY=4        # VT v2 limit
# ==========================================

fetch_undetected_urls() {
  local domain="$1"
  local key_index="$2"
  local api_key="${API_KEYS[$key_index]}"

  local URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey=$api_key&domain=$domain"

  echo -e "\n\033[1;34m[+] Domain:\033[0m $domain  \033[1;36m(API key $((key_index+1)))\033[0m"

  response=$(curl -s --max-time 15 "$URL")

  # Validate JSON
  if ! echo "$response" | jq . >/dev/null 2>&1; then
    echo -e "\033[1;31m[!] Invalid JSON response\033[0m"
    return
  fi

  response_code=$(echo "$response" | jq -r '.response_code // 0')

  if [[ "$response_code" != "1" ]]; then
    echo -e "\033[1;33m[-] No data or rate-limited\033[0m"
    return
  fi

  undetected_urls=$(echo "$response" | jq -r '
    if (.undetected_urls | type == "array" and length > 0) then
      .undetected_urls[][0]
    else
      empty
    end
  ')

  if [[ -z "$undetected_urls" ]]; then
    echo -e "\033[1;33m[-] No undetected URLs\033[0m"
  else
    echo -e "\033[1;32m[✓] Undetected URLs:\033[0m"
    echo "$undetected_urls"
  fi
}

countdown() {
  local s=$1
  while [ $s -gt 0 ]; do
    echo -ne "\033[1;36mWaiting $s sec...\033[0m\r"
    sleep 1
    ((s--))
  done
  echo -ne "\033[0K"
}

# ================= MAIN =================

if [[ -z "$1" ]]; then
  echo -e "\033[1;31mUsage:\033[0m $0 <domain | file.txt>"
  exit 1
fi

api_index=0
req_count=0

process_domain() {
  local d="$1"
  d=$(echo "$d" | sed 's|https\?://||' | tr -d '[:space:]')
  [[ -z "$d" ]] && return

  fetch_undetected_urls "$d" "$api_index"

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
