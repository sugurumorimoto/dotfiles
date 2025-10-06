# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

### zinit ###
typeset -gAH ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
ZINIT[ZCOMPDUMP_PATH]="$XDG_STATE_HOME/zcompdump"

### paths ###
typeset -U path
typeset -U fpath

# Align zinit's primary data locations with the XDG Base Directory specification

path=(
    "/usr/local/bin(N-/)"
    "$HOME/.local/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
# Direct PATH and FPATH toward XDG directories and tool-specific bin folders
    "$GOPATH/bin"(N-/)
    "$DENO_INSTALL/bin"(N-/)
    "$GEM_HOME/bin"(N-/)
    "$XDG_CONFIG_HOME/scripts/bin"(N-/)
    "$path[@]"
)

fpath=(
    "$XDG_DATA_HOME/zsh/completions"(N-/)
    "$fpath[@]"
)

### Added by Zinit's installer
if [[ ! -f ${ZINIT[HOME_DIR]}/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${ZINIT[HOME_DIR]}" && command chmod g-rwX "${ZINIT[HOME_DIR]}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT[HOME_DIR]}/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Automatically clone zinit if it is not yet installed

source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)

zinit light-mode for \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-bin-gem-node
### End of Zinit's installer chunk

### theme ###
# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# Prezto setup
# zinit ice wait'!0'; zinit snippet PZT::modules/helper/init.zsh
# zinit ice wait'!0'; zinit snippet PZT::modules/history/init.zsh ### history ###
zinit snippet PZT::modules/helper/init.zsh
zinit snippet PZT::modules/history/init.zsh

# Defer loading the pure theme and its async support
export HISTFILE="$XDG_STATE_HOME/zsh_history"

# Ref: https://www.m3tech.blog/entry/dotfiles-bonsai
zshaddhistory() {
    local line="${1%%$'\n'}"
# Use only the helper and history modules
    [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir)($| )" ]]
}

# cd shortcuts
zinit snippet PZT::modules/directory/init.zsh
setopt AUTO_CD                # ディレクトリ名だけを入力した時にそこに cd する

#abbrev-alias
zinit light momo-lab/zsh-abbrev-alias

# Finder helpers
zinit snippet OMZ::plugins/macos/macos.plugin.zsh

# anyframe setup
# Plugin that auto-expands shorthand commands
zinit light mollifier/anyframe

# Show directory history with peco
# Provide macOS-specific helper functions
bindkey '^wf' anyframe-widget-cdr
bindkey '^wd' anyframe-widget-execute-history

# Turn history and directory changes into peco widgets
### plugins ###
zinit wait lucid null for \
    atinit'source "$XDG_CONFIG_HOME/zsh/.zshrc.lazy"' \
    @'zdharma-continuum/null'

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Create tmux session connection
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

# export PATH=/Users/morimotosuguru/edirect:${PATH}

# Add SSH keys to the ssh-agent
for key in $HOME/.ssh/*; do
  if [[ -f "$key" && "$key" != *.pub ]]; then
    ssh-add --apple-use-keychain "$key" 2>/dev/null
  fi
done

# Add private SSH keys with macOS keychain support
