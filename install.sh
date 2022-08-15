#!/usr/bin/env zsh -

# Exit when any command fails
set -e

nice_echo () {
  echo
  echo $1
}

# Install Homebrew
nice_echo 'Installing Homebrew'
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Putting Homebrew in PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install from Brewfile
nice_echo 'Installating brew formulaes from Brewfile'
curl -fsSL https://raw.githubusercontent.com/kevinleturc/setup-macos/main/Brewfile | brew bundle --file=-

if type brew &>/dev/null; then
  nice_echo 'Correct permission for insecure directories for completion'
  chmod -R go-w "$(brew --prefix)/share"
fi

# Download .zshrc
nice_echo 'Download .zshrc'
curl -fsSL https://raw.githubusercontent.com/kevinleturc/setup-macos/main/zshrc > ~/.zshrc
source ~/.zshrc

nice_echo 'Configure tools and home'
mkdir -p ~/.gnupg ~/.m2 ~/.nvm

nice_echo 'Download .direnvrc'
curl -fsSL https://raw.githubusercontent.com/kevinleturc/setup-macos/main/direnvrc > ~/.direnvrc

jenv enable-plugin export

nice_echo 'Configure GPG'
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
chmod -R 700 ~/.gnupg
killall gpg-agent || true
gpg --full-gen-key
nice_echo 'See below the GPG key to add to Github, documentation: https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account'
gpg --armor --export $(gpg -k | grep  -A 1 'pub '| sed 1d | sed 's/ //g')
git config --global gpg.program $(which gpg)
git config --global user.signingkey $(gpg -K --keyid-format SHORT | grep sec | gsed -E 's/.*rsa[^\/]*\/([^ ]+) .+/\1/g')

