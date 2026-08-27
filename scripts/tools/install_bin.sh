#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Degrade gracefully when gum is not installed
if ! command_exists gum; then
    gum() {
        local cmd="$1"
        shift
        case "$cmd" in
            style)
                while [ $# -gt 0 ]; do
                    case "$1" in
                        --*=*) shift ;;
                        --bold|--italic|--faint|--underline|--strikethrough) shift ;;
                        --*) if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
                        *) break ;;
                    esac
                done
                printf '%s\n' "$*"
                ;;
            spin)
                while [ $# -gt 0 ] && [ "$1" != "--" ]; do shift; done
                [ $# -gt 0 ] && shift
                "$@"
                ;;
            *) return 1 ;;
        esac
    }
fi

case "$(uname -m)" in
    x86_64) BIN_ARCH="amd64" ;;
    aarch64|arm64) BIN_ARCH="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

if ! command_exists bin; then
    gum style --foreground 99 "Installing bin (binary manager)..."

    TMP_DIR=$(mktemp -d)
    trap "rm -rf $TMP_DIR" EXIT

    gum style --foreground 240 "  Detecting latest version..."
    VERSION=$(curl -s https://api.github.com/repos/marcosnils/bin/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$VERSION" ]; then
        echo "Failed to fetch latest version"
        exit 1
    fi

    gum style --foreground 240 "  Version: v$VERSION"
    DOWNLOAD_URL="https://github.com/marcosnils/bin/releases/download/v${VERSION}/bin_${VERSION}_linux_${BIN_ARCH}"

    gum spin --spinner dot --title "Downloading bin..." -- \
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/bin"

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
