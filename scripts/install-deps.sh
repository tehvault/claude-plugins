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
# This script installs both and (optionally) registers the graphify MCP
# server at user scope so the graphify skill is fully wired up.
#
# Usage:  bash scripts/install-deps.sh
#
set -euo pipefail

PY=python3
PIP="$PY -m pip"

echo "==> Installing code-review-graph (MCP server for the code-review-graph plugin server)"
$PIP install --user --upgrade code-review-graph

echo "==> Installing graphify (provides 'graphify' + 'graphify-mcp')"
# NOTE: the PyPI distribution name is 'graphifyy' (double y); it installs the
# 'graphify' and 'graphify-mcp' executables.
$PIP install --user --upgrade graphifyy

# Make sure the user bin dir is on PATH (pip --user installs land here).
USER_BIN="$($PY -m site --user-base)/bin"
case ":$PATH:" in
  *":$USER_BIN:"*) ;;
  *) echo "==> NOTE: add '$USER_BIN' to your PATH (e.g. in ~/.zshrc):"
     echo "       export PATH=\"$USER_BIN:\$PATH\"" ;;
esac

echo
echo "==> Verifying binaries"
command -v code-review-graph >/dev/null && code-review-graph -v || echo "   (!) code-review-graph not on PATH yet — see PATH note above"
command -v graphify          >/dev/null && graphify --version 2>/dev/null || echo "   (!) graphify not on PATH yet — see PATH note above"

echo
echo "==> Optional: register the graphify MCP server (per-user graph file)"
echo "    The graphify skill uses its own MCP server with a graph stored under"
echo "    your home dir. Register it once with:"
echo
echo "      mkdir -p \"\$HOME/.graphify\""
echo "      claude mcp add --scope user graphify graphify-mcp -- \"\$HOME/.graphify/global-graph.json\""
echo
echo "Done. Restart Claude Code (or run /mcp) to pick up the servers."
