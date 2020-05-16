#!/bin/bash

# parse arguments
DO_ALL=false
for arg in "$@"; do
	[ "$arg" == "--all" ] && DO_ALL=true
done

# copy dotfiles to home directory
cd $HOME/.cfg
for cfg in $(ls -A); do
	if [ "$cfg" != ".git" ] && [ "$cfg" != "install.sh" ]; then cp -R $cfg $HOME; fi
done

# determine whether to go through YCM install process
YCM_PATH="$HOME/.vim/plugged/YouCompleteMe"
[ ! -d "$YCM_PATH" ] && YCM_INSTALL=true || YCM_INSTALL=false

# set OS-specific variables
if [[ "$OSTYPE" == "darwin"* ]]; then
	PM="brew"
	YCM_DEPS="cmake macvim python mono go nodejs"

	# on macOS, make sure homebrew is installed
	if ! type "brew" > /dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
else
	PM="sudo apt-get"
	YCM_DEPS="build-essential cmake vim-gtk python3-dev mono-devel golang-go nodejs"

	sudo ln -sf /usr/bin/python3 /usr/local/bin/python3 # an annoying fix for Linux/Mac compat on the YCM setup
fi	

# YCM pre-install
if $YCM_INSTALL || $DO_ALL; then
	yes | $PM install $YCM_DEPS
	yes | $PM upgrade $YCM_DEPS
fi

# install vim plugins
vim +PlugInstall +qall 

# YCM full install
if $YCM_INSTALL || $DO_ALL; then
	cd "$YCM_PATH"
	git submodule update --init --recursive
	python3 install.py --all
fi
