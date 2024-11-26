#!/bin/bash

# Set script to exit on error
set -e

echo "================================================================"
echo "                 STARTING TESTKUBE PLUGIN BUILD                    "
echo "================================================================"
echo "Timestamp: $(date)"

# Store the script's directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "Loading environment variables from .env file"
    source "$SCRIPT_DIR/.env"
else
    echo "Error: .env file not found in $SCRIPT_DIR"
    exit 1
fi

# Check if TESTKUBE_PLUGIN_DIR is set
if [ -z "$TESTKUBE_PLUGIN_DIR" ]; then
    echo "Error: TESTKUBE_PLUGIN_DIR environment variable is not set"
    exit 1
fi

# Check if plugin directory exists
if [ ! -d "$TESTKUBE_PLUGIN_DIR" ]; then
    echo "Error: Plugin directory does not exist: $TESTKUBE_PLUGIN_DIR"
    exit 1
fi

echo "Building plugin from: $TESTKUBE_PLUGIN_DIR"
echo "----------------------------------------------------------------"

# Run maven package command from the plugin directory
(cd "$TESTKUBE_PLUGIN_DIR" && JAVA_HOME=/opt/homebrew/opt/openjdk@17 mvn package)

echo "----------------------------------------------------------------"
echo "Build completed. Copying plugin to init_plugins directory"

# Create init_plugins directory if it doesn't exist
mkdir -p "$SCRIPT_DIR/init_plugins"

# Copy the built plugin to init_plugins
cp "$TESTKUBE_PLUGIN_DIR/target/testkube-cli.hpi" "$SCRIPT_DIR/init_plugins/"

echo "Plugin copied to: $SCRIPT_DIR/init_plugins/testkube-cli.hpi"
echo "================================================================"
echo "                 FINISHED TESTKUBE PLUGIN BUILD                    "
echo "                 Timestamp: $(date)"
echo "================================================================"

echo "Starting Jenkins container..."
docker compose up
