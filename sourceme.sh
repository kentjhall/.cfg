# set OS-specific variables
if [[ "$OSTYPE" == "darwin"* ]]; then
	LS_OPTS="-A"
	PM="brew"
	YCM_DEPS="cmake macvim python mono go nodejs"

	# on macOS, make sure homebrew is installed
	if ! type "brew" > /dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
else
	LS_OPTS="-A --color=never"
	PM="sudo apt-get"
	YCM_DEPS="build-essential cmake vim-gtk python3-dev mono-devel golang-go nodejs"

	sudo ln -sf /usr/bin/python3 /usr/local/bin/python3 # an annoying fix for Linux/Mac compat on the YCM setup
fi	

# parse arguments
FULL_INSTALL=false
for arg in "$@"; do
	case "$arg" in
		--full)
			FULL_INSTALL=true
			;;
	esac
done

# copy dotfiles to home directory
START_PWD="$PWD"
cd "$(dirname $BASH_SOURCE)" 
for cfg in $(ls $LS_OPTS); do
	case "$cfg" in
		.git | sourceme.sh | host-specific)
			;;
		*)
			cp -R "$cfg" "$HOME"
			;;
	esac
done

# copy any machine-specific dotfiles
HSP_PATH="host-specific/$HOSTNAME"
[ -d "$HSP_PATH" ] && for cfg in $(ls $LS_OPTS "$HSP_PATH"); do cp -R "$HSP_PATH/$cfg" "$HOME"; done

# source the copied bashrc
. "$HOME/.bashrc"

# determine whether to go through YCM install process
YCM_PATH="$HOME/.vim/plugged/YouCompleteMe"
{ [ ! -d "$YCM_PATH" ] || $FULL_INSTALL; } && YCM_INSTALL=true || YCM_INSTALL=false

# YCM pre-install
if $YCM_INSTALL; then
	yes | $PM install $YCM_DEPS
	yes | $PM upgrade $YCM_DEPS
fi

# install vim plugins
vim +PlugInstall +qall 

# YCM full install
if $YCM_INSTALL; then
	cd "$YCM_PATH"
	git submodule update --init --recursive
	python3 install.py --all
fi

# return to starting location
cd "$START_PWD"
