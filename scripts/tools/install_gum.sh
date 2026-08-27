#!/usr/bin/env bash

set -euo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

case "$(uname -m)" in
    x86_64) GUM_ARCH="x86_64" ;;
    aarch64|arm64) GUM_ARCH="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

if ! command_exists gum; then
    echo "Installing gum locally..."

    TMP_DIR=$(mktemp -d)
    trap "rm -rf $TMP_DIR" EXIT

    echo "  Detecting latest version..."
    VERSION=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$VERSION" ]; then
        echo "Failed to fetch latest version"
        exit 1
    fi

    echo "  Version: v$VERSION"
    DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v${VERSION}/gum_${VERSION}_Linux_${GUM_ARCH}.tar.gz"

    echo "  Downloading gum..."
    curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/gum.tar.gz"

    echo "  Extracting..."
    tar -xzf "$TMP_DIR/gum.tar.gz" -C "$TMP_DIR"

    mkdir -p "$HOME/.local/bin"
    mv "$TMP_DIR/gum_${VERSION}_Linux_${GUM_ARCH}/gum" "$HOME/.local/bin/gum"
    chmod +x "$HOME/.local/bin/gum"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    echo "✓ gum installed successfully to ~/.local/bin/gum"
    echo "⚠ Ensure ~/.local/bin is in your PATH"
else
    echo "gum is already installed"
fi
