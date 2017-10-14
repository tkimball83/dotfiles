# .bash_functions

function auth()
{
  ssh_add=/usr/bin/ssh-add
  ssh_keygen=/usr/bin/ssh-keygen
  [ ! -x ${ssh_add} ] && return 1
  [ ! -x ${ssh_keygen} ] && return 1
  if [ -d "${HOME}/.ssh" ]
  then
    for key in ${HOME}/.ssh/id_rsa.*
    do
      if [[ ! ${key##*/} =~ \.pub$ ]]
      then
        ${ssh_add} ${key}
        [ ! -e ${key}.pub ] && ${ssh_keygen} -y -f ${key} > ${key}.pub
      fi
    done
  fi
  return 0
}

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
