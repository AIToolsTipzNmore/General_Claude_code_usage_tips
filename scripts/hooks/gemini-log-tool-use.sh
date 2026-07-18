#!/usr/bin/env bash
# Gemini CLI hook example: log every tool call before it runs.
#
# Install: register under hooks.BeforeTool (or AfterTool) in
# ~/.gemini/settings.json or .gemini/settings.json:
#
#   {
#     "hooks": {
#       "BeforeTool": [
#         {
#           "matcher": "Shell",
#           "hooks": [
#             {
#               "type": "command",
#               "command": "~/.gemini/hooks/gemini-log-tool-use.sh",
#               "name": "log-before-tool"
#             }
#           ]
#         }
#       ]
#     }
#   }
#
# Gemini CLI hooks receive JSON on stdin and must return JSON on stdout.
# Anything you want logged has to go to stderr — stdout is reserved for
# the hook's actual (JSON) response.

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
tool_input=$(echo "$input" | jq -c '.tool_input // {}')

LOG_FILE="${GEMINI_HOOK_LOG:-$HOME/.gemini/hooks/tool-use.log}"
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date -u +%FT%TZ)] tool=$tool_name input=$tool_input" >> "$LOG_FILE"
echo "[$(date -u +%FT%TZ)] BeforeTool fired for: $tool_name" >&2

# {} means "no objection, proceed as normal". Swap in
# {"decision":"deny","reason":"..."} to block a tool call instead.
echo "{}"
exit 0
