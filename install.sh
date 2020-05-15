#!/bin/bash

# copy dotfiles to home directory
cd $HOME/.cfg
for cfg in $(ls -A); do
	if [ "$cfg" != ".git" ] && [ "$cfg" != "install.sh" ]; then cp -R $cfg $HOME; fi
done

# source bashrc
source $HOME/.bashrc

# determine whether to go through YCM install process
YCM_PATH="$HOME/.vim/plugged/YouCompleteMe"
[ ! -d "$YCM_PATH" ] && YCM_INSTALL=true || YCM_INSTALL=false

# install vim plugins
vim +PlugInstall +qall 

# set OS-specific variables
if [[ "$OSTYPE" == "darwin"* ]]; then
	# on macOS, make sure homebrew is installed
	if ! type "brew" > /dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	PM="brew"
	YCM_DEPS="cmake macvim python mono go nodejs"
else
	PM="sudo apt-get"
	YCM_DEPS="build-essential cmake vim python3-dev mono-devel golang-go nodejs"
fi	

# install YMC vim plugin if not already installed
if $YCM_INSTALL; then
	$PM install $YCM_DEPS
	$PM upgrade $YCM_DEPS
	cd "$YCM_PATH"
	git submodule update --init --recursive
	python3 install.py --all
fi
