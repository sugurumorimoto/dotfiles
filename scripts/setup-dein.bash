#!/usr/bin/env bash
set -x

# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

# Check and install Neovim if necessary
if ! command -v nvim &>/dev/null; then
    echo "Neovim not found. Attempting to install Neovim..."
    NEOVIM_FOUND_AFTER_ATTEMPT=false

    # 1. Try Conda
    if command -v conda &>/dev/null; then
        echo "Detected Conda. Attempting to install Neovim using Conda (from conda-forge channel)..."
        if conda install -y -c conda-forge neovim; then
            echo "Conda install command executed."
            if command -v nvim &>/dev/null; then
                NEOVIM_FOUND_AFTER_ATTEMPT=true
                echo "Neovim successfully installed via Conda and is now in PATH."
            else
                echo "Conda install seemed to succeed, but 'nvim' is not found in PATH. Check your Conda environment activation."
            fi
        else
            echo "Conda install command for Neovim failed or was interrupted."
        fi
    else
        echo "Conda not found. Skipping Conda installation attempt."
    fi

    # 2. If nvim still not found by Conda, try OS-specific package managers
    if [ "$NEOVIM_FOUND_AFTER_ATTEMPT" = false ]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "Detected Linux. Attempting to install Neovim using apt-get..."
            if command -v sudo &>/dev/null && sudo -n true 2>/dev/null; then # Check if sudo is available and usable without password prompt
                if sudo apt-get update -y && sudo apt-get install -y neovim; then
                    echo "apt-get install command executed."
                    if command -v nvim &>/dev/null; then
                        NEOVIM_FOUND_AFTER_ATTEMPT=true
                        echo "Neovim successfully installed via apt-get and is now in PATH."
                    else
                        echo "apt-get install for Neovim seemed to succeed, but 'nvim' is not found in PATH."
                    fi
                else
                    echo "apt-get install for Neovim failed."
                fi
            else
                echo "Sudo is not available or requires a password. Cannot use apt-get for Neovim automatically."
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Detected macOS. Attempting to install Neovim using Homebrew..."
            if command -v brew &>/dev/null; then
                if brew install neovim; then
                    echo "Homebrew install command executed."
                    if command -v nvim &>/dev/null; then
                        NEOVIM_FOUND_AFTER_ATTEMPT=true
                        echo "Neovim successfully installed via Homebrew and is now in PATH."
                    else
                        echo "Homebrew install for Neovim seemed to succeed, but 'nvim' is not found in PATH."
                    fi
                else
                    echo "Homebrew install for Neovim failed."
                fi
            else
                echo "Homebrew is not installed. Cannot use brew for Neovim automatically on macOS."
            fi
        fi
    fi

    # 3. Final verification after all attempts
    if [ "$NEOVIM_FOUND_AFTER_ATTEMPT" = false ] && ! command -v nvim &>/dev/null; then
        echo "---------------------------------------------------------------------"
        echo "Automatic Neovim installation failed or 'nvim' is still not in your PATH after attempts."
        echo "Please install Neovim manually and ensure 'nvim' is in your PATH."
        echo "You can try one of the following methods:"
        echo "  - Conda: conda install -c conda-forge neovim"
        echo "  - Linux (apt): sudo apt-get install neovim"
        echo "  - macOS (brew): brew install neovim"
        echo "  - AppImage (Linux): Download from Neovim's GitHub releases, make executable, and place in PATH."
        echo "  - From source: See Neovim's official documentation."
        echo "After manual installation, please re-run this script."
        echo "---------------------------------------------------------------------"
        exit 1
    elif command -v nvim &>/dev/null; then
        echo "Neovim is now available."
    fi
else
    echo "Neovim is already installed."
fi

# Ensure nvim command is available before proceeding
if ! command -v nvim &>/dev/null; then
    echo "Critical error: Neovim is not installed or not in PATH. Aborting further setup."
    exit 1
fi

# Existing lines - consider making nvim calls more robust
nvim -c ':silent! call clap#installer#download_binary()' -c ':qall!'

if [ -d "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" ]; then
    echo "dein.vim is already installed."
    git -C "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" pull

    echo "Updating dein.vim plugins..."
    nvim \
        -c ":silent! call dein#update()" \
        -c ":silent! call clap#installer#download_binary()" \
        -c ":qall!"
else
    echo "Installing dein.vim..."
    # Use the correct URL for dein.vim installer
    curl -fsSL "https://raw.githubusercontent.com/Shougo/dein.vim/main/bin/installer.sh" | bash -s "$XDG_DATA_HOME/dein"

    echo "Installing dein.vim plugins..."
    nvim \
        -c ":silent! call dein#install()" \
        -c ":silent! call clap#installer#download_binary()" \
        -c ":qall!"
fi