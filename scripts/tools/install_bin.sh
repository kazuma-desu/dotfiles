#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists bin; then
    gum style --foreground 99 "Installing bin (binary manager)..."

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    gum style --foreground 240 "  Detecting latest version..."
    VERSION=$(curl -s https://api.github.com/repos/marcosnils/bin/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$VERSION" ]; then
        echo "Failed to fetch latest version"
        exit 1
    fi

    gum style --foreground 240 "  Version: v$VERSION"
    ARCHIVE="bin_${VERSION}_linux_${ARCH_GO}"
    DOWNLOAD_URL="https://github.com/marcosnils/bin/releases/download/v${VERSION}/${ARCHIVE}"

    gum spin --spinner dot --title "Downloading bin..." -- \
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/bin"

    gum style --foreground 240 "  Verifying checksum..."
    curl -sL "https://github.com/marcosnils/bin/releases/download/v${VERSION}/checksums.txt" -o "$TMP_DIR/checksums.txt"
    EXPECTED=$(grep " ${ARCHIVE}$" "$TMP_DIR/checksums.txt" | awk '{print $1}')
    if [ -z "$EXPECTED" ]; then
        echo "Could not find checksum for $ARCHIVE" >&2
        exit 1
    fi
    verify_sha256 "$TMP_DIR/bin" "$EXPECTED"

    chmod +x "$TMP_DIR/bin"

    BIN_CONFIG="$DOTFILES_DIR/.config/bin/config.json"

    if [ ! -f "$BIN_CONFIG" ]; then
        mkdir -p "$(dirname "$BIN_CONFIG")"
        cat > "$BIN_CONFIG" <<EOF
{
  "default_path": "$HOME/.local/bin",
  "bins": {}
}
EOF
        gum style --foreground 240 "  Created config at $BIN_CONFIG"
    fi

    export BIN_CONF="$BIN_CONFIG"

    gum style --foreground 240 "  Bootstrapping bin to manage itself..."
    "$TMP_DIR/bin" install github.com/marcosnils/bin
    echo ""

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if command_exists bin && BIN_CONF="$BIN_CONFIG" bin ls >/dev/null 2>&1; then
        gum style --foreground 212 "✓ bin installed successfully!"
        gum style --foreground 240 "  Config: $BIN_CONFIG"
        gum style --foreground 214 "⚠ Set BIN_CONF=$BIN_CONFIG in your shell config"
    else
        echo "Installation verification failed. Please check your PATH includes ~/.local/bin"
        exit 1
    fi
else
    gum style --foreground 240 "bin is already installed"
fi
