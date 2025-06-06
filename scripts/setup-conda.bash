#!/bin/bash

# Script to recreate conda environments from exported YAML files

# Path to the conda config directory
CONDA_CONFIG_DIR="$(dirname "$0")/../config/conda"

echo "Installing conda environments from YAML files..."

# Check if the conda config directory exists
if [ ! -d "$CONDA_CONFIG_DIR" ]; then
    echo "Error: Config directory $CONDA_CONFIG_DIR does not exist."
    echo "Please run export_conda_envs.bash first to create the YAML files."
    exit 1
fi

# Find all YAML files in the conda config directory
for yaml_file in "$CONDA_CONFIG_DIR"/*_environment.yaml; do
    # Check if the file exists (in case no YAML files are found)
    if [ ! -f "$yaml_file" ]; then
        echo "No YAML files found in $CONDA_CONFIG_DIR"
        break
    fi

    # Extract environment name from filename
    filename=$(basename "$yaml_file")
    env_name="${filename%_environment.yaml}"

    echo "Creating conda environment: $env_name from $yaml_file"

    # Create conda environment from YAML file
    if conda env create -f "$yaml_file" -n "$env_name"; then
        echo "Successfully created environment: $env_name"
    else
        echo "Failed to create environment: $env_name"
        echo "The environment might already exist or there might be package conflicts."
    fi
    echo "---"
done

echo "All installation attempts finished."
