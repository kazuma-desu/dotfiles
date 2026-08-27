#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists go; then
    gum style --foreground 99 "Installing Go..."

    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1)

    if [ -z "$GO_VERSION" ]; then
        echo "Failed to fetch Go version"
        exit 1
    fi

    gum style --foreground 240 "  Version: $GO_VERSION"
    gum spin --spinner dot --title "Downloading Go..." -- \
        wget -q --show-progress -O /tmp/go.tar.gz "https://dl.google.com/go/$GO_VERSION.linux-$ARCH_GO.tar.gz"

    gum style --foreground 240 "  Verifying checksum..."
    EXPECTED=$(curl -s "https://go.dev/dl/${GO_VERSION}.linux-${ARCH_GO}.sha256")
    verify_sha256 /tmp/go.tar.gz "$EXPECTED"

    rm -rf ~/.local/go
    mkdir -p ~/.local

    gum spin --spinner dot --title "Extracting Go..." -- \
        tar -C ~/.local -xzf /tmp/go.tar.gz

    rm /tmp/go.tar.gz

    gum style --foreground 212 "✓ Go installed successfully!"
    gum style --foreground 214 "⚠ Ensure ~/.local/go/bin is in your PATH"
else
    gum style --foreground 240 "Go is already installed ($(go version))"
fi
