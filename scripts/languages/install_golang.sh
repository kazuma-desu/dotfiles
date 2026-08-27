#!/usr/bin/env bash

set -euo pipefail

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
    x86_64) GO_ARCH="amd64" ;;
    aarch64|arm64) GO_ARCH="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

if ! command_exists go; then
    gum style --foreground 99 "Installing Go..."

    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1)

    if [ -z "$GO_VERSION" ]; then
        echo "Failed to fetch Go version"
        exit 1
    fi

    gum style --foreground 240 "  Version: $GO_VERSION"
    gum spin --spinner dot --title "Downloading Go..." -- \
        wget -q --show-progress -O /tmp/go.tar.gz "https://dl.google.com/go/$GO_VERSION.linux-$GO_ARCH.tar.gz"

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
