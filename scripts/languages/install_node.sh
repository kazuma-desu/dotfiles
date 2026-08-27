#!/usr/bin/env bash

set -euo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Degrade gracefully when gum is not installed
if command_exists gum; then
    HAVE_GUM=1
else
    HAVE_GUM=0
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

if ! command_exists fnm; then
    gum style --foreground 99 "Installing fnm (Fast Node Manager)..."
    gum spin --spinner dot --title "Downloading and installing fnm..." -- \
        bash -c 'curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell'
    export PATH="$HOME/.local/bin:$PATH"
    gum style --foreground 212 "✓ fnm installed successfully!"
else
    gum style --foreground 240 "fnm is already installed"
fi

eval "$(fnm env)"

if ! command_exists node; then
    gum style --foreground 99 "Installing Node.js LTS..."
    gum spin --spinner dot --title "Installing Node.js LTS..." -- fnm install --lts
    fnm default lts-latest
    gum style --foreground 212 "✓ Node.js installed successfully! ($(fnm current))"
else
    gum style --foreground 240 "Node.js is already installed ($(node --version))"
fi
