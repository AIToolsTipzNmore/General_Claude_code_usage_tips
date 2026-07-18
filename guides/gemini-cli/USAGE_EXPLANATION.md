# Gemini CLI Token Usage & Quota Guide

An in-depth breakdown of how Gemini CLI's quota system works, how it differs by authentication method, and how to check your usage without leaving the terminal.

> Gemini CLI's quotas depend heavily on *how you authenticate* — a Google account, a Gemini API key, or Vertex AI all carry different limits. Always cross-check the [official quota and pricing docs](https://geminicli.com/docs/resources/quota-and-pricing/) if a number here looks stale.

---

## 1. Free Tier Limits by Authentication Method

| Auth Method | Free Limit | Notes |
| --- | --- | --- |
| Google Account (Gemini Code Assist) | 1,000 requests/day per user | Standard free path for individual use |
| Gemini API Key (unpaid) | 250 model requests/day per user | Restricted to Flash-family models |
| Vertex AI (Express Mode) | Free for 90 days | Billing required after the trial window; model-specific quotas apply |

During periods of high service demand, requests are also **rate-limited per user per minute**, independent of the daily cap.

## 2. Paid Tiers

| Plan | Daily Requests |
| --- | --- |
| Google AI Pro (individual) | 1,500 |
| Google AI Ultra (individual) | 2,000 |
| Gemini Code Assist Standard (Workspace) | 1,500 |
| Gemini Code Assist Enterprise (Workspace) | 2,000 |

## 3. Pay-As-You-Go

Once you're past a daily allowance — or want to skip fixed daily caps entirely — you can switch to:

- **Vertex AI standard mode**, or
- **A billed Gemini API key**

Both bill by actual token consumption rather than a fixed number of requests per day, so cost scales with how much you actually use rather than resetting to zero each morning.

## 4. Checking Usage From the Terminal

Run `/stats` inside a session for a breakdown with three views:

| Subcommand | Shows |
| --- | --- |
| `/stats session` (default) | Session duration, tool calls, performance metrics |
| `/stats model` | Token counts and quota information per model |
| `/stats tools` | Per-tool usage statistics |

Gemini CLI's footer can also surface a live usage indicator, but by default it **only appears once you've dropped below 20% of your remaining quota** — it's not an always-on percentage like Codex's `/statusline` toggle. A pending change ([google-gemini/gemini-cli#16754](https://github.com/google-gemini/gemini-cli/issues/16754), with PR #19001 in progress) aims to let you show the quota percentage at all times instead of only near the limit. See the [optimization guide](General_Gemini_usage_tips.md) for how to configure the footer today.

## 5. Reset Windows

Official docs describe daily maximums but don't publish an exact reset-time formula the way Codex's analytics page does — treat limits as resetting on a rolling or midnight-anchored daily basis and confirm against your own account's behavior if precision matters.

---

## How This Compares

| Concept | Claude Code | Codex CLI | Gemini CLI |
| --- | --- | --- | --- |
| Primary quota shape | Token-based, multi-tier | Token-based + rolling windows | Request-count-based (varies by auth method) |
| Terminal visibility | Custom statusline hook | Built-in `/statusline` toggle | `/stats` command + footer (near-limit only) |
| Free tier available | No (subscription/API only) | No (ChatGPT plan required) | Yes — Google account or API key |

See [../claude-code/USAGE_EXPLANATION.md](../claude-code/USAGE_EXPLANATION.md) and [../codex/USAGE_EXPLANATION.md](../codex/USAGE_EXPLANATION.md) for the equivalent breakdowns on those tools.

---

**Sources:**
- [Gemini CLI: Quotas and pricing](https://geminicli.com/docs/resources/quota-and-pricing/)
- [gemini-cli/docs/resources/quota-and-pricing.md — GitHub](https://github.com/google-gemini/gemini-cli/blob/main/docs/resources/quota-and-pricing.md)
- [CLI commands — Gemini CLI docs](https://geminicli.com/docs/reference/commands/)
- [Footer: Display Model Usage % — google-gemini/gemini-cli#16754](https://github.com/google-gemini/gemini-cli/issues/16754)
