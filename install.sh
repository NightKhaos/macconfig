#!/bin/bash -e

# This script will install the needed prerequisites and configuration files

## Script Setup
BREW_PACKAGES_PATH=$(dirname $0)/packages.brew
CASK_PACKAGES_PATH=$(dirname $0)/cask.brew
PYTHON_REQUIREMENTS=$(dirname $0)/python.requirements
POWERSHELL_MODULES_PATH=$(dirname $0)/powershell.packages
NPM_MODULES_PATH=$(dirname $0)/packages.npm
ZSHRC_SOURCE=$(dirname $0)/00-macosx.rc
SKHD_SOURCE=$(dirname 0)/skhdrc
KOPSRC_SOURCE=$HOME/.secmacconfig/kopsrc
YABAIRC_SOURCE=$(dirname $0)/yabairc
SECURE_MAC_CONFIG_SCRIPT=$HOME/.secmacconfig/install.sh
SSH_CONFIG=$(dirname $0)/config.ssh

# TODO: Separate out Powerline like vimrc so it can be consumed by other environments

# Make sure we're in an interactive shell
if ! tty
then
    echo "Must be in an interactive TTY" >&2
    exit 1
fi

# Install Homebrew:

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Upgrade Homebrew package
brew upgrade

# Install required packages
[ -e "$BREW_PACKAGES_PATH" ] && grep -Ev '(#.*$)|(^$)' "$BREW_PACKAGES_PATH" | xargs brew install

# Install cask packages
[ -e "$CASK_PACKAGES_PATH" ] && grep -Ev '(#.*$)|(^$)' "$CASK_PACKAGES_PATH" | xargs brew cask install

# Install Required Python3 packages
[ -e "$PYTHON_REQUIREMENTS" ] && sudo pip3 install -r "$PYTHON_REQUIREMENTS"

# Install Powershell packages
[ -e "$POWERSHELL_MODULES_PATH" ] && grep -Ev '(#.*$)|(^$)' "$POWERSHELL_MODULES_PATH" | xargs -I {} -n1 pwsh -c "Install-Module -Name {} -AllowClobber -Force"

# Install NPM packages
[ -e "$NPM_MODULES_PATH" ] && grep -Ev '(#.*$)|(^$)' "$NPM_MODULES_PATH" | xargs -n1 npm install -g

# Install git libraries
[ -d "$HOME/.vim" ] || git clone --recursive https://github.com/NightKhaos/vimrc.git "$HOME/.vim"
[ -d "$HOME/.scm_breeze" ] || git clone https://github.com/ndbroadbent/scm_breeze.git "$HOME/.scm_breeze"
[ -d "$HOME/.shellconfig" ] || git clone https://github.com/NightKhaos/.shellconfig.git "$HOME/.shellconfig"

# Configure Shell
[ -e "$HOME/.shellconfig/requirements.txt" ] && sudo pip3 install -r "$HOME/.shellconfig/requirements.txt"
[ -e "$HOME/.shellconfig/install.sh" ] && "$HOME/.shellconfig/install.sh"

# Link the ZSH config file
[ -e "$HOME/.zsh" ] && ln -s $ZSHRC_SOURCE "$HOME/.zsh/" || true

# Install vim plugins
/usr/local/bin/mvim +PluginInstall +qall

# Install configuration files
[ -e "$HOME/.vimrc" ] || ln -s "$HOME/.vim/vimrc" "$HOME/.vimrc"
[ -e "$KOPSRC_SOURCE" ] && ( [ -e "$HOME/.kopsrc" ] || ln -s "$KOPSRC_SOURCE" "$HOME/.kopsrc" )
[ -e "$YABAIRC_SOURCE" ] && ( [ -e "$HOME/.yabairc" ] || ln -s "$YABAIRC_SOURCE" "$HOME/.yabairc" )
[ -e "$SKHD_SOURCE" ] && ( [ -e "$HOME/.skhdrc" ] || ln -s "$SKHD_SOURCE" "$HOME/.skhdrc" )

# Install config files that need to be appendable
mkdir -p "$HOME/.s"
mkdir -p "$HOME/.ssh"
[ -e "$SSH_CONFIG" ] && ( [ -e "$HOME/.ssh/config" ] || cp "$SSH_CONFIG" "$HOME/.ssh/config" )

# Install Secure Mac Config Settings
[ -e "$SECURE_MAC_CONFIG_SCRIPT" ] && $SECURE_MAC_CONFIG_SCRIPT

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# ALL DONE
echo "ALL DONE!"
