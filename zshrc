# ZSH Settings
autoload -Uz compinit
compinit 
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Path Settings
export PATH=$HOME/go/bin:/usr/local/Frameworks/Python.framework/Versions/3.8/bin:/usr/local/opt/ruby/bin:$PATH

# You may need to manually set your language environment
export LANG=en_AU.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'
alias vi=vim

# Python Environment Setup
alias python=python3
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
source /usr/local/bin/virtualenvwrapper.sh

# Fuck configuration
eval $(thefuck --alias)

# Kops configuration
activate-kops() {
    source ~/.kopsrc
}

# Add additional user scripts
export PATH=$HOME/bin:$PATH

# AWS Useful Aliases
alias whoiam='aws sts get-caller-identity'

# Brazil Toolbox Path
export PATH=$HOME/.toolbox/bin:$PATH

# Firefox Bin Path
export PATH=/Applications/Firefox.app/Contents/MacOS:$PATH

# Powerline
source /usr/local/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh

# SCM Breeze
[ -s "/Users/bertiet/.scm_breeze/scm_breeze.sh" ] && source "/Users/bertiet/.scm_breeze/scm_breeze.sh"
