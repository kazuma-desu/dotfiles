# =============================================================================
#                               Basic Aliases
# =============================================================================

# ls Aliases
alias ls='exa --icons -F -H --group-directories-first --git'
alias l='exa'
alias la='exa -a --icons'
alias ll='exa -lao --smart-group --icons'
alias lt='exa -laT --icons'
alias lr='exa -laR --icons'
alias ld='exa -la --total-size --icons'


# Alternative Commands
alias cat='bat --style=plain'
alias cd='z'
alias vim='nvim'

# =============================================================================
#                               Development
# =============================================================================

alias init-venv='uv venv && source .venv/bin/activate'

# =============================================================================
#                               Kubernetes
# =============================================================================

# Basic kubectl aliases
alias k="kubectl"
alias kctx="kubectl ctx"
alias kns="kubectl ns"
alias kg="kubectl get"
alias kd="kubectl describe"

# Event related aliases
alias kgel='kubectl get events --sort-by=.lastTimestamp'
alias kgec='kubectl get events --sort-by=.metadata.creationTimestamp'

# Get pod's descending events
function kger() {
  kubectl get events --sort-by=.lastTimestamp --field-selector involvedObject.name="$@"
}

# Resource management
alias kgworld='kubectl get $(kubectl api-resources --verbs=list --namespaced -o name | paste -sd ",")'
alias kgnr="kubectl get nodes --no-headers | awk '{print  \$1}' | xargs -I {} sh -c 'echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '"

# Debug tools
alias kdebug="kubectl -n default run debug-$USER --rm -it --tty --image leodotcloud/swiss-army-knife:v0.12 --image-pull-policy=IfNotPresent -- bash"
alias kping='kubectl run httping -it --image bretfisher/httping --image-pull-policy=IfNotPresent --rm=true --'

# Pod management functions
function kgpc() {
  kubectl get pod -o jsonpath="{.spec.containers[*].name}" "$@" && echo ""
}

function kyaml() {
  kubectl get "$@" -o yaml | kubectl-neat
}

# Cleanup
alias krmfailed='kubectl delete pods --field-selector=status.phase=Failed'
