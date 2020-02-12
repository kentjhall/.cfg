#!/bin/bash

# copy dotfiles to home directory
cd $HOME/.cfg
for cfg in $(ls -A); do
	if [[ $cfg != ".git" ]] && [[ $cfg != "install.sh" ]]; then cp -R $cfg $HOME; fi
done

# source bashrc
source $HOME/.bashrc

# check if YCM is already installed
YCM_PATH="$HOME/.vim/plugged/YouCompleteMe"
ycm_installed=true
if [ ! -d $YCM_PATH ]; then
	ycm_installed=false
fi

# install vim plugins
vim +PlugInstall +qall 

# install YMC vim plugin if not already installed
if [ $ycm_installed != "true" ]; then
	if [[ "$OSTYPE" == "darwin"* ]]; then
		if ! type "brew" > /dev/null; then
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi		
		brew install macvim cmake
		brew upgrade macvim cmake
	else
		sudo apt install vim-gtk clang cmake curl python python-dev
	fi
	cd $YCM_PATH
	git submodule update --init --recursive
	./install.py --clang-completer --system-libclang
fi
