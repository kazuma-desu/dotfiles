#!/usr/bin/env bash

# Easier navigation:
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias root="cd /"

# Directory Shortcuts
alias vids="cd ~/Videos"
alias dl="cd ~/Downloads"
alias scripts="cd ~/Scripts"
alias projects="cd ~/Projects"
alias media="cd /media/kavintha/ && ls"
alias toshiba="cd /media/kavintha/Toshiba\ Canvio/ && ls"
alias seagate="cd /media/kavintha/Seagate\ Expansion\ Drive/ && ls"
alias here='nautilus "${pwd}"'

# Custom scripts
alias clear-thumb="sh -c ~/Scripts/Bash/thumbnails.sh"

# Development aliases
alias venv='. ~/Scripts/Python/venv/bin/activate'
alias python='python3.6' #Python 3.6 as default python
alias vscode='/usr/share/code/code --unity-launch'

colorflag="--color=auto"
# ls aliases
alias ll="ls -alF ${colorflag}"
alias la="ls -A ${colorflag}"
alias l="ls -CF ${colorflag}" # List all files colorizied
alias ld="ls -lF  ${colorflag}| grep --color=never '^d'"  # List directories
alias lr="ls -alFR ${colorflag}" # list all file recursively
alias ls="ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
# grep will also always be in case insensitive mode when `grep` is run
alias grep='grep -i --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get Linux Software Updates
alias update='sudo apt update && sudo apt upgrade; sudo apt autoremove'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
# alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# JavaScriptCore REPL
# jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc";
# [ -e "${jscbin}" ] && alias jsc="${jscbin}";
# unset jscbin;

# URL-encode strings
alias urlencode='python -c "import sys, urllib as (ul; print ul.quote_plus(sys.argv[1]));"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="pactl set-sink-volume 0 0%"
alias pumpitup="pactl set-sink-volume 0 100%"
alias raisetheroof="pactl set-sink-volume 0 150%"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# xdg-open to substitute open
alias open='xdg-open'

# Filesizes for humans
alias df='df -h'
alias df='df -h'
