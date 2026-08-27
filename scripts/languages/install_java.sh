#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Override with JAVA_VERSION env var; check candidates with: sdk list java
JAVA_VERSION="${JAVA_VERSION:-21.0.5-tem}"

init_sdkman() {
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

if [ ! -d "$HOME/.sdkman" ]; then
    gum style --foreground 99 "Installing SDKMAN..."
    gum spin --spinner dot --title "Downloading and installing SDKMAN..." -- \
        bash -c 'curl -s "https://get.sdkman.io" | bash'
    gum style --foreground 212 "✓ SDKMAN installed successfully!"
else
    gum style --foreground 240 "SDKMAN is already installed"
fi

init_sdkman

if ! command_exists java; then
    gum style --foreground 99 "Installing Java $JAVA_VERSION via SDKMAN (this may take a while)..."
    sdkman_auto_answer=true sdk install java "$JAVA_VERSION"
    gum style --foreground 212 "✓ Java installed successfully!"
else
    gum style --foreground 240 "Java is already installed ($(java -version 2>&1 | head -1))"
fi
