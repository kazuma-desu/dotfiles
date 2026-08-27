#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists uv; then
    gum style --foreground 99 "Installing uv..."
    gum spin --spinner dot --title "Downloading and installing uv..." -- \
        bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
    gum style --foreground 212 "✓ uv installed successfully!"
else
    gum style --foreground 240 "uv is already installed ($(uv --version))"
fi
