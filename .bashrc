CONFIGURATION="$HOME/dev/projects/dotfiles"

for d in $(ls ${CONFIGURATION}/conf.d/ | sort -n); do
	dir="${CONFIGURATION}/conf.d/${d}"
	for f in $(ls $dir | sort -n); do
		file="${dir}/${f}"
		[[ ! "$file" =~ .*gpg$ ]] && source "$file"
	done;
done;
