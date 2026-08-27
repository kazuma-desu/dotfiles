#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists rustc || ! command_exists cargo; then
    gum style --foreground 99 "Installing Rust via rustup..."
    gum spin --spinner dot --title "Downloading and installing Rust..." -- \
        bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path'

    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi

    gum style --foreground 212 "✓ Rust installed successfully!"
else
    gum style --foreground 240 "Rust is already installed (rustc $(rustc --version | cut -d' ' -f2))"
fi
