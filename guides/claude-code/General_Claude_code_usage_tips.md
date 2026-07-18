# Claude Code Optimization & Monitoring Guide

Strategies for maximizing token efficiency, controlling auto-compaction thresholds, and establishing a persistent status bar metrics engine — plus patterns for running sub-agents without burning through your usage limits.

---

## 1. Custom Status Bar Engine

Claude Code provides a native `statusline` hook that streams real-time session JSON arrays into a specified executable script. This lets you track localized context memory, session costs, and active token states at a glance.

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
```

Make the script executable:

```bash
chmod +x ~/.claude/statusline.sh
```

| Context Usage | Color | Meaning |
| --- | --- | --- |
| ≥ 80% | 🔴 Red | High context rot risk — expect degraded recall of earlier turns |
| 70–79% | 🟡 Yellow | Approaching the auto-compact boundary |
| < 70% | 🟢 Green | Stable operational context depth |

### Step 2: Global Configuration Integration

Bind the script and tighten memory triggers inside your global configuration file (`~/.claude/settings.json`):

```json
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
```

Lowering `autoCompactThreshold` below the default trades a bit more compaction overhead for fewer context-rot surprises late in long sessions. The `permissions.deny` block keeps large, low-signal files (lockfiles, build output, `node_modules`) out of context entirely, since Claude rarely needs to read them and they can silently eat a large share of your token budget.

---

## 2. Token-Saving Strategies

### Tactical Command Management

**The Handoff Architecture:** Prevent open-ended terminal loops. When you finish a task segment, run a prompt instructing the environment to write a micro-manifest summary — e.g. "Write a `handoff.md` mapping completed changes and the next milestone." Then invoke `/clear` to erase the context cache and start fresh by referencing the handoff document.

**Targeted History Compaction:** Run `/compact` immediately after heavy build sequences or extensive lint adjustments. You can target specific content by passing instructions directly: `/compact Keep database schemas, discard intermediate terminal stack traces.`

**Rollbacks via `/rewind`:** If a prompt sets off an unintended side effect or an error cascade, break the sequence with Escape and run `/rewind` to return to the last known healthy state before those errors pollute the rolling token memory.

**Filtered Command Output:** Never let a process pipe hundreds of successful test passes back into the context buffer. Filter logs directly in the terminal invocation:

```bash
npm test 2>&1 | grep -A5 -E "FAIL|ERROR" | head -100
```

### Structural Content Formatting (CLAUDE.md)

Keep repository-level rulesets concise — ideally under 500 tokens. Inject baseline instructions to restrict output prose overhead:

```markdown
- Keep output strictly concise.
- Omit conversational filler, preambles, and postambles.
- Prefer targeted diffs over rewriting entire intact files.
```

---

## 3. Fan-out Agent & Parallel Worker Architectures

When setting up custom worker processes or launching parallel sub-agents to multi-thread structural development tasks, observe strict boundary guidelines:

- **Enforce state isolation.** Avoid worker inheritance — passing an orchestrator's complete history down to multiple agents multiplies token usage exponentially. Isolate sub-tasks and feed workers only the explicit text snippets or narrow targets required for their specific lifecycle.
- **Redirect background process output.** Instruct parallel workers to execute tasks silently behind log walls rather than streaming straight to stdout. Pipe logging into dedicated file layers and return only an isolated status signal to the supervising agent:

```bash
npm run test:moduleA > .claude/workers/worker_A.log 2>&1 || echo "WORKER_A_FAILED"
```

- **Constrain path scope.** Prevent child processes from making automated recursive directory-mapping passes across unrelated code bases by declaring clear boundaries in localized project config scopes.
- **Dry-run with Plan Mode.** Before kicking off a large concurrent run that commands multiple models simultaneously, cycle into Plan Mode via `Shift+Tab`. This forces the supervisor to lay out the agents it intends to build so you can catch architectural loops before burning through your weekly limits.

---

## 4. Quick Reference: Useful Commands

| Command | Purpose |
| --- | --- |
| `/cost` | Show cumulative session cost and token usage |
| `/compact [focus]` | Manually compact conversation history, optionally steering what survives |
| `/clear` | Wipe context and start fresh — pairs well with the handoff.md pattern above |
| `/rewind` | Roll back to a previous checkpoint before an error cascade pollutes context |
| `Shift+Tab` | Toggle Plan Mode to preview an agent's intended actions before execution |

---

## 5. Best Practices Checklist

- [ ] Statusline script installed and executable at `~/.claude/statusline.sh`
- [ ] `autoCompactThreshold` tuned to your workflow (lower for long, high-churn sessions)
- [ ] Lockfiles, build output, and `node_modules` excluded via `permissions.deny`
- [ ] `CLAUDE.md` kept under ~500 tokens with explicit "no filler" instructions
- [ ] Sub-agents launched with narrow, isolated context rather than full history inheritance
- [ ] Verbose command output filtered (`grep`/`head`) before it re-enters context
- [ ] Plan Mode used as a dry run before any large multi-agent fan-out
