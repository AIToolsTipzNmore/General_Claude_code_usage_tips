#!/usr/bin/env bash
# Read the JSON payload piped from Claude Code
read -r JSON_INPUT

if [ -z "$JSON_INPUT" ]; then
  exit 0
fi

# Extract token analytics and cost metrics using jq
TOTAL_IN=$(echo "$JSON_INPUT" | jq -r '.context_window.total_input_tokens // 0')
TOTAL_OUT=$(echo "$JSON_INPUT" | jq -r '.context_window.total_output_tokens // 0')
PCT_USED=$(echo "$JSON_INPUT" | jq -r '.context_window.used_percentage // 0 | floor')
COST=$(echo "$JSON_INPUT" | jq -r '.cost.total_cost_usd // 0')
EFFORT=$(echo "$JSON_INPUT" | jq -r '.effort.level // "low"')

# Format metrics into readable 'k' increments
TOKENS_K=$(( (TOTAL_IN + TOTAL_OUT) / 1000 ))

# Determine dynamic layout color based on context window density
if [ "$PCT_USED" -ge 80 ]; then
  COLOR="\033[31m"   # Red alert for high context rot risk
elif [ "$PCT_USED" -ge 70 ]; then
  COLOR="\033[33m"   # Yellow warning near auto-compact boundaries
else
  COLOR="\033[32m"   # Stable operational context depth
fi
RESET="\033[0m"

# Output the compiled statusline dashboard
printf "${COLOR}⎋ Context: %d%% (${TOKENS_K}k)${RESET} | 💰 Session Cost: \$%.2f | ⚡ Effort: %s\n" "$PCT_USED" "$COST" "$EFFORT"
