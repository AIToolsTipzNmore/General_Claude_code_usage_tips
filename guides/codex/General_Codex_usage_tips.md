# Codex CLI Optimization & Monitoring Guide

Strategies for tuning `config.toml`, keeping an eye on your rolling quota windows, and using Codex's subagent system without silently multiplying your token bill.

---

## 1. Status Line & Usage Monitoring

Unlike Claude Code, Codex does not (yet) support a fully custom shell-script statusline. Instead, it ships a **built-in toggle**:

```
/statusline
```

Enable `five-hour-limit` and `weekly-limit` from the menu that opens. Both display as live percentages at the bottom of the terminal. For anything deeper — reset timestamps, credit balances, per-client breakdowns — use the web analytics page at `chatgpt.com/codex/cloud/settings/analytics` (see the [usage guide](USAGE_EXPLANATION.md) for details).

If you want a more customized terminal display, the community has filled the gap — see [matcluck/codex-statusline](https://github.com/matcluck/codex-statusline) for a script-based approach modeled on Claude Code's statusline hook. There's also an open feature request ([openai/codex#17827](https://github.com/openai/codex/issues/17827)) tracking native support for fully custom status lines.

## 2. Config & Sandbox Tuning

Codex reads configuration from `~/.codex/config.toml` (user-level) and `.codex/config.toml` (project-level, closest file wins). Key settings:

| Setting | Purpose |
| --- | --- |
| `approval_policy` | `"untrusted"`, `"on-request"`, `"never"` — how often Codex pauses for your approval |
| `sandbox_mode` | `"workspace-write"`, `"danger-full-access"` — how much filesystem access Codex gets |
| `model` / `model_provider` | Choose the model and provider (`openai`, `ollama`, `amazon-bedrock`, etc.) |
| `model_reasoning_effort` | Reasoning intensity, where the model supports it |
| `notify` | Runs an external program on events like `agent-turn-complete` |
| `[history]` | Controls session transcript persistence and file size limits |
| `shell_environment_policy` | Controls which environment variables get passed to subprocesses |

Named profiles let you swap between configurations without editing the file each time:

```bash
codex --profile deep-review
```

This overlays `~/.codex/profile-name.config.toml` on top of your base config.

## 3. Token-Saving Strategies

**Resume instead of restarting:** `codex resume` (or `codex resume --last`) continues a previous session rather than re-establishing context from scratch. `codex fork` branches an existing session into a new thread while keeping its history — useful for trying a risky change without burning a fresh context window.

**Script it, don't chat it:** `codex exec` runs Codex non-interactively, which avoids the overhead of a live TUI session for repeatable or automated tasks. Pair it with `codex exec resume [SESSION_ID]` to continue a scripted run.

**Filtered Command Output:** same principle as any other agent — don't let a firehose of passing test output re-enter context:

```bash
npm test 2>&1 | grep -A5 -E "FAIL|ERROR" | head -100
```

**Structural Content Formatting (AGENTS.md):** Codex's equivalent of `CLAUDE.md` is `AGENTS.md` — a repo-level instructions file. Keep it concise and explicit about output style:

```markdown
- Keep output strictly concise.
- Omit conversational filler, preambles, and postambles.
- Prefer targeted diffs over rewriting entire intact files.
```

## 4. Subagents & Parallel Worker Architecture

Codex supports subagents defined as standalone TOML files:

```
~/.codex/agents/<name>.toml       # personal, all projects
.codex/agents/<name>.toml         # project-scoped
```

Each file requires:

| Field | Required | Purpose |
| --- | --- | --- |
| `name` | ✅ | Identifier used when spawning the agent |
| `description` | ✅ | Tells Codex when this agent should be used |
| `developer_instructions` | ✅ | Core behavioral instructions for the agent |
| `model`, `model_reasoning_effort` | Optional | Overrides — inherits from the parent session if omitted |
| `sandbox_mode` | Optional | Lets a specific subagent run more (or less) restricted than its parent |
| `mcp_servers`, `skills.config` | Optional | Extra tool access scoped to that agent |

Global orchestration limits live under `[agents]` in your main config:

```toml
[agents]
max_threads = 6          # default
max_depth = 1             # default
job_max_runtime_seconds = 600
```

Use `/agent` inside a session to switch between active threads or inspect ongoing subagent work. Subagents are **opt-in only** — Codex won't spawn them unless you explicitly ask it to.

**Context isolation:** subagents inherit the parent's sandbox policy and any live runtime overrides (`/permissions` changes, `--yolo`, etc.), but each can override its own sandbox mode — e.g. marking a review-only subagent as read-only so it can't touch files it's just auditing.

**Cost warning:** because each subagent does its own model and tool work, a subagent workflow costs proportionally more tokens than an equivalent single-agent run. Budget accordingly before fanning out a large parallel job.

## 5. Quick Reference: Useful Commands

| Command | Purpose |
| --- | --- |
| `codex resume [--last]` | Continue a previous interactive session |
| `codex fork` | Branch a prior session into a new thread, preserving history |
| `codex exec` | Run non-interactively (scriptable) |
| `codex cloud` / `codex cloud exec` | Work with Codex Cloud tasks |
| `codex apply` | Apply the latest diff from a cloud task locally |
| `codex features list\|enable\|disable` | Toggle feature flags |
| `/agent` | Switch between or inspect active subagent threads |
| `/statusline` | Toggle the built-in five-hour / weekly quota indicators |

## 6. Best Practices Checklist

- [ ] `/statusline` enabled for both `five-hour-limit` and `weekly-limit`
- [ ] `AGENTS.md` kept concise with explicit "no filler" instructions
- [ ] `approval_policy` and `sandbox_mode` matched to how much you trust the current task
- [ ] `codex resume`/`fork` used instead of re-establishing context from scratch
- [ ] Subagents defined under `~/.codex/agents/` only for tasks that genuinely need isolation or parallelism
- [ ] `[agents]` thread/depth limits set deliberately, not left to defaults, for large fan-outs
- [ ] Verbose command output filtered before it re-enters context

---

**Sources:**
- [Advanced Configuration — Codex Developer Docs](https://developers.openai.com/codex/config-advanced)
- [Developer commands — Codex Developer Docs](https://developers.openai.com/codex/cli/reference)
- [Subagents — Codex Developer Docs](https://developers.openai.com/codex/subagents)
- [Customizable status line — openai/codex#17827](https://github.com/openai/codex/issues/17827)
- [matcluck/codex-statusline](https://github.com/matcluck/codex-statusline)
