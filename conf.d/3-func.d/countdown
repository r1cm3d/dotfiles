countdown() {
	local min="$1"
	local sec=$(($min * 60))

	while [ $sec -gt 0 ]; do
		echo -ne "${sec}\r"
		sleep 1
		: $((sec--))
	done
	notify-send 'Time is over'
}
