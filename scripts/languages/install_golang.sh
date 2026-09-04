#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists go; then
    gum style --foreground 99 "Installing Go..."

    GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | sed -n '1p')

    if [ -z "$GO_VERSION" ]; then
        echo "Failed to fetch Go version" >&2
        exit 1
    fi

    GO_ARCHIVE="${GO_VERSION}.linux-${ARCH_GO}.tar.gz"

    gum style --foreground 240 "  Version: $GO_VERSION"
    gum spin --spinner dot --title "Downloading Go..." -- \
        wget -q --show-progress -O /tmp/go.tar.gz "https://dl.google.com/go/$GO_ARCHIVE"

    gum style --foreground 240 "  Verifying checksum..."
    EXPECTED=$(
        curl -fsSL "https://go.dev/dl/?mode=json" |
            awk -v target="$GO_ARCHIVE" '
                $1 == "\"filename\":" {
                    filename = $2
                    gsub(/[\",]/, "", filename)
                    matched = (filename == target)
                    next
                }
                matched && $1 == "\"sha256\":" {
                    checksum = $2
                    gsub(/[\",]/, "", checksum)
                    print checksum
                    exit
                }
            '
    )

    if [[ ! "$EXPECTED" =~ ^[0-9a-f]{64}$ ]]; then
        echo "Failed to fetch a valid checksum for $GO_ARCHIVE" >&2
        exit 1
    fi

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
