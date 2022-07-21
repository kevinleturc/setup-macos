#!/usr/bin/env bash -i

# Exit when any command fails
set -e

# Install Homebrew
echo 'Installing Homebrew'
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Putting Homebrew in PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install from Brewfile
echo 'Installating brew formulaes from Brewfile'
curl -fsSL https://raw.githubusercontent.com/kevinleturc/setup-macos/main/Brewfile | brew bundle --file=-

# Download .zshrc
echo 'Download .zshrc'
curl -fsSL https://raw.githubusercontent.com/kevinleturc/setup-macos/main/zshrc > ~/.zshrc

echo 'Correct permission for insecure directories for completion'
chmod -R go-w "$(brew --prefix)/share"

echo 'Configure tools and home'
mkdir ~/.m2 ~/.nvm

