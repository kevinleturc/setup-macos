
# configure allowed open files
ulimit -n 10240

# configure GPG
export GPG_TTY=$(tty)

if type brew &>/dev/null; then
  # configure maven (while waiting for maven 4)
  mvn() {
    $(brew --prefix)/bin/mvn ${MAVEN_ARGS} $@
  }

  # configure nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm

  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"

  # configure direnv
  eval "$(direnv hook zsh)"

  # configure jenv
  export PATH="${HOME}/.jenv/bin:${PATH}"
  eval "$(jenv init -)"

  # configure java options
  export JAVA_TOOL_OPTIONS=-XX:-MaxFDLimit

  # configure kubectl completion
  source <(kubectl completion zsh)

  # configure brew completions
  autoload -Uz compinit
  compinit

  # configure prompt spaceship
  autoload -U promtinit; promptinit
  prompt spaceship
fi

