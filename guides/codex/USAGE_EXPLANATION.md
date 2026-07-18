# OpenAI Codex CLI Token Usage & Quota Guide

An in-depth breakdown of how Codex CLI meters usage, how it bills against your ChatGPT plan, and how to check your remaining quota without leaving the terminal.

> Codex's pricing and limits have changed more than once since launch — this guide reflects the token-based rate card introduced in April 2026. Always cross-check [OpenAI's Codex rate card](https://help.openai.com/en/articles/20001106-codex-rate-card) if a number here looks stale.

---

## 1. How Codex Meters Usage

As of the April 2026 update, Codex charges **credits per million tokens**, split across three categories, and the rate depends on which model you're running:

| Token Category | Example Rate (GPT-5.5) | Example Rate (GPT-5.4-Mini) |
| --- | --- | --- |
| Input tokens | 125 credits / 1M | 18.75 credits / 1M |
| Cached input tokens | Discounted vs. fresh input | Discounted vs. fresh input |
| Output tokens | 750 credits / 1M | 113 credits / 1M |

A typical Codex task on GPT-5.5 consumes roughly **5–45 credits**, depending on how much code it reads and writes. Real-world spend averages **~$100–$200 per developer per month**, though this swings heavily based on model choice and how often "fast mode" is used.

## 2. Which Plans This Applies To

The token-based rate card covers:

- ChatGPT Plus and Pro
- ChatGPT Business
- Enterprise, Edu, Gov, Health, and ChatGPT for Teachers

A small subset of legacy Enterprise customers are still on the older per-message pricing model rather than token-based billing.

## 3. Quota Windows: Five-Hour and Weekly Buckets

Independent of the credit-based rate card, Codex also enforces **rolling usage windows** — conceptually similar to Claude Code's `session-0` and `weekly_all` registries:

| Window | Behavior |
| --- | --- |
| 🕒 Five-hour limit | A short rolling window that throttles high-frequency bursts of usage |
| 📅 Weekly limit | A longer rolling window acting as the overall ceiling for the week |

Both are exposed as **remaining-quota percentages**, not raw token or credit counts.

## 4. Checking Usage From the Terminal

Run `/statusline` inside an interactive Codex session to open a configuration menu. Toggle on the metrics you want tracked, then press Enter to save:

```
five-hour-limit    # remaining % of the 5-hour rolling window
weekly-limit       # remaining % of the weekly rolling window
```

Once enabled, both percentages update live at the bottom of your terminal as you work — no need to tab over to a browser mid-task.

**Limitation:** the terminal status line only shows live percentages. It does **not** show reset timestamps, credit balances, or raw token/cost counts.

## 5. Full Diagnostics: The Web Analytics Page

For exact reset times (e.g. "Resets 10:16 PM"), credit balances, and a usage breakdown by client type, visit:

```
https://chatgpt.com/codex/cloud/settings/analytics
```

This is the Codex equivalent of running a `/cost`-style diagnostics command — except the deepest numbers currently live on the web, not in the CLI.

---

## How This Compares

| Concept | Claude Code | Codex CLI |
| --- | --- | --- |
| Short-term burst quota | `session-0` (multi-hour rolling) | Five-hour limit |
| Long-term ceiling | `weekly_all-1` (7-day rolling) | Weekly limit |
| Terminal visibility | Full statusline hook, custom script | Built-in `/statusline` toggle, percentages only |
| Full diagnostics | In-terminal `/cost` | Web analytics page |

See the [Claude Code usage guide](../claude-code/USAGE_EXPLANATION.md) for the equivalent breakdown on that side.

---

**Sources:**
- [Codex rate card — OpenAI Help Center](https://help.openai.com/en/articles/20001106-codex-rate-card)
- [Using Codex with your ChatGPT plan — OpenAI Help Center](https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan)
- [How to Check Codex Usage: CLI Status Line and Web Page](https://www.jdhodges.com/blog/codex-usage-cli-status-line/)
- [OpenAI Codex Pricing 2026 — UI Bakery Blog](https://uibakery.io/blog/openai-codex-pricing)
