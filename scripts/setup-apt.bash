#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if ! command -v apt-get >/dev/null; then
    echo "apt-get not found, skipping setup."
    exit 0
fi

#sudo /bin/sh "$REPO_DIR/config/apt/install.sh"
