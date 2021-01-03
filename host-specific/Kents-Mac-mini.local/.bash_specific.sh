export PATH="/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:$PATH"
alias oldbrew="arch -x86_64 /usr/local/bin/brew"

prl() {
	ID="$1"
	ACTION="$2"
	shift

	# parse args
	VM_NAME=
	VM_PORT=
	case "$ID" in
		deb)
			VM_NAME="Debian GNU Linux"
			VM_PORT=2200
			;;
		*)
			echo "Unrecognized VM identifier" >&2
			return 1
			;;
	esac

	# stopping the VM
	if [ "$ACTION" == "stop" ]; then
		prl "$ID" sudo /sbin/shutdown -h now
		return
	fi

	# restarting the VM
	if [ "$ACTION" == "restart" ]; then
		prl "$ID" sudo /sbin/shutdown -r now
		while ! prl "$ID" true 2> /dev/null; do :; done # loop while rebooting
		shift
	fi

	# start the VM (if not already running)	
	if ! prlctl status "$VM_NAME" | grep running > /dev/null; then
		prlctl start "$VM_NAME" || return
	fi

	# ssh in
	ssh -p "$VM_PORT" kent@localhost "$@"
}
