#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit
[ -n "$SKIP_HOMEBREW" ] && exit

if type xcode-select >/dev/null; then
    echo "xcode is already installed."
else
    echo "Installing xcode..."
    xcode-select --install
fi

if type brew >/dev/null; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Updating Homebrew..."
brew update

# =====================
#  git
# =====================
brew install git

# =====================
#  mas and brew-file
# =====================
echo "Installing Homebrew apps..."
brew install rcmdnk/file/brew-file
brew install mas

# =====================
#  installing apps
# =====================
echo "Installing Homebrew apps..."
# rm -f "${REPO_DIR}/config/homebrew/Brewfile"
# git clone https://github.com/sugurumorimoto/Brewfile.git "${REPO_DIR}/config/homebrew"
# brew bundle --file="${REPO_DIR}/config/homebrew/Brewfile"

echo "set git repository　git@github.com:sugurumorimoto/Brewfile.git"
brew file set_repo
brew init
brew file install
###########################################################################
# Set Brewfile repository as https://github.com/sugurumorimoto/Brewfile.git
###########################################################################

# =====================
#  python
# =====================
#anyenv
mkdir -p ~/.anyenv/plugins
anyenv init
git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
git clone https://github.com/znz/anyenv-git.git ~/.anyenv/plugins/anyenv-git
git clone https://github.com/amashigeseiji/anyenv-lazyload.git ~/.anyenv/plugins/anyenv-lazyload

#pyenv
pyenv install miniforge3
pyenv global miniforge3
pip install -r "${REPO_DIR}/config/pip/requirements.txt"

#atcoder
brew install nvm
nvm install node
npm install -g npm
npm install -g atcoder-cli
pip3 install --user online-judge-tools

# # OpenCommit
# npm install -g opencommit
# brew services start ollama

# # 使用するモデルを変数で設定
# MODEL_NAME="llama3:8b"
# ollama pull $MODEL_NAME

# # AIプロバイダーをOllamaに設定
# oco config set OCO_AI_PROVIDER='ollama'

# # 使用するモデルを設定
# oco config set OCO_MODEL=$MODEL_NAME

# # APIエンドポイントを設定 (通常はこのままでOK)
# oco config set OCO_API_URL='http://127.0.0.1:11434/api/chat'

# # (オプション) 1行のコミットメッセージを生成する設定
# oco config set OCO_ONE_LINE_COMMIT=true

true
