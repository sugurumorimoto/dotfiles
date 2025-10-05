# dotfiles

![](https://github.com/sugurumorimoto/dotfiles/workflows/Ubuntu/badge.svg)
![](https://github.com/sugurumorimoto/dotfiles/workflows/macOS/badge.svg)
![](https://github.com/sugurumorimoto/dotfiles/workflows/Lint/badge.svg)

Personal dotfiles for macOS and Linux development environments. This repository includes configurations for zsh, tmux, vim/nvim, git, and various CLI tools.

## Features

- **Shell Configuration**: Enhanced zsh setup with zinit plugin manager, pure theme, and custom aliases
- **Terminal Multiplexer**: Comprehensive tmux configuration with custom key bindings and plugins
- **Editor Setup**: Vim/Neovim configurations with dein.vim plugin manager
- **Git Integration**: Modular git configuration with aliases, delta diff viewer, and forgit
- **Development Tools**: Configs for asdf, conda, homebrew, and language-specific tools
- **XDG Compliance**: Follows XDG Base Directory specification for organized config files

## Installation

### Quick Install

```shell
curl -fsSL https://raw.githubusercontent.com/sugurumorimoto/dotfiles/master/install.sh | sh
```

### Manual Install

```shell
# Clone the repository
git clone https://github.com/sugurumorimoto/dotfiles.git ~/repos/github.com/sugurumorimoto/dotfiles

# Run the setup script
cd ~/repos/github.com/sugurumorimoto/dotfiles
bash scripts/setup.bash
```

## Repository Structure

```text
config/           # Application configurations
├── zsh/          # Zsh shell configuration
├── tmux/         # Tmux terminal multiplexer
├── nvim/         # Neovim editor
├── git/          # Git version control
├── alacritty/    # Alacritty terminal emulator
├── homebrew/     # Homebrew package manager
└── ...           # Other tool configs

scripts/          # Setup and utility scripts
├── setup.bash    # Main setup orchestrator
├── setup-*.bash  # Individual component installers
└── common.bash   # Shared functions

install.sh        # Installation entry point
```

## Configuration Highlights

### Zsh

- **Plugin Manager**: zinit for fast, flexible plugin loading
- **Theme**: Pure prompt for a clean, informative shell
- **Enhancements**: Directory history (cdr), fuzzy finding (fzf/peco), abbreviation expansion
- **Tools**: Integration with bat, ripgrep, fd, eza for modern CLI experience

### Tmux

- **Prefix**: `Ctrl-j` (instead of default `Ctrl-b`)
- **Status Bar**: Customized with icons and system information
- **Plugins**: tmux-yank, tmux-open, tmux-resurrect, tmux-continuum
- **Key Bindings**: Intuitive pane and window navigation

### Git

- **Modular Config**: Split configuration files in `conf.d/` for easy management
- **Delta**: Syntax-highlighted diff viewer
- **Aliases**: Extensive shortcuts for common operations
- **Tools**: Integration with ghq, forgit, and GitHub CLI

## Requirements

### macOS

- Homebrew (installed automatically by setup script)
- Xcode Command Line Tools

### Linux

- apt-based distribution (Ubuntu, Debian)
- Git, curl, and build-essential

## Customization

### Local Overrides

Create these files to add machine-specific configurations:

- `config/git/conf.d/local.conf` - Git settings not in version control
- `config/espanso/user/local.yml` - Text expansion snippets
- `config/zsh/.zshrc.local` - Local shell customizations

### Environment Variables

Set these before installation to customize behavior:

```shell
export INSTALL_DIR="$HOME/custom/path"  # Default: ~/repos/github.com/sugurumorimoto/dotfiles
```

## Updating

Re-run the installation script to pull the latest changes:

```shell
bash ~/repos/github.com/sugurumorimoto/dotfiles/scripts/setup.bash
```

## License

See [LICENSE.md](LICENSE.md) for details.

## Acknowledgments

Inspired by various dotfiles repositories and best practices from the community.
