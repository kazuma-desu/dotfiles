# =============================================================================
#                               Zinit Setup
# =============================================================================

# Set the directory for zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
#                               Helper Functions
# =============================================================================

# Function to source a config file with warning if not found
source_config() {
    local file=$1
    local description=$2
    if [[ -f $file ]]; then
        source "$file"
    else
        echo "\033[33mWarning:\033[0m ${description} configuration not found at ${file}"
    fi
}

# =============================================================================
#                               Load Configurations
# =============================================================================

# Load configurations in specific order
source_config ~/.zsh/path.zsh "Path"                     # Path should be first
source_config ~/.zsh/plugins.zsh "Plugins"               # Plugins need to be loaded before completion
source_config ~/.zsh/options.zsh "Options"               # History settings
source_config ~/.zsh/completion.zsh "Completion"         # Completion settings and keybindings
source_config ~/.zsh/aliases.zsh "Aliases"               # Load aliases last
source_config ~/.zsh/functions.zsh "Functions"           # Custom functions

# =============================================================================
#                               Final Configurations
# =============================================================================

# Atuin shell history (installed via cargo)
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# FZF
command -v fzf &>/dev/null && eval "$(fzf --zsh)"

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# fnm (Fast Node Manager)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Envman configuration
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


PATH=~/.console-ninja/.bin:$PATH
# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Pi
export PATH="/home/kazuma/.npm-global/bin:$PATH"

# kimi-code
export PATH="/home/kazuma/.kimi-code/bin:$PATH"
