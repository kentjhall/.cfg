# parse arguments
DO_ALL=false
for arg in "$@"; do
	[ "$arg" == "--all" ] && DO_ALL=true
done

# copy dotfiles to home directory
cd "$HOME/.cfg"
for cfg in $(ls -A --color=never); do
	case "$cfg" in
		.git | sourceme.sh | host-specific)
			;;
		*)
			cp -R "$cfg" "$HOME"
			;;
	esac
done

# copy any host-specific dotfiles
HSP_PATH="host-specific/$HOSTNAME"
[ -d "$HSP_PATH" ] && for cfg in $(ls -A --color=never "$HSP_PATH"); do cp -R "$HSP_PATH/$cfg" "$HOME"; done

# source the copied bashrc
. "$HOME/.bashrc"

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

# determine whether to go through YCM install process
YCM_PATH="$HOME/.vim/plugged/YouCompleteMe"
[ ! -d "$YCM_PATH" ] && YCM_INSTALL=true || YCM_INSTALL=false

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
