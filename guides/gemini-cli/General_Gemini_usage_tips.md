# Gemini CLI Optimization & Monitoring Guide

Strategies for configuring the footer/status display, tuning context compression, and writing hooks — Gemini CLI's equivalent to Claude Code's statusline and sub-agent architecture.

---

## 1. Footer & Status Customization

Gemini CLI has no separate "statusline script" concept — instead, the terminal footer itself is configurable via `settings.json` (`~/.gemini/settings.json` for user-level, `.gemini/settings.json` for project-level; project settings win). Under the `ui` section:

```json
{
  "ui": {
    "footer": {
      "items": ["cwd", "sandbox", "model", "quota"],
      "showLabels": true,
      "hideCWD": false,
      "hideModelInfo": false,
      "hideSandboxStatus": false
    },
    "dynamicWindowTitle": true,
    "showStatusInTitle": false
  }
}
```

- `footer.items` — which indicators render, in order
- `footer.showLabels` — show a descriptive header line above the footer
- `hideCWD` / `hideModelInfo` / `hideSandboxStatus` — hide individual footer elements
- `dynamicWindowTitle` — keep the terminal window title updated with status icons
- `showStatusInTitle` — surface the model's current "thinking" status in the window title

As of now, the quota-percentage footer item only appears automatically once you're below 20% remaining — full-time visibility is on the way via [PR #19001](https://github.com/google-gemini/gemini-cli/issues/16754) but isn't the default yet.

## 2. Context Management & Auto-Compression

Under `contextManagement` in `settings.json`:

| Setting | Default | Purpose |
| --- | --- | --- |
| `historyWindow.maxTokens` | 150,000 | Tokens allowed before compression triggers |
| `historyWindow.retainedTokens` | 40,000 | Tokens always kept, even after compression |
| `messageLimits.normalMaxTokens` | — | Target token budget per conversation turn |
| `model.compressionThreshold` | 0.5 | Fraction of context usage that triggers compression |

Lowering `maxTokens` or `compressionThreshold` trades more frequent compression for a lower chance of hitting context limits mid-task — similar to lowering Claude Code's `autoCompactThreshold`.

## 3. Token-Saving Strategies

**Manual compression:** `/compress` replaces the entire chat history with a summary, saving tokens on everything that follows while keeping a high-level record of what happened.

**Checkpointing instead of one long thread:** `/chat save <tag>` snapshots the current conversation; `/chat resume <tag>` picks it back up later; `/chat list` and `/chat delete <tag>` manage your saved checkpoints. This is Gemini's equivalent of Claude Code's handoff-then-`/clear` pattern — checkpoint at a stable point, then start a lighter-weight continuation instead of dragging the whole history forward.

**Structural Content Formatting (GEMINI.md):** Gemini's equivalent of `CLAUDE.md`/`AGENTS.md` is `GEMINI.md`, controlled by `context.fileName` in settings. Keep it short and directive, same as the other tools:

```markdown
- Keep output strictly concise.
- Omit conversational filler, preambles, and postambles.
- Prefer targeted diffs over rewriting entire intact files.
```

Related context settings worth knowing about: `context.includeDirectories` (pull extra directories into context), `context.memoryBoundaryMarkers` (defaults to `.git` — where upward `GEMINI.md` discovery stops), and `context.fileFiltering.respectGitIgnore` / `respectGeminiIgnore` (keep ignored files out of context entirely).

**Filtered Command Output:** same principle as any other agent:

```bash
npm test 2>&1 | grep -A5 -E "FAIL|ERROR" | head -100
```

## 4. Hooks: Gemini's Equivalent of Sub-Agent Boundaries

Gemini CLI doesn't currently ship a named "subagent" system the way Codex does — its closest analog is a rich **hooks** system that can intercept and shape almost every stage of a turn. Hooks are configured under the `hooks` key in `settings.json`:

```json
{
  "hooks": {
    "BeforeTool": [
      {
        "matcher": "Shell",
        "sequential": false,
        "hooks": [
          {
            "type": "command",
            "command": "~/.gemini/hooks/log-tool-use.sh",
            "name": "log-before-tool",
            "timeout": 60000,
            "description": "Log every shell command before it runs"
          }
        ]
      }
    ]
  }
}
```

Available events:

| Event | Fires |
| --- | --- |
| `SessionStart` | On app startup, session resume, or after `/clear` |
| `BeforeAgent` | After you submit, before the agent starts planning |
| `BeforeModel` | Before a request is sent to the LLM |
| `BeforeToolSelection` | Before the LLM decides which tools to call |
| `BeforeTool` | Before a tool is invoked — good for validation/argument rewriting |
| `AfterTool` | After a tool executes — good for auditing or hiding sensitive output |
| `AfterModel` | Immediately after an LLM response chunk arrives |
| `AfterAgent` | After the model produces its final response |
| `PreCompress` | Before the CLI summarizes history to save tokens |
| `Notification` | On system alerts, e.g. tool permission prompts |
| `SessionEnd` | On CLI exit or session clear |

A hook script reads JSON from stdin and must write JSON to stdout — logs belong on `stderr`, not `stdout`:

```bash
#!/usr/bin/env bash
# ~/.gemini/hooks/log-tool-use.sh

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')

# Logs go to stderr so they don't pollute the hook's JSON return value
echo "[$(date -u +%FT%TZ)] BeforeTool fired for: $tool_name" >&2

# Minimal valid response — {} means "no objection, continue as normal"
echo "{}"
exit 0
```

A ready-to-use version of this script lives at [`scripts/hooks/gemini-log-tool-use.sh`](../../scripts/hooks/gemini-log-tool-use.sh) in this repo.

## 5. Quick Reference: Useful Commands

| Command | Purpose |
| --- | --- |
| `/stats [session\|model\|tools]` | Session, model, or tool-level usage statistics |
| `/compress` | Summarize history in place to reclaim context |
| `/chat save <tag>` / `/chat resume <tag>` | Manual checkpoint and resume |
| `/chat list` / `/chat delete <tag>` | Manage saved checkpoints |
| `/settings` | Inspect/edit settings interactively |

## 6. Best Practices Checklist

- [ ] Footer configured with the indicators you actually want (`ui.footer.items`)
- [ ] `contextManagement` thresholds tuned instead of left at 150k/0.5 defaults for long sessions
- [ ] `GEMINI.md` kept short with explicit "no filler" instructions
- [ ] `/compress` or `/chat save` used deliberately at natural checkpoints, not just when you hit a wall
- [ ] Hooks used for validation/auditing only where they add real value — each one adds latency to its event
- [ ] Verbose command output filtered before it re-enters context

---

**Sources:**
- [Gemini CLI configuration](https://geminicli.com/docs/reference/configuration/)
- [Gemini CLI hooks](https://geminicli.com/docs/hooks/)
- [Hooks reference — Gemini CLI](https://geminicli.com/docs/hooks/reference/)
- [Writing hooks for Gemini CLI](https://geminicli.com/docs/hooks/writing-hooks/)
- [CLI commands — Gemini CLI docs](https://geminicli.com/docs/reference/commands/)
