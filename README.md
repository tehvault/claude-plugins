# Tehvault — Claude Code Marketplace

The single, shared source of Claude Code **skills** and **MCP servers** for the
whole Tehvault team. Add this marketplace once and everyone gets the same
toolkit and the same curated set of best-in-class plugins.

> Heads up: `mcpmarket.com` is a third-party *directory* — it does not install
> anything org-wide. This git repo is the actual org-distribution mechanism for
> Claude Code (a "plugin marketplace").

---

## What's in here

```
claude-plugins/                         ← this repo (the "tehvault" marketplace)
├── .claude-plugin/marketplace.json     ← the catalog
├── tehvault-toolkit/                   ← our own plugin (skills + MCP)
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                       ← code-review-graph MCP server
│   └── skills/
│       ├── graphify/                   ← knowledge-graph skill
│       ├── ui-ux-pro-max/              ← web/mobile design intelligence
│       └── flutter-ui-ux/              ← Flutter UI/UX
└── scripts/install-deps.sh             ← one-time CLI dependency setup
```

### `tehvault-toolkit` (our plugin)
| Item | Type | Works out of the box? |
|------|------|------------------------|
| `ui-ux-pro-max` | skill | ✅ yes |
| `flutter-ui-ux` | skill | ✅ yes |
| `graphify` | skill | ⚠️ needs the `graphify` CLI (see deps) |
| `code-review-graph` | MCP server | ⚠️ needs the `code-review-graph` CLI (see deps) |

### Curated plugins (discoverable, not auto-installed)
These mirror entries from Anthropic's official marketplace, hand-picked for our
stack. They show up in `/plugin` so teammates can install what they need:

`context7` (live library docs) · `serena` (semantic code nav) ·
`playwright` (browser/E2E) · `github` (PR/issue workflows) ·
`sentry` (error monitoring) · `stripe` (payments — our Checkout/booking flows) ·
`figma` (design handoff) · `semgrep` (security scanning) ·
`skill-creator` (scaffold new custom skills).

---

## Quick start (each teammate, once)

```bash
# 1. Register the Tehvault marketplace (use the real repo URL once pushed)
/plugin marketplace add tehvault/claude-plugins

# 2. Install our toolkit
/plugin install tehvault-toolkit@tehvault

# 3. (optional) Install any curated plugin you want
/plugin install context7@tehvault
/plugin install playwright@tehvault
```

### Dependencies for `graphify` + `code-review-graph`
The two skills/servers backed by external CLIs need a one-time install:

```bash
bash scripts/install-deps.sh
```

This installs `code-review-graph` and `graphifyy` (provides `graphify` +
`graphify-mcp`) for your user, and prints the command to register the graphify
MCP server with your own graph file. Restart Claude Code afterward.

---

## Make it automatic for the whole org (recommended)

So nobody has to run the commands above manually, commit a `.claude/settings.json`
into your **main app repos**. When a teammate opens that repo in Claude Code and
trusts it, the marketplace registers and the toolkit auto-installs:

```json
{
  "extraKnownMarketplaces": {
    "tehvault": {
      "source": { "source": "github", "repo": "tehvault/claude-plugins" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": {
    "tehvault-toolkit@tehvault": true
  }
}
```

> Only `tehvault-toolkit` is auto-enabled. The curated plugins stay opt-in — add
> them to `enabledPlugins` too if you want them on by default for everyone.

For a hard, MDM-enforced rollout (locked versions, allowed MCP servers, org-wide
`CLAUDE.md`), use enterprise `managed-settings.json` — ask before going down that
path; the marketplace above covers the normal case.

---

## Adding more later
- **New custom skill:** drop a folder under `tehvault-toolkit/skills/<name>/`
  with a `SKILL.md`, bump the version in `tehvault-toolkit/.claude-plugin/plugin.json`,
  commit. (The `skill-creator` plugin scaffolds these for you.)
- **New MCP server:** add it under `mcpServers` in `tehvault-toolkit/.mcp.json`.
- **Another curated plugin:** add an entry to `.claude-plugin/marketplace.json`
  with a remote `source` (git URL or `git-subdir`).
