# Curated Skills Directory — skills.sh & ClawHub Picks

Two separate ecosystems have emerged for packaging reusable agent behaviors as installable "skills": [skills.sh](https://www.skills.sh/) (Vercel's open, cross-agent skills directory — works with Claude Code, Codex-style CLIs, Cursor, Windsurf, GitHub Copilot, and more) and [ClawHub](https://docs.openclaw.ai/clawhub) (OpenClaw's official skill + plugin registry). This is a curated, dev-workflow-focused slice of each — not an exhaustive catalog. skills.sh alone claims 91,000+ skills; ClawHub's ecosystem runs into the thousands. Treat this as a starting shortlist, not a ranking.

> A note on sourcing: the skills.sh entries below were confirmed directly against live skills.sh pages. Several ClawHub entries were confirmed against official OpenClaw docs, but a handful come from third-party roundups (DataCamp, PixVerse, Medium) rather than an official ClawHub listing page, noted individually below — worth a quick look at the skill's own `SKILL.md` before installing anything security-sensitive.

---

## skills.sh Picks

**Installing a skill:** skills.sh skills are just `SKILL.md` files inside GitHub repos. The official CLI pulls them in:

```bash
npx skills add https://github.com/anthropics/skills --skill frontend-design
```

Omit `--skill` to pull an entire repo's skill collection. This works across any agent that supports the Skills format.

| Skill | Category | What it does |
| --- | --- | --- |
| [find-skills](https://www.skills.sh/vercel-labs/skills/find-skills) | Meta / discovery | Searches skills.sh itself for other skills matching what you're trying to do, ranked by install count and repo trust signals |
| [frontend-design](https://www.skills.sh/anthropics/skills/frontend-design) | Design / UI | Pushes an agent to commit to a deliberate aesthetic direction instead of generic AI-looking UI |
| [web-design-guidelines](https://www.skills.sh/vercel-labs/agent-skills/web-design-guidelines) | Design / accessibility review | Audits UI code against Vercel's Web Interface Guidelines, pulled live before each review |
| [vercel-react-best-practices](https://www.skills.sh/vercel-labs/agent-skills/vercel-react-best-practices) | Code review / performance | 70-rule React/Next.js performance playbook with before/after refactor examples |
| [deploy-to-vercel](https://www.skills.sh/vercel-labs/agent-skills/deploy-to-vercel) | Deployment | Detects your project setup and deploys to Vercel, handling preview URLs and multi-team auth |
| [agent-browser](https://www.skills.sh/vercel-labs/agent-browser) | Testing / automation | Persistent-session browser automation over CDP for navigation, scraping, and interaction testing |
| [microsoft-foundry](https://www.skills.sh/microsoft/azure-skills/microsoft-foundry) | Cloud / agent deployment | Manages the full agent lifecycle on Microsoft Foundry — creation, containerization, deployment, batch eval |
| [azure-messaging](https://www.skills.sh/microsoft/azure-skills/azure-messaging) | Cloud debugging | Structured troubleshooting for Event Hubs / Service Bus issues across Python, Java, JS, .NET |
| [tdd](https://www.skills.sh/mattpocock/skills/tdd) | Testing | Drives red-green-refactor development with vertical slicing and behavior-focused tests |
| [grill-me](https://www.skills.sh/mattpocock/skills/grill-me) | Design review | Runs an adversarial, branch-by-branch Q&A against a plan to surface gaps before implementation |
| [improve-codebase-architecture](https://www.skills.sh/mattpocock/skills/improve-codebase-architecture) | Architecture / refactoring | Finds shallow modules and friction points, proposes refactors using module/seam/adapter terminology |
| [requesting-code-review](https://www.skills.sh/obra/superpowers/requesting-code-review) | Code review workflow | Dispatches a focused reviewer subagent with git SHAs and requirements, returns tiered feedback |
| [triage](https://www.skills.sh/mattpocock/skills/triage) | Project / issue management | Moves GitHub issues through a triage state machine with role-based categorization |
| [seo](https://www.skills.sh/addyosmani/web-quality-skills/seo) | Web quality / SEO | Technical SEO auditing — robots.txt, canonicals, sitemaps, meta/heading optimization, JSON-LD |

## ClawHub Picks

**Installing a skill:** from inside OpenClaw itself, no separate tool needed:

```bash
openclaw skills search "test-runner"
openclaw skills install @owner/test-runner
```

| Skill | Category | What it does | Source |
| --- | --- | --- | --- |
| github | Dev / Git | Wraps the `gh` CLI for issue, PR, branch, and CI workflow management | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| coding-agent | Dev / coding agents | Unifies external coding tools (Claude Code, Codex) behind one delegated interface | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| cursor-agent | Dev / IDE | Programmatic CLI access to the Cursor IDE from within OpenClaw | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| debug-pro | Dev / debugging | Structured, systematic debugging methodology across multiple languages | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| cc-godmode | Dev / orchestration | Orchestrates multi-agent software tasks and coordinates handoffs between coding agents | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| test-runner | Dev / testing | Writes and runs tests across Jest, PyTest, Mocha, Go; parses failures and suggests fixes | [PixVerse roundup](https://pixverse.ai/en/blog/10-must-install-openclaw-skills-for-developers) |
| agentlens | Dev / code understanding | Generates a hierarchical codebase map with file summaries and dependency graphs | [PixVerse roundup](https://pixverse.ai/en/blog/10-must-install-openclaw-skills-for-developers) |
| database-query | Dev / data | Converts natural language into SQL for PostgreSQL/MySQL/SQLite | [Medium roundup](https://medium.com/@tentenco/the-best-clawhub-skills-worth-installing-now-a-category-by-category-guide-5221c4850d21) |
| duckdb | Data / analytics | Fast local analytics on CSV/Parquet/JSON via the DuckDB CLI | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| docker-essentials | DevOps | Builds, tags, and runs containers; manages Compose stacks, logs, networking | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| k8-multicluster | DevOps / cloud | Manages multiple Kubernetes clusters with safe context switching | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| aws-infra | DevOps / cloud | Guides AWS infrastructure work via CLI following best practices | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |
| agent-browser (ClawHub) | Dev / automation | Web automation for login flows, form interaction, and data extraction | [Medium roundup](https://medium.com/@tentenco/the-best-clawhub-skills-worth-installing-now-a-category-by-category-guide-5221c4850d21) |
| clawscan | Security / governance | Scans skill bundles for red flags (spyware-like behavior, unusual network calls) before install | [DataCamp roundup](https://www.datacamp.com/blog/best-clawhub-skills) |

Also worth knowing about, if less dev-specific: **gog** (Google Workspace integration), **tavily-web-search** (AI-optimized search), and **capability-evolver** (self-improving agent skill) — all repeatedly cited as top-downloaded across multiple sources.

---

**Sources:**
- [skills.sh](https://www.skills.sh/) · [Trending](https://www.skills.sh/trending) · [vercel-labs/skills — find-skills](https://www.skills.sh/vercel-labs/skills/find-skills)
- [ClawHub](https://clawhub.ai/) · [ClawHub docs](https://docs.openclaw.ai/clawhub) · [Skills — OpenClaw docs](https://docs.openclaw.ai/tools/skills)
- [VoltAgent/awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills)
- [DataCamp: Best ClawHub Skills](https://www.datacamp.com/blog/best-clawhub-skills)
- [PixVerse: 10 Must-Install OpenClaw Skills for Developers](https://pixverse.ai/en/blog/10-must-install-openclaw-skills-for-developers)
- [Medium: The Best ClawHub Skills Worth Installing Now](https://medium.com/@tentenco/the-best-clawhub-skills-worth-installing-now-a-category-by-category-guide-5221c4850d21)
