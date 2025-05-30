# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### zinit ###
typeset -gAH ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
ZINIT[ZCOMPDUMP_PATH]="$XDG_STATE_HOME/zcompdump"

### paths ###
typeset -U path
typeset -U fpath

path=(
    "/usr/local/bin(N-/)"
    "$HOME/.local/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
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
zinit ice wait'!0';zplugin ice pick"async.zsh" src "pure.zsh"
zinit ice wait'!0';zplugin light sindresorhus/pure

# Preztoのセットアップ
zinit ice wait'!0'; zinit snippet PZT::modules/helper/init.zsh
zinit ice wait'!0'; zinit snippet PZT::modules/history/init.zsh ### history ###
export HISTFILE="$XDG_STATE_HOME/zsh_history"
#ref;https://www.m3tech.blog/entry/dotfiles-bonsai
zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir|brew)($| )" ]]
}

#cd
zinit ice wait'!0'; zinit snippet PZT::modules/directory/init.zsh
setopt AUTO_CD                # ディレクトリ名だけを入力した時にそこに cd する

#abbrev-alias
zinit light momo-lab/zsh-abbrev-alias

#finder
zinit ice wait'!0'; zinit snippet OMZ::plugins/macos/macos.plugin.zsh

# anyframeのセットアップ
zinit light mollifier/anyframe
# Ctrl+x -> b
# peco でディレクトリの移動履歴を表示
bindkey '^wf' anyframe-widget-cdr
bindkey '^wd' anyframe-widget-execute-history

### plugins ###
zinit wait lucid null for \
    atinit'source "$XDG_CONFIG_HOME/zsh/.zshrc.lazy"' \
    @'zdharma-continuum/null'

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# tmux session connection
# if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
#     tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
# fi
export PATH=/Users/morimotosuguru/edirect:${PATH}
