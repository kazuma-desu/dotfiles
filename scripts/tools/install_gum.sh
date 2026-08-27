#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists gum; then
    echo "Installing gum locally..."

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    echo "  Detecting latest version..."
    VERSION=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$VERSION" ]; then
        echo "Failed to fetch latest version"
        exit 1
    fi

    echo "  Version: v$VERSION"
    ARCHIVE="gum_${VERSION}_Linux_${ARCH_GNU}.tar.gz"
    DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v${VERSION}/${ARCHIVE}"

    echo "  Downloading gum..."
    curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/gum.tar.gz"

    echo "  Verifying checksum..."
    curl -sL "https://github.com/charmbracelet/gum/releases/download/v${VERSION}/checksums.txt" -o "$TMP_DIR/checksums.txt"
    EXPECTED=$(grep " ${ARCHIVE}$" "$TMP_DIR/checksums.txt" | awk '{print $1}')
    if [ -z "$EXPECTED" ]; then
        echo "Could not find checksum for $ARCHIVE" >&2
        exit 1
    fi
    verify_sha256 "$TMP_DIR/gum.tar.gz" "$EXPECTED"

    echo "  Extracting..."
    tar -xzf "$TMP_DIR/gum.tar.gz" -C "$TMP_DIR"

    mkdir -p "$HOME/.local/bin"
    mv "$TMP_DIR/gum_${VERSION}_Linux_${ARCH_GNU}/gum" "$HOME/.local/bin/gum"
    chmod +x "$HOME/.local/bin/gum"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    echo "✓ gum installed successfully to ~/.local/bin/gum"
    echo "⚠ Ensure ~/.local/bin is in your PATH"
else
    echo "gum is already installed"
fi
