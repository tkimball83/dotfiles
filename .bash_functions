# .bash_functions

# Add keys to ssh-agent
function auth()
{
  ssh_add=/usr/bin/ssh-add
  [ ! -x ${ssh_add} ] && return 1
  if [ -d ${HOME}/.ssh ]
  then
    for key in ${HOME}/.ssh/id_rsa.*
    do
      [[ ! ${key##*/} =~ \.pub$ ]] && ${ssh_add} ${key}
    done
  fi
  return 0
}
