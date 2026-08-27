#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists fnm; then
    gum style --foreground 99 "Installing fnm (Fast Node Manager)..."
    gum spin --spinner dot --title "Downloading and installing fnm..." -- \
        bash -c 'curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell'
    export PATH="$HOME/.local/bin:$PATH"
    gum style --foreground 212 "✓ fnm installed successfully!"
else
    gum style --foreground 240 "fnm is already installed"
fi

eval "$(fnm env)"

if ! command_exists node; then
    gum style --foreground 99 "Installing Node.js LTS..."
    gum spin --spinner dot --title "Installing Node.js LTS..." -- fnm install --lts
    fnm default lts-latest
    gum style --foreground 212 "✓ Node.js installed successfully! ($(fnm current))"
else
    gum style --foreground 240 "Node.js is already installed ($(node --version))"
fi
