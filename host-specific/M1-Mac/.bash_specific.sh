export PATH="/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:$PATH"
alias oldbrew="arch -x86_64 /usr/local/bin/brew"
alias vmrun="/Applications/VMWare\ Fusion\ Tech\ Preview.app/Contents/Library/vmrun"

vmw() {
	# parse args
	VM_NAME=
	VM_USER=
	case "$1" in
		Deb)
			VM_NAME="Debian 11.x 64-bit Arm"
			VM_USER="kent"
			;;
		*)
			echo "Unrecognized VM identifier" >&2
			return 1
			;;
	esac
	ACTION="$2"
	shift

	VM_PATH="$HOME/Virtual Machines.localized/$VM_NAME.vmwarevm/$VM_NAME.vmx"

	# stopping the VM
	if [ "$ACTION" == "stop" ]; then
		vmrun stop "$VM_PATH"
		return
	fi

	# restarting the VM
	if [ "$ACTION" == "restart" ]; then
		vmrun stop "$VM_PATH" || return
		shift
	fi

	# start the VM (if not already running)	
	STARTED=false
	if ! vmrun list | tail -n +2 | grep "$VM_PATH" > /dev/null; then
		vmrun start "$VM_PATH" nogui || return
		STARTED=true
	fi

	# get guest IP address (will wait if booting up)
	VM_IP="$(vmrun getGuestIpAddress "$VM_PATH" -wait)" || return
	"$STARTED" && sleep 1

	# ssh in
	ssh "$VM_USER@$VM_IP" "$@"
}
