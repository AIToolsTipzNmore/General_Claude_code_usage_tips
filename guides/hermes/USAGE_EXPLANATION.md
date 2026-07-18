# Hermes Agent Usage & Cost Model Guide

A breakdown of how Hermes Agent (NousResearch) is priced, where it stores its data, and how to check what a session actually cost.

> Cross-check [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/) if anything here looks stale — Hermes ships frequently.

---

## 1. What Hermes Actually Is

Hermes Agent is billed as "the agent that grows with you" — an open-source, self-improving agent with **persistent memory**, not an IDE-tethered coding copilot. It runs standalone (desktop, server, Docker, SSH, serverless), connects to 20+ messaging surfaces (Telegram, Discord, Slack, WhatsApp, and more), and includes a learning loop that lets it create and refine its own skills over time, periodically persist knowledge, and search its own past conversations.

The practical implication for a usage guide: Hermes isn't "a coding agent with a quota" the way Claude Code or Codex are. It's closer to a long-running assistant that happens to be very good at *delegating* coding work to other CLIs (more on that in the [optimization guide](General_Hermes_usage_tips.md)).

## 2. The Cost Model: Bring Your Own Key (Mostly)

Hermes itself is free and open-source (MIT), with **no usage limits or subscription tiers of its own**. Per the official [providers doc](https://hermes-agent.nousresearch.com/docs/integrations/providers): "you need at least one provider configured to use Hermes." Your actual cost is entirely a function of what you connect it to:

| Backend | Cost |
| --- | --- |
| Self-hosted (Ollama, vLLM, llama.cpp, LM Studio) | Free — your own compute |
| Your own API key (OpenRouter, Anthropic, OpenAI, etc.) | Pay-per-use, billed by that provider |
| **Nous Portal** (optional) | Paid subscription — one OAuth login to 300+ models plus a bundled Tool Gateway (web search, image gen, TTS, browser tools) and Nous Chat |

Nous Portal is opt-in, not required — it exists purely as a convenience layer if you don't want to manage separate API keys per provider.

## 3. Config & Data Location

Config and data live under `HERMES_HOME`, which defaults to `~/.hermes` (or `%LOCALAPPDATA%\hermes` on Windows). Install via:

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash    # Linux/macOS/WSL2/Termux
```

or the PowerShell one-liner on Windows, or a manual `git clone` + `uv` setup for source installs.

## 4. Checking Usage From the Terminal

```bash
hermes insights      # token / cost / activity analytics, in the terminal
hermes dashboard      # local web UI on port 9119 — token/cost analytics, cache-hit
                       # rates, session browsing, embedded browser-based chat/TUI
```

There's no persistent inline statusline the way Claude Code or Codex have one — `hermes dashboard` is the closest equivalent, and it's considerably richer than a status bar, effectively functioning as a full local admin panel.

---

## How This Compares

| Concept | Claude Code / Codex / Gemini CLI | OpenClaw | Hermes Agent |
| --- | --- | --- | --- |
| Pricing model | Subscription / metered API | Free, BYO key | Free, BYO key (+ optional Nous Portal subscription) |
| Usage visibility | Statusline / `/stats` / web analytics | `openclaw status --usage` (one-shot) | `hermes insights` (CLI) + `hermes dashboard` (web UI) |
| Core differentiator | IDE/terminal-tethered coding sessions | Personal assistant gateway across chat apps | Persistent cross-session memory + self-improving skills |

See [../openclaw/USAGE_EXPLANATION.md](../openclaw/USAGE_EXPLANATION.md) for the other bring-your-own-key tool in this repo, and [../claude-code/USAGE_EXPLANATION.md](../claude-code/USAGE_EXPLANATION.md) / [../codex/USAGE_EXPLANATION.md](../codex/USAGE_EXPLANATION.md) / [../gemini-cli/USAGE_EXPLANATION.md](../gemini-cli/USAGE_EXPLANATION.md) for the subscription-based tools.

---

**Sources:**
- [Hermes Agent — GitHub](https://github.com/NousResearch/hermes-agent)
- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- [Providers / cost model](https://hermes-agent.nousresearch.com/docs/integrations/providers)
- [CLI commands reference](https://hermes-agent.nousresearch.com/docs/reference/cli-commands)
- [Web dashboard](https://hermes-agent.nousresearch.com/docs/user-guide/features/web-dashboard)
