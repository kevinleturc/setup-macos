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
source ~/.zshrc

echo 'Correct permission for insecure directories for completion'
chmod -R go-w "$(brew --prefix)/share"

echo 'Configure tools and home'
mkdir -p ~/.gnupg ~/.m2 ~/.nvm

echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
chmod -R 700 ~/.gnupg
killall gpg-agent
gpg --full-gen-key
echo
echo 'See below the GPG key to add to Github, documentation: https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account'
gpg --armor --export $(gpg -k | grep  -A 1 'pub '| sed 1d | sed 's/ //g')
git config --global gpg.program $(which gpg)
git config --global user.signingkey $(gpg -K --keyid-format SHORT | grep sec | gsed -E 's/.*rsa[^\/]*\/([^ ]+) .+/\1/g')


jenv enable-plugin export

