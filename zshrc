
# configure jenv
export PATH="${HOME}/.jenv/bin:${PATH}"
eval "$(jenv init -)"

# configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"

  # configure brew completions
  autoload -Uz compinit
  compinit

  # configure prompt spaceship
  autoload -U promtinit; promptinit
  prompt spaceship
fi

