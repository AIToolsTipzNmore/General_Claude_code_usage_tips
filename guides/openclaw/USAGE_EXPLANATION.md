# OpenClaw Usage & Cost Model Guide

A breakdown of how OpenClaw is actually priced (it isn't, directly), where its config lives, and how to check what your session is costing you.

> OpenClaw moves fast and was previously known as Clawdbot/Moltbot. Cross-check [docs.openclaw.ai](https://docs.openclaw.ai/) if anything here looks stale.

---

## 1. What OpenClaw Actually Is

OpenClaw is **not** a hosted coding-agent SaaS like Claude Code, Codex, or Gemini CLI. Per its own docs, it's a **self-hosted gateway** that bridges chat apps (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, and more) to an AI agent you run yourself — "Your own personal AI assistant. Any OS. Any Platform." It ships a macOS menu-bar app with voice, iOS/Android paired nodes, a Windows "Hub" companion app, and a core gateway for Linux/WSL2.

This distinction matters for a usage guide: there is no OpenClaw dashboard tracking your spend against a plan, because **OpenClaw itself doesn't charge you anything.**

## 2. The Cost Model: Bring Your Own Key

OpenClaw is free and MIT-licensed. There are no OpenClaw subscription tiers and no OpenClaw-imposed usage quota. You supply your own model provider credentials, and your "quota" is whatever that provider gives you:

```json5
{
  "apiKey": "${OPENAI_API_KEY}"
}
```

Credentials can also be resolved via `SecretRef` objects with `env`, `file`, or `exec` sources, rather than being written in plaintext. Whatever you point OpenClaw at — Anthropic, OpenAI, a local model — that provider's own billing and rate limits are what actually govern your usage.

## 3. Config File Location & Format

| Item | Location |
| --- | --- |
| Main config | `~/.openclaw/openclaw.json` |
| Format | **JSON5** (comments allowed, not strict JSON) |
| Split large configs | `$include` directive, up to 10 nested levels |
| Global secrets fallback | `~/.openclaw/.env` |
| Default agent workspace | `~/.openclaw/workspace/` |
| Override config path | `OPENCLAW_CONFIG_PATH` env var |

Install via `curl -fsSL https://openclaw.ai/install.sh | bash` (macOS/Linux/WSL2), the PowerShell equivalent on Windows, or `npm install -g openclaw@latest` (also `pnpm`/`bun`), followed by `openclaw onboard --install-daemon`.

## 4. Checking Usage From the Terminal

There's no persistent statusline, but `openclaw status` gives a one-shot diagnostic check:

```bash
openclaw status --usage --json
```

Other useful diagnostics: `openclaw doctor` (health check) and `openclaw gateway status` (is the gateway daemon actually running).

## 5. `agent` vs `agents`

These are two different commands, easy to conflate:

| Command | Scope |
| --- | --- |
| `openclaw agent` | Runs **one turn** through a single agent (or `--local` for embedded execution) |
| `openclaw agents` | Manages **isolated agent profiles** — separate workspaces, auth, and channel routing (`agents list`, `agents add`, `agents bind`, `agents set-identity`, `agents delete`) |

Model routing is a per-call override on `agent`: `--model <provider>/<model-id>`. Per-agent skill visibility (which skills a given isolated agent can see) is set via `agents.defaults.skills` / `agents.list[].skills` in `openclaw.json`.

---

## How This Compares

| Concept | Claude Code / Codex / Gemini CLI | OpenClaw |
| --- | --- | --- |
| Pricing model | Subscription or metered API billing | Free tool, BYO provider key — no quota of its own |
| "Quota" concept | Rolling windows / daily request caps | Whatever your model provider enforces |
| Usage visibility | Statusline, `/stats`, web analytics | `openclaw status --usage` (one-shot, no live bar) |
| Config format | JSON / TOML | JSON5 with `$include` |

See [../claude-code/USAGE_EXPLANATION.md](../claude-code/USAGE_EXPLANATION.md), [../codex/USAGE_EXPLANATION.md](../codex/USAGE_EXPLANATION.md), and [../gemini-cli/USAGE_EXPLANATION.md](../gemini-cli/USAGE_EXPLANATION.md) for the subscription-based tools this one is unlike.

---

**Sources:**
- [OpenClaw — GitHub](https://github.com/openclaw/openclaw)
- [OpenClaw Docs](https://docs.openclaw.ai/)
- [Gateway configuration](https://docs.openclaw.ai/gateway/configuration)
- [CLI: agent](https://docs.openclaw.ai/cli/agent) · [CLI: agents](https://docs.openclaw.ai/cli/agents)
- [Help / FAQ](https://docs.openclaw.ai/help/faq)
