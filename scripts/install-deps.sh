#!/usr/bin/env bash
#
# Tehvault toolkit — one-time dependency setup for each teammate.
#
# The plugin SKILLS (ui-ux-pro-max, flutter-ui-ux) work out of the box.
# Two pieces need external CLIs installed on the machine:
#
#   1. code-review-graph  → the MCP server bundled in this plugin
#   2. graphify           → the CLI + MCP server the `graphify` skill drives
#
# These are CLI *applications*, so we install them with pipx (isolated venvs).
# This avoids the "externally-managed-environment" (PEP 668) error you get from
# plain `pip install` on Homebrew/modern Python.
#
# Usage:  bash scripts/install-deps.sh
#
set -euo pipefail

# --- ensure pipx is available -------------------------------------------------
if ! command -v pipx >/dev/null 2>&1; then
  echo "==> pipx not found — installing it"
  if command -v brew >/dev/null 2>&1; then
    brew install pipx
  else
    python3 -m pip install --user pipx
  fi
  pipx ensurepath || true
  # pipx ensurepath edits your shell rc; make this session see it too.
  export PATH="$HOME/.local/bin:$PATH"
fi

install_or_upgrade() {  # $1 = pipx package name, $2 = human label
  echo "==> Installing/upgrading $2"
  pipx install "$1" 2>/dev/null || pipx upgrade "$1"
}

# code-review-graph: PyPI name == 'code-review-graph', provides 'code-review-graph'
install_or_upgrade "code-review-graph" "code-review-graph (MCP server)"

# graphify: PyPI distribution name is 'graphifyy' (double y); it installs the
# 'graphify' and 'graphify-mcp' executables.
install_or_upgrade "graphifyy" "graphify (graphify + graphify-mcp)"

echo
echo "==> Verifying binaries"
command -v code-review-graph >/dev/null && code-review-graph -v || echo "   (!) code-review-graph not on PATH — open a new terminal (pipx ensurepath) and retry"
command -v graphify          >/dev/null && graphify --version 2>/dev/null || echo "   (!) graphify not on PATH — open a new terminal and retry"

echo
echo "==> Optional: register the graphify MCP server (per-user graph file)"
echo "    The graphify skill uses its own MCP server with a graph stored under"
echo "    your home dir. Register it once with:"
echo
echo "      mkdir -p \"\$HOME/.graphify\""
echo "      claude mcp add --scope user graphify graphify-mcp -- \"\$HOME/.graphify/global-graph.json\""
echo
echo "Done. Restart Claude Code (or run /mcp) to pick up the servers."
