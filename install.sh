#!/usr/bin/env bash

command_exists() {
    type "$1" > /dev/null 2>&1
}

echo "Installing dotfiles."

echo "Initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

# only perform ArchLinux-specific install
if [ -f "/etc/arch-release" ]; then
    echo -e "\\n\\nRunning on ArchLinux"

    source install/pacman.sh
    source install/yaourt.sh
fi

source install/git.sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.nvim/bundle/Vundle.vim

echo "creating vim directories"
mkdir -p ~/.vim-tmp

if ! command_exists zsh; then
    echo "zsh not found. Please install and then re-run installation scripts"
    exit 1
elif ! [[ $SHELL =~ .*zsh.* ]]; then
    echo "Configuring zsh as default shell"
    chsh -s "$(which zsh)"
fi

source install/font.sh

echo "Installing Vundle vim plugins"

nvim +PluginInstall +qall

echo "Done. Reload your terminal."
