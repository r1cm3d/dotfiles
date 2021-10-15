cb() {
	xclip -sel clip
}

2fa() {
	echo -n "$(oathtool -b --totp "$1")"
}

vaultgp() {
	bw get password "$1"
}

vault2fa() {
	local k=$(bw get item "$1" | \
		jq '.fields[] | select(.name == "2fa") | .value' | \
		sed 's/"//g')
	echo -n "$(2fa "$k")"
}

2facb() {
	2fa "$1" | cb
}

vaultgpcb() {
	vaultgp "$1" | cb
}

vault2facb() {
	vault2fa "$1" | cb
}
