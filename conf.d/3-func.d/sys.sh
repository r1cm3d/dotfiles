clone-user() {
  local SRC=$1
  local DEST=$2
  
  local SRC_GROUPS=$(id -Gn ${SRC} | sed "s/ /,/g" | sed -r 's/\<'${SRC}'\>\b,?//g')
  local SRC_SHELL=$(awk -F : -v name=${SRC} '(name == $1) { print $7 }' /etc/passwd)
  
  sudo useradd --groups ${SRC_GROUPS} --shell ${SRC_SHELL} --create-home ${DEST}
  sudo passwd ${DEST}
}
