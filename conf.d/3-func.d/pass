unlock() {
	eval $(bw unlock | grep --color=never -Po 'export BW_SE[^ ]+')
	env | grep -q BW_SESSION && return 0 || \
		echo 'wrong password' && return 1
}
