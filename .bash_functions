# .bash_functions

function crypt()
{
  string=$1
  awk=/usr/bin/awk
  openssl=/usr/bin/openssl
  [ -z "${string}" ] && return 1
  [ ! -x ${awk} ] && return 1
  [ ! -x ${openssl} ] && return 1
  while true
  do
    crypt=$(${openssl} passwd -crypt ${string})
    if [[ ! ${crypt} =~ [./] ]]
    then
      echo ${crypt} | ${awk} '{ print tolower($0) }'
      return 0
    fi
  done
}

function auth()
{
  ssh_add=/usr/bin/ssh-add
  [ ! -x ${ssh_add} ] && return 1
  if [ -d "${HOME}/.ssh" ]
  then
    for key in ${HOME}/.ssh/id_rsa.*
    do
      [[ ! ${key##*/} =~ \.pub$ ]] && ${ssh_add} ${key}
    done
  fi
  return 0
}
