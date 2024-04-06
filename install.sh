#! /bin/bash

# Define the installation directory with a default value
INSTALL_DIR="${INSTALL_DIR:-$HOME/repos/github.com/sugurumorimoto/dotfiles}"

# Check if the installation directory exists
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    # Navigate to the installation directory and pull the latest changes
    cd "$INSTALL_DIR" || exit
    git pull || { echo "Failed to update dotfiles."; exit 1; }
else
    echo "Installing dotfiles..."
    # Clone the repository to the installation directory
    git clone https://github.com/sugurumorimoto/dotfiles "$INSTALL_DIR" || { echo "Failed to clone dotfiles repository."; exit 1; }
fi

# Execute the setup script
echo "Setting up dotfiles..."
/bin/bash "$INSTALL_DIR/scripts/setup.bash" || { echo "Failed to set up dotfiles."; exit 1; }

echo "Dotfiles setup completed successfully."
