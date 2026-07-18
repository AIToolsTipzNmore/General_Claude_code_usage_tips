# Hermes Agent Optimization & Monitoring Guide

Persistent memory tuning, delegating real coding work to Claude Code / Codex / OpenCode, and hooks — Hermes's take on the patterns covered elsewhere in this repo.

---

## 1. Command Reference

Hermes ships 60+ commands under the pattern `hermes [global-options] <command>`. The ones worth knowing first:

| Command | Purpose |
| --- | --- |
| `hermes chat` / `hermes -z` | Interactive or one-shot chat |
| `hermes setup` / `hermes model` | Provider setup wizards |
| `hermes config` | View/edit configuration |
| `hermes skills` / `hermes bundles` | Manage skills |
| `hermes gateway` | Run the messaging-platform daemon |
| `hermes cron` | Scheduled jobs |
| `hermes sessions` / `hermes checkpoints` | Session management and rollback |
| `hermes memory` | Configure external memory providers |
| `hermes insights` | Token/cost/activity analytics |
| `hermes dashboard` | Local web UI (port 9119) |
| `hermes mcp` / `hermes plugins` | MCP server and plugin management |
| `hermes doctor` / `hermes security audit` | Health and security checks |
| `hermes backup` / `hermes import` | Data portability |

Useful global flags: `--yolo` (skip approval prompts), `--worktree`, `--tui`, `--safe-mode`.

## 2. Persistent Memory System

Hermes keeps two core memory files under `~/.hermes/memories/`:

| File | Size | Content |
| --- | --- | --- |
| `MEMORY.md` | ~800 tokens (2,200 char hard limit) | Environment/project notes |
| `USER.md` | ~500 tokens (1,375 char hard limit) | User preferences |

Both are injected as a **frozen system-prompt snapshot at session start** — for prompt-cache efficiency, changes save to disk immediately but only actually surface in the *next* session, not live mid-conversation. Limits are configurable in `~/.hermes/config.yaml` under `memory:`.

For recalling full conversation history (not just the summarized memory files), Hermes uses a `session_search` tool backed by SQLite FTS5 full-text search. If you need memory that goes beyond the built-in files, eight optional external memory providers are supported (Honcho, Mem0, OpenViking, Hindsight, Holographic, RetainDB, ByteRover, Supermemory) via `hermes memory setup` — only one active at a time.

## 3. Delegating Coding Work to Other CLIs

This is Hermes's most distinctive feature relative to everything else in this repo: rather than being a coding agent itself, it has bundled skills that **shell out to other agentic CLIs** and manage their session lifecycle.

**Claude Code delegation:**

```bash
claude -p "..." --allowedTools 'Read,Edit' --max-turns 10 --output-format json
```

Hermes can also drive Claude Code interactively via `tmux` (`tmux send-keys` / `tmux capture-pane`), supports resuming a session tied to a GitHub PR with `--from-pr 42`, and can trigger a PR review with `git diff | claude -p "Review this diff..."`. It parses the JSON result (`session_id`, `total_cost_usd`, `stop_reason`, `num_turns`) to track what happened — note that this requires `claude` installed and authenticated independently; Hermes doesn't manage Claude Code's own auth.

**Codex CLI delegation:**

```bash
codex exec "..." --full-auto --sandbox danger-full-access
```

For PR review, Hermes clones the target repo to a temp directory, runs `codex review --base origin/main`, and posts results back via `gh pr comment`. Long-running tasks use `background=true` with a `process` tool exposing `poll`/`log`/`submit`/`kill` — useful if you're kicking off a Codex task and don't want to block the Hermes session on it.

**OpenCode** has an analogous bundled skill following the same shell-out pattern.

The upshot: Hermes is not re-implementing coding-agent behavior — it's an orchestration layer that manages the subprocess, session state, and (for Codex) PR-comment posting, while the underlying CLI does the actual work. If you already have Claude Code or Codex CLI configured and authenticated, Hermes can sit on top as a persistent-memory dispatcher across multiple projects.

## 4. Hooks & Monitoring

Hermes has a three-tier hooks system:

| Tier | Format | Use case |
| --- | --- | --- |
| Gateway hooks | `HOOK.yaml` + `handler.py` | Messaging-platform-level events |
| Python plugin hooks | Python functions (`pre_tool_call`, `post_llm_call`, `subagent_start`/`stop`, etc.) | Fine-grained lifecycle interception |
| Shell hooks | Configured via `config.yaml` | Simple logging/alerting without writing Python |

For monitoring, `hermes insights` gives you the CLI-level token/cost/activity breakdown, and `hermes dashboard` gives you the full local web UI — session browsing, cache-hit rates, and an embedded chat/TUI. Together these substitute for a live statusline with something closer to a full admin panel.

## 5. Quick Reference: Useful Commands

| Command | Purpose |
| --- | --- |
| `hermes chat` | Start an interactive session |
| `hermes sessions` / `hermes checkpoints` | Manage and roll back sessions |
| `hermes memory setup` | Configure an external memory provider |
| `hermes insights` | Terminal-based usage analytics |
| `hermes dashboard` | Full local web UI on port 9119 |
| `hermes skills` / `hermes bundles` | Manage installed skills |
| `hermes doctor` | Health check |
| `hermes security audit` | Security review of your setup |

## 6. Best Practices Checklist

- [ ] `MEMORY.md` / `USER.md` kept within their hard limits (2,200 / 1,375 chars) — Hermes won't warn you loudly if you overflow, it'll just get truncated
- [ ] External memory provider configured only if the built-in files genuinely aren't enough — adding one is a real dependency, not a free upgrade
- [ ] `claude` / `codex` CLIs authenticated independently before relying on Hermes's delegation skills
- [ ] Long delegated tasks run with `background=true` so they don't block the Hermes session
- [ ] `hermes insights` checked periodically if you're on a paid API key backend, since Hermes itself won't stop you from overspending
- [ ] Nous Portal treated as optional convenience, not a requirement — plenty of setups run entirely on self-hosted models or a single provider key

---

**Sources:**
- [CLI commands reference](https://hermes-agent.nousresearch.com/docs/reference/cli-commands)
- [Memory](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/memory.md) · [Memory providers](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/memory-providers.md)
- [Claude Code delegation skill](https://hermes-agent.nousresearch.com/docs/user-guide/skills/bundled/autonomous-ai-agents/autonomous-ai-agents-claude-code)
- [Codex delegation skill](https://hermes-agent.nousresearch.com/docs/user-guide/skills/bundled/autonomous-ai-agents/autonomous-ai-agents-codex)
- [Hooks](https://hermes-agent.nousresearch.com/docs/user-guide/features/hooks)
- [Web dashboard](https://hermes-agent.nousresearch.com/docs/user-guide/features/web-dashboard)
