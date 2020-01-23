#!/bin/bash

# copy dotfiles to home directory
cd $HOME/.cfg
for cfg in $(ls -A); do
	if [[ $cfg != ".git" ]] && [[ $cfg != "install.sh" ]]; then cp -R $cfg $HOME; fi
done

# source bashrc
source $HOME/.bashrc

# install vim plugins
vim +PlugInstall +qall 

# install YMC vim plugin
if [[ "$OSTYPE" == "darwin"* ]]; then
	if ! type "brew" > /dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi		
	brew install macvim cmake
	brew upgrade macvim cmake
else
	sudo apt install vim-gtk clang cmake curl python python-dev
fi
cd $HOME/.vim/plugged/YouCompleteMe
git submodule update --init --recursive
./install.py --clang-completer --system-libclang
