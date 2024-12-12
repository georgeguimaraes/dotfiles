# Default FZF options with TokyoNight colors
export FZF_DEFAULT_OPTS='
--color=dark
--color=fg:#c0caf5,bg:#24283b,hl:#ff9e64
--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
--height=70% --layout=reverse --border'

# Preview setup
FZF_DEFAULT_PREVIEW='[[ -d {} ]] && eza --tree --color=always {} || bat -n --color=always --line-range :500 {}'
export FZF_CTRL_T_OPTS="--preview '$FZF_DEFAULT_PREVIEW'"
export FZF_ALT_C_OPTS="--preview '$FZF_DEFAULT_PREVIEW'"

# Default commands
FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=d"

# Use fd for listing path candidates
# $1 is the base path to start traversal
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# First argument is the name of the command
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview $FZF_DEFAULT_PREVIEW "$@" ;;
  esac
}

# Initialize FZF
eval "$(fzf --zsh)"
source ~/.fzf/fzf-git.sh/fzf-git.sh
