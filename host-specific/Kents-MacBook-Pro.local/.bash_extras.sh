vbox() {
	# parse args
	VM_NAME=
	VM_PORT=
	case "$1" in
		OS)
			VM_NAME="Debian (OS 4118)"
			VM_PORT=2222
			;;
		deb)
			VM_NAME="Debian Linux"
			VM_PORT=2200
			;;
		*)
			echo "Unrecognized VM identifier" >&2
			return 1
			;;
	esac
	ACTION="$2"

	# stopping the VM
	if [ "$ACTION" == "stop" ]; then
		VBoxManage controlvm "$VM_NAME" poweroff && \
		return 0 || return 1
	fi

	# rebooting the VM
	if [ "$ACTION" == "reboot" ]; then
		vbox "$1" stop && \
		vbox "$1"      && \
		return 0 || return 1
	fi

	# start the VM (if not already running)
	RETRY=false
	if ! VBoxManage list runningvms | grep "$VM_NAME" > /dev/null; then
		echo -n "Starting VM..."
		VBoxHeadless -s "$VM_NAME" > /dev/null 2>&1 &
		sleep 1
		RETRY=true
	fi

	# ssh in (retries if currently booting up)
	while ! ssh -p "$VM_PORT" kent@localhost && $RETRY; do :; done

	return 0
}
