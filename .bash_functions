# .bash_functions

function auth()
{
  ssh_add=/usr/bin/ssh-add
  ssh_keydir=${1-${HOME}/.ssh}
  ssh_keygen=/usr/bin/ssh-keygen
  [[ ! -d "${ssh_keydir}" ]] && return 1
  [[ ! -x ${ssh_add} ]] && return 1
  [[ ! -x ${ssh_keygen} ]] && return 1
  for key in "${ssh_keydir}"/id_*
  do
    if [[ ! ${key##*/} =~ \.pub$ ]]
    then
      ${ssh_add} "${key}"
      [[ ! -e ${key}.pub ]] && ${ssh_keygen} -y -f "${key}" > "${key}.pub"
    fi
  done
  return 0
}

function crypt()
{
  str=$1
  openssl=/usr/bin/openssl
  tr=/usr/bin/tr
  [[ -z "${str}" ]] && return 1
  [[ ! -x ${openssl} ]] && return 1
  [[ ! -x ${tr} ]] && return 1
  while true
  do
    crypt=$(${openssl} passwd -crypt "${str}" 2>/dev/null)
    if [[ ! ${crypt} =~ [./] ]]
    then
      echo "${crypt}" | ${tr} A-Z a-z
      return 0
    fi
  done
}

function gp()
{
  find=/usr/bin/find
  git=/usr/bin/git
  basedir=${1-${HOME}/Git}
  [[ ! -d "${basedir}" ]] && return 1
  [[ ! -x ${find} ]] && return 1
  [[ ! -x ${git} ]] && return 1
  for repo in $(${find} "${basedir}" -type d -maxdepth 1 | sort)
  do
    if [[ -d "${repo}/.git" ]]
    then
      echo -e "\n[\033[1m$(basename "${repo}")\033[0m]\n"
      ${git} -C "${repo}" checkout master
      ${git} -C "${repo}" pull
    fi
  done
  echo
  return 0
}

function gtr()
{
  git=/usr/bin/git
  ot=$1
  nt=$2
  [[ -z "${ot}" ]] && return 1
  [[ -z "${nt}" ]] && return 1
  [[ ! -x ${git} ]] && return 1
  ${git} tag "${nt}" "${ot}"
  ${git} tag -d "${ot}"
  ${git} push origin ":refs/tags/${ot}"
  ${git} push --tags
  return 0
}

function mds()
{
  md5=/sbin/md5
  str=$1
  salt=${2-$USER}
  [[ -z "${str}" ]] && return 1
  [[ ! -x ${md5} ]] && return 1
  md5sum=$(echo -n "${str}${salt}" | ${md5})
  echo "${md5sum:0:7}"
  return 0
}
