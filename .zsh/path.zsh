
# =============================================================================
#                               Path Configuration
# =============================================================================

# Core paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim/"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Tool-specific paths
export PATH="$HOME/.linkerd2/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

