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

if ! command_exists uv; then
    gum style --foreground 99 "Installing uv..."
    gum spin --spinner dot --title "Downloading and installing uv..." -- \
        bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
    gum style --foreground 212 "✓ uv installed successfully!"
else
    gum style --foreground 240 "uv is already installed ($(uv --version))"
fi
