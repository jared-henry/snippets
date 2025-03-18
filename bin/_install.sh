#!/bin/bash
# This script clones your snippets repository, makes the shell scripts in the bin directory executable,
# adds the bin directory to your PATH via your shell config file, and sources the config file to apply the changes.

# -------- CONFIGURATION --------
# Update this URL with your snippets repository URL
REPO_URL="git@github.com:jared-henry/snippets.git"
# Where to clone the repository
TARGET_DIR="$HOME/snippets"
# Directory where your executable scripts are stored
SCRIPTS_DIR="$TARGET_DIR/bin"
# --------------------------------

# Step 1: Clone the repository if it doesn't already exist
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Skipping clone."
else
    echo "Cloning repository from $REPO_URL into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR" || { echo "Error cloning repository"; exit 1; }
fi

# Step 2: Make sure all .sh scripts in the bin directory are executable
if [ -d "$SCRIPTS_DIR" ]; then
    echo "Making all shell scripts in $SCRIPTS_DIR executable..."
    find "$SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;
else
    echo "Warning: $SCRIPTS_DIR does not exist. Please ensure your scripts are stored in a 'bin' directory."
fi

# Step 3: Add the bin directory to your PATH via your shell's config file
# Determine which shell config file to use based on the current shell
case "$SHELL" in
    */zsh)
        CONFIG_FILE="$HOME/.zshrc"
        ;;
    */bash)
        CONFIG_FILE="$HOME/.bashrc"
        ;;
    *)
        # Fallback to .profile if neither bash nor zsh is detected
        CONFIG_FILE="$HOME/.profile"
        ;;
esac

# Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating config file: $CONFIG_FILE"
    touch "$CONFIG_FILE"
fi

# Prepare the PATH addition line.
PATH_LINE="export PATH=\"\$PATH:$SCRIPTS_DIR\""

# Only add the line if it doesn't already exist
if grep -Fq "$SCRIPTS_DIR" "$CONFIG_FILE"; then
    echo "The PATH already includes $SCRIPTS_DIR in $CONFIG_FILE"
else
    echo "Adding scripts directory to PATH in $CONFIG_FILE..."
    echo "" >> "$CONFIG_FILE"
    echo "# Added by snippets setup script on $(date)" >> "$CONFIG_FILE"
    echo "$PATH_LINE" >> "$CONFIG_FILE"
    echo "PATH updated in $CONFIG_FILE"
fi

# Step 4: Source the config file to apply changes immediately
echo "Sourcing $CONFIG_FILE to update PATH..."
# shellcheck source=/dev/null
source "$CONFIG_FILE" || echo "Please restart your terminal to apply changes."

echo "Setup complete. You can now run your scripts from any directory."
