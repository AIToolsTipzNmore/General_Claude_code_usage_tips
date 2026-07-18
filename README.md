# General_Claude_code_usage_tips
Short guide of how usage works, how to best use it with sub agents and statuslines

# Claude Code Optimization & Monitoring Guide

Strategies for maximizing token efficiency, controlling auto-compaction thresholds, and establishing a persistent status bar metrics engine.

---

## 1. Custom Status Bar Engine

Claude Code provides a native `statusline` hook that streams real-time session JSON arrays into a specified executable script. This allows you to track localized context memory, session costs, and active token states.

### Step 1: Create the Tracking Script
Create a shell utility file at `~/.claude/statusline.sh`:

```bash
#!/usr/bin/env bash

# Read the JSON payload piped from Claude Code
read -r JSON_INPUT

if [ -z "$JSON_INPUT" ]; then
  exit 0
fi

# Extract token analytics and cost metrics using jq
TOTAL_IN=$(echo "$JSON_INPUT" | jq -r '.context_window.total_input_tokens // 0')
TOTAL_OUT=$(echo "$JSON_INPUT" | jq -r '.context_window.total_output_tokens // 0')
PCT_USED=$(echo "$JSON_INPUT" | jq -r '.context_window.used_percentage // 0')
COST=$(echo "$JSON_INPUT" | jq -r '.cost.total_cost_usd // 0')
EFFORT=$(echo "$JSON_INPUT" | jq -r '.effort.level // "low"')

# Format metrics into readable 'k' increments
TOKENS_K=$(( (TOTAL_IN + TOTAL_OUT) / 1000 ))

# Determine dynamic layout color based on context window density
if [ "$PCT_USED" -ge 80 ]; then
  COLOR="\033[31m" # Red alert for high context rot risk
elif [ "$PCT_USED" -ge 70 ]; then
  COLOR="\033[33m" # Yellow warning near auto-compact boundaries
else
  COLOR="\033[32m" # Stable operational context depth
fi
RESET="\033[0m"

# Output the compiled statusline dashboard
printf "${COLOR}⎋ Context: \%d\%\% (${TOKENS_K}k)${RESET} \vert{} 💰 Session Cost: \$\%.2f \vert{} ⚡ Effort: \%s\n" "$PCT_USED" "$COST" "$EFFORT"

Make the script executable:

Bash
chmod +x ~/.claude/statusline.sh
Step 2: Global Configuration Integration
Bind the script and tighten memory triggers inside your global configuration file (~/.claude/settings.json):

JSON
{
  "statusline": "~/.claude/statusline.sh",
  "autoCompactThreshold": 70,
  "notifications": true,
  "permissions": {
    "deny": [
      "Read(node_modules/**)",
      "Read(dist/**)",
      "Read(*.lock)",
      "Read(*.lockb)",
      "Read(pnpm-lock.yaml)"
    ]
  }
}
2. Token Saving Strategies
Tactical Command Management
The Handoff Architecture: Prevent open terminal loops. When completing a task segment, run a prompt instructing the environment to write a micro-manifest summary: Write a handoff.md mapping completed changes and the next milestone. Then invoke /clear to erase the context cache and start fresh by referencing the handoff document.

Targeted History Compaction: Run /compact immediately following heavy build sequences or extensive lint adjustments. You can target specific focus targets by passing variables directly: /compact Keep database schemas, discard intermediate terminal stack traces.

Rollbacks via /rewind: If a prompt sets off an unintended side effect or an error cascade, break sequence via Escape and run /rewind to return to the last known healthy state before those errors pollute the rolling token memory.

Filtered Command Output: Never allow processes to pipe hundreds of successful test passes back into the context buffer. Filter logs directly in the terminal invocation:

Bash
npm test 2>&1 | grep -A5 -E "FAIL|ERROR" | head -100
Structural Content Formatting (CLAUDE.md)
Keep your repository level rulesets concise (ideally under 500 tokens). Inject baseline instructions to restrict output prose overhead:

Markdown
- Keep output strictly concise.
- Omit conversational filler, preambles, and postambles.
- Prefer targeted diffs over rewriting entire intact files.
3. Fan-out Agent & Parallel Worker Architectures
When setting up custom worker processes or launching parallel sub-agents to multi-thread structural development tasks, observe strict boundary guidelines:

Enforce State-Isolation: Avoid worker inheritance. Passing an orchestrator's complete history down to multiple agents multiplies token usage exponentially. Isolate sub-tasks and feed workers only the explicit text snippets or narrow targets required for their specific lifecycle.

Background Process Redirection: Instruct parallel workers to execute tasks silently behind log walls rather than outputting straight to stdout. Pipe logging into specific background file layers and return an isolated state signal to the supervising agent:

Bash
npm run test:moduleA > .claude/workers/worker_A.log 2>&1 || echo "WORKER_A_FAILED"
Path-Scope Directory Constraints: Prevent child processes from making automated recursive directory mapping passes across unrelated code bases by declaring clear system barriers in localized project .json scopes.

Dry Runs with Plan Mode: Before initiating a massive concurrent layout run that commands multiple models simultaneously, cycle into Plan Mode via Shift+Tab. This forces the supervisor to model a layout diagram of the agents it plans to build, allowing you to catch architectural loops before burning through your weekly limits.

