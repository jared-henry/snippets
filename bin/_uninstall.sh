#!/bin/bash
# This script reverses the changes made by _install.sh:
# - It removes the PATH modification from your shell config file.
# - It deletes the cloned repository directory.

# -------- CONFIGURATION --------
TARGET_DIR="$HOME/snippets"
SCRIPTS_DIR="$TARGET_DIR/bin"
# --------------------------------

# Determine which shell config file to use based on the current shell
case "$SHELL" in
    */zsh)
        CONFIG_FILE="$HOME/.zshrc"
        ;;
    */bash)
        CONFIG_FILE="$HOME/.bashrc"
        ;;
    *)
        CONFIG_FILE="$HOME/.profile"
        ;;
esac

echo "Removing PATH modifications from $CONFIG_FILE..."

# Remove the comment added by install.sh (which includes "Added by snippets setup script")
sed -i.bak '/# Added by snippets setup script/d' "$CONFIG_FILE"
# Remove any line that adds SCRIPTS_DIR to PATH (uses an alternate delimiter to avoid issues with slashes)
sed -i.bak "\#$SCRIPTS_DIR#d" "$CONFIG_FILE"

echo "PATH modifications removed from $CONFIG_FILE."

# Delete the cloned repository directory if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "Deleting the cloned repository at $TARGET_DIR..."
    rm -rf "$TARGET_DIR"
    echo "Repository deleted."
else
    echo "Repository directory $TARGET_DIR not found. Nothing to delete."
fi

# Source the configuration file to update the PATH immediately
echo "Sourcing $CONFIG_FILE to update PATH..."
# shellcheck source=/dev/null
source "$CONFIG_FILE" || echo "Please restart your terminal to apply changes."

echo "Uninstallation complete."