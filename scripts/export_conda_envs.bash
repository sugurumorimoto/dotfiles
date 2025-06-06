#!/bin/bash

# Ensure Conda is initialized (if not, you might need to source <conda_init_script_path>)
# Usually initialized in .bashrc or .zshrc.

# Create config/conda directory if it doesn't exist
mkdir -p "$(dirname "$0")/../config/conda"

echo "Listing Conda environments and exporting to YAML files..."

# Process the output of conda env list to get environment names
# Exclude header lines (# conda environments:) and the '*' indicating the current environment
conda env list | grep -v "^#" | awk '{print $1}' | while read -r env_name; do
    # Check if the environment name is not empty
    if [ -n "$env_name" ]; then
        # Remove '*' if it's part of the environment name
        cleaned_env_name=$(echo "$env_name" | sed 's/\*//g')

        # Also process 'base' environment and environment names that are paths
        # If you want to exclude specific environments, add a conditional branch here
        # (e.g., if [ "$cleaned_env_name" == "base" ]; then continue; fi)

        # Set the YAML file name in config/conda directory
        yaml_file="$(dirname "$0")/../config/conda/${cleaned_env_name}_environment.yaml"

        echo "Exporting environment: $cleaned_env_name to $yaml_file"

        # Export the Conda environment to a YAML file
        conda env export -n "$cleaned_env_name" > "$yaml_file"

        if [ $? -eq 0 ]; then
            echo "Successfully exported $cleaned_env_name to $yaml_file"
        else
            echo "Failed to export $cleaned_env_name. Make sure the environment exists and Conda is configured correctly."
        fi
        echo "---"
    fi
done

echo "All export attempts finished."