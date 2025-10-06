#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

# Backup existing file if it exists and is not a symlink
backup_if_exists() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup
        backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing file: $file -> $backup"
        mv "$file" "$backup"
    fi
}

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

if [ ! -d "$HOME/.gnupg" ]; then
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
fi


mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_DATA_HOME/vim"

ln -sfv "$REPO_DIR/config/"* "$XDG_CONFIG_HOME"

# Backup existing zsh configuration files before creating symlinks
backup_if_exists "$HOME/.zshenv"
backup_if_exists "$HOME/.zprofile"
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.zshrc.lazy"

ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zprofile" "$HOME/.zprofile"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshrc" "$HOME/.zshrc"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshrc.lazy" "$HOME/.zshrc.lazy"

# Backup existing R configuration files
backup_if_exists "$HOME/.radian_profile"
backup_if_exists "$HOME/.Rprofile"

ln -sfv "$XDG_CONFIG_HOME/R/.radina_profile" "$HOME/.radian_profile"
ln -sfv "$XDG_CONFIG_HOME/R/.Rprofile" "$HOME/.Rprofile"

# Backup existing git configuration files
backup_if_exists "$HOME/.gitignore"

ln -sfv "$XDG_CONFIG_HOME/git/template/commit-template.txt" "$REPO_DIR/.git/commit-template.txt"
ln -sfv "$XDG_CONFIG_HOME/git/ignore" "$HOME/.gitignore"

# Backup existing editor configuration files
backup_if_exists "$HOME/.editorconfig"
backup_if_exists "$HOME/.vim"
backup_if_exists "$HOME/.czrc"

ln -sfv "$XDG_CONFIG_HOME/editorconfig/.editorconfig" "$HOME/.editorconfig"
ln -sfnv "$XDG_CONFIG_HOME/vim" "$HOME/.vim"
ln -sfv "$XDG_CONFIG_HOME/commitizen/.czrc" "$HOME/.czrc"