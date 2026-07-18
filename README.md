<div align="center">

# ⚡ ClaudeTips

**Practical tips, guides, and scripts for getting the most out of AI coding agents.**

Claude Code · Codex CLI · Gemini CLI · OpenClaw · Hermes Agent · and whatever ships next

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)
[![Made for terminal nerds](https://img.shields.io/badge/made%20for-terminal%20nerds-blue)](#)

</div>

---

## Why "ClaudeTips"?

This repo started as a scratchpad of Claude Code notes — and the name stuck. But the tips, scripts, and configs here aren't Claude-exclusive. Usage quotas, context management, statuslines, sub-agent patterns, and hook scripting are problems shared by every terminal-based AI agent, so this repo has grown to cover Claude Code, OpenAI's Codex CLI, Google's Gemini CLI, the self-hosted OpenClaw assistant, NousResearch's Hermes Agent, and others as they show up. Think of "ClaudeTips" as the repo's origin story, not its ceiling.

## What's inside

- 📘 **Guides** — deep dives on token usage, quota mechanics, auto-compaction, context rot, and cost optimization.
- 🛠️ **Scripts** — statusline engines, hooks, handoff/checkpoint utilities, and other drop-in automation.
- 🤖 **Agent-specific playbooks** — the quirks, flags, and config files unique to each CLI.
- ✅ **Battle-tested patterns** — sub-agent fan-out, plan-mode dry runs, prompt caching strategies, and more.
- 🧩 **Curated skills directory** — hand-picked picks from [skills.sh](https://www.skills.sh/) and [ClawHub](https://docs.openclaw.ai/clawhub), the two big cross-agent skill registries.

## Repository structure

```
General_Claude_code_usage_tips/
├── guides/
│   ├── claude-code/
│   │   ├── USAGE_EXPLANATION.md
│   │   └── General_Claude_code_usage_tips.md
│   ├── codex/
│   │   ├── USAGE_EXPLANATION.md
│   │   └── General_Codex_usage_tips.md
│   ├── gemini-cli/
│   │   ├── USAGE_EXPLANATION.md
│   │   └── General_Gemini_usage_tips.md
│   ├── openclaw/
│   │   ├── USAGE_EXPLANATION.md
│   │   └── General_OpenClaw_usage_tips.md
│   ├── hermes/
│   │   ├── USAGE_EXPLANATION.md
│   │   └── General_Hermes_usage_tips.md
│   └── skills-directory/
│       └── CURATED_SKILLS.md
├── scripts/
│   ├── statusline/
│   │   └── statusline.sh
│   └── hooks/
│       └── gemini-log-tool-use.sh
├── LICENSE
└── README.md
```

## Tools covered

| Tool | Maker | Status |
| --- | --- | --- |
| Claude Code | Anthropic | ✅ Actively covered |
| Codex CLI | OpenAI | ✅ Actively covered |
| Gemini CLI | Google | ✅ Actively covered |
| OpenClaw | Open-source (self-hosted) | ✅ Actively covered |
| Hermes Agent | NousResearch | ✅ Actively covered |
| Aider / Cursor / other agents | Various | 🙌 Contributions welcome |

## Curated Skills Directory

Beyond agent-specific guides, [`guides/skills-directory/CURATED_SKILLS.md`](guides/skills-directory/CURATED_SKILLS.md) is a hand-picked shortlist pulled from [skills.sh](https://www.skills.sh/) (Vercel's cross-agent skills directory) and [ClawHub](https://docs.openclaw.ai/clawhub) (OpenClaw's official skill registry) — dev-workflow-focused picks like TDD drivers, code-review dispatchers, Vercel deploy skills, Kubernetes/AWS helpers, and more, with install commands for each ecosystem.

## Quick start

```bash
git clone https://github.com/AIToolsTipzNmore/General_Claude_code_usage_tips.git
cd General_Claude_code_usage_tips

# Make any shell scripts executable before use
chmod +x scripts/statusline/*.sh
```

Browse `guides/<tool>/` for write-ups, or drop a script from `scripts/` straight into your own `~/.claude`, `~/.codex`, or equivalent config directory.

## Contributing

Found a trick that saves tokens, a config that fixes a footgun, or a script worth sharing? PRs are welcome.

1. Fork the repo
2. Add your guide or script under the relevant tool folder (or create a new one)
3. Keep guides concise and scripts commented — future-you will thank you
4. Open a pull request with a short description of what it does and why it's useful

## License

Released under the [MIT License](LICENSE) — use it, fork it, ship it.
