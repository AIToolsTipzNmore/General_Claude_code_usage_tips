# OpenClaw Optimization & Monitoring Guide

Configuring skills, hooks, and OpenClaw's genuinely first-class sub-agent system — plus where the ClawHub registry fits in.

---

## 1. Skills & ClawHub

Skills are plain directories containing a `SKILL.md` (plus any supporting files), installed under `~/.openclaw/workspace/skills/<skill>/SKILL.md`. **ClawHub** ([github.com/openclaw/clawhub](https://github.com/openclaw/clawhub), [docs.openclaw.ai/clawhub](https://docs.openclaw.ai/clawhub)) is the official public registry — GitHub OAuth login, embedding-based search, versioning, changelogs, tags, community starring.

Browse and install directly from the OpenClaw CLI, no separate tool required:

```bash
openclaw skills search "calendar"
openclaw skills install @openclaw/demo
openclaw skills update --all

# Compiled plugins work the same way:
openclaw plugins search "calendar"
openclaw plugins install clawhub:<package>
```

Skills load through a **six-level priority hierarchy**: workspace → project → personal → managed → bundled → plugin-provided. OpenClaw runs a security scan on ClawHub-sourced skills before activating them — worth knowing if a skill install seems to hang, since that's the scan running, not a stall.

A separate `clawhub` npm CLI (`npm i -g clawhub`) exists specifically for *publishing* your own skills (`clawhub skill publish <path>`, `clawhub package publish <source>`) rather than installing them.

## 2. Config Tuning

Everything lives in `~/.openclaw/openclaw.json` (JSON5). Two settings worth knowing early:

- **`agents.defaults.skills`** / **`agents.list[].skills`** — controls which skills a given isolated agent can see. Useful for keeping a "public-facing" Telegram-bound agent from having access to skills meant only for your personal workspace agent.
- **Secrets** — prefer `SecretRef` objects (`env`, `file`, or `exec` sources) over inlining API keys directly in `openclaw.json`, especially if you ever intend to share or version-control parts of your config.

## 3. Sub-Agent & Parallel Worker Architecture

This is OpenClaw's strongest analog to Claude Code's fan-out patterns, and it's a **built-in tool**, not a bolt-on: [`sessions_spawn`](https://docs.openclaw.ai/tools/subagents) launches a non-blocking background sub-agent as an isolated `agent:<id>:subagent:<uuid>` session; `sessions_yield` blocks and waits on the result.

| Setting | Default | Purpose |
| --- | --- | --- |
| `maxConcurrent` | 8 | Cap on simultaneously running sub-agents |
| `maxSpawnDepth` | — | How deep an orchestrator→worker→sub-worker chain can nest |
| `maxChildrenPerAgent` | — | Fan-out limit per parent agent |
| `archiveAfterMinutes` | — | How long a finished sub-agent's session sticks around before archiving |
| `isolated` / `fork` | — | Context mode: a fresh context vs. inheriting the parent's |

All of this is configured under `agents.defaults.subagents` in `openclaw.json`. As with every other tool in this repo: prefer `isolated` context for workers that don't need your full conversation history, since that's what actually keeps a fan-out from multiplying token usage unnecessarily.

## 4. Hooks System

OpenClaw hooks are file-based: a `HOOK.md` plus a `handler.ts`, firing on:

- **Command events** — `/new`, `/reset`, `/stop`
- **Message events** — inbound/outbound messages, transcription
- **Session events** — compaction
- **Agent bootstrap**
- **Gateway lifecycle** — startup/shutdown

Bundled hooks worth knowing about out of the box: `session-memory`, `command-logger`, `compaction-notifier`, `boot-md`. If you're coming from Claude Code's shell-script hooks or Gemini CLI's stdin/stdout JSON hooks, the shape is conceptually similar — an event fires, your handler runs, you can log, inject context, or block/modify behavior — just implemented as TypeScript rather than an arbitrary shell command.

## 5. The AGENTS.md Convention

OpenClaw ships a [default `AGENTS.md`](https://docs.openclaw.ai/reference/AGENTS.default) that acts as workspace bootstrap: first-run setup instructions (create the workspace directory, copy `SOUL.md`/`TOOLS.md`/`MEMORY.md`), safety rules ("don't dump directories or secrets into chat," "don't run destructive commands unless explicitly asked"), and session-start instructions telling the agent to read `SOUL.md`, `USER.md`, and recent memory *before* responding. If you're customizing OpenClaw's personality or safety posture, this file is the first place to look.

## 6. Quick Reference: Useful Commands

| Command | Purpose |
| --- | --- |
| `openclaw agent -m "..."` | Run one turn through an agent |
| `openclaw agents list / add / bind / delete` | Manage isolated agent profiles |
| `openclaw skills search / install / update --all` | Find and install skills from ClawHub |
| `openclaw status --usage --json` | One-shot usage/health diagnostic |
| `openclaw doctor` | General health check |
| `openclaw gateway status` | Confirm the gateway daemon is running |

## 7. Best Practices Checklist

- [ ] API keys stored via `SecretRef` (`env`/`file`/`exec`), not inlined in `openclaw.json`
- [ ] Per-agent `skills` scoped deliberately — a channel-bound public agent shouldn't see everything your personal agent can
- [ ] Sub-agent fan-outs use `isolated` context unless they genuinely need the parent's full history
- [ ] `maxConcurrent` / `maxSpawnDepth` set intentionally before a large sub-agent fan-out, not left at defaults
- [ ] Skills installed from ClawHub reviewed once before trusting them broadly (the built-in security scan helps, but isn't a substitute for reading a new skill's `SKILL.md`)
- [ ] `AGENTS.md` customized if you want a different safety posture or personality than the shipped default

---

**Sources:**
- [ClawHub — GitHub](https://github.com/openclaw/clawhub) · [ClawHub docs](https://docs.openclaw.ai/clawhub)
- [Skills — OpenClaw docs](https://docs.openclaw.ai/tools/skills)
- [Sub-agents — OpenClaw docs](https://docs.openclaw.ai/tools/subagents)
- [Automation / Hooks — OpenClaw docs](https://docs.openclaw.ai/automation/hooks)
- [Default AGENTS.md — OpenClaw docs](https://docs.openclaw.ai/reference/AGENTS.default)
