#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if ! command -v nvim &>/dev/null; then
    echo "Installing Neovim..."
    brew install neovim
fi

# Existing lines
nvim -c ':call clap#installer#download_binary()' -c :q

if [ -d "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" ]; then
    echo "dein.vim is already installed."
    git -C "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" pull

    echo "Updating dein.vim plugins..."
    nvim \
        -c ":call dein#update()" \
        -c ":call clap#installer#download_binary()" \
        -c ":q"
else
    echo "Installing dein.vim..."
    # Use the correct URL for dein.vim installer
    curl -fsSL "https://raw.githubusercontent.com/Shougo/dein.vim/main/bin/installer.sh" | bash -s "$XDG_DATA_HOME/dein"

    echo "Installing dein.vim plugins..."
    nvim \
        -c ":call clap#installer#download_binary()" \
        -c ":q"
fi