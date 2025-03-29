# History Configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# History Options
setopt appendhistory     # Append to history file
setopt sharehistory      # Share history between sessions
setopt hist_ignore_space # Don't record commands starting with space
setopt hist_ignore_all_dups # Remove older duplicate entries
setopt hist_save_no_dups # Don't save duplicate entries
setopt hist_ignore_dups  # Don't record duplicates
setopt hist_find_no_dups # When searching history don't display duplicates

# BEEP
unsetopt BEEP
