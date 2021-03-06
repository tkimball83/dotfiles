# .bash_functions

function auth()
{
  local ssh_add=/usr/bin/ssh-add
  local ssh_keydir=${1-${HOME}/.ssh}
  local ssh_keygen=/usr/bin/ssh-keygen
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

function cheers()
{
  local brew=/usr/local/bin/brew
  [[ ! -x ${brew} ]] && return 1
  for c in update upgrade cleanup doctor
  do
    ${brew} ${c}
    [[ $? -ne 0 ]] && return 1
  done
}

function dr()
{
  local domain=${1-}
  local basedir=${2-${HOME}/Documents}
  local date=/bin/date
  local defaults=/usr/bin/defaults
  [[ ! -d "${basedir}" ]] && return 1
  [[ ! -x "${date}" ]] && return 1
  [[ ! -x "${defaults}" ]] && return 1
  local today=$(${date} +"%Y%m%d")
  local x=1
  while true
  do
    file="${basedir}/defaults-${today}-${x}"
    if [[ ! -f "${file}" ]]
    then
       "${defaults}" read ${domain} > "${file}"
      break
    else
      x=$(( ${x} + 1 ))
      continue
    fi
  done
}

function crypt()
{
  local str=$1
  local openssl=/usr/bin/openssl
  local shell=${SHELL##*/}
  local tr=/usr/bin/tr
  [[ -z "${str}" ]] && return 1
  [[ ! -x ${openssl} ]] && return 1
  [[ "${shell}" =~ 'zsh$' ]] && so=setopt || so=shopt
  ${so} -s nocasematch
  while true
  do
    local crypt=$(${openssl} passwd -crypt "${str}" 2>/dev/null)
    if [[ ! ${crypt} =~ [./] ]] && [[ ${crypt} =~ ^${str:0:1} ]]
    then
      echo "${crypt}" | ${tr} A-Z a-z
      ${so} -u nocasematch
      return 0
    fi
  done
}

function gp()
{
  local find=/usr/bin/find
  local git=/usr/bin/git
  local basedir=${1-${HOME}/Git}
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
  local git=/usr/bin/git
  local ot=$1
  local nt=$2
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
  local md5=/sbin/md5
  local str=$1
  local salt=${2-$USER}
  [[ -z "${str}" ]] && return 1
  [[ ! -x ${md5} ]] && return 1
  local md5sum=$(echo -n "${str}${salt}" | ${md5})
  echo "${md5sum:0:7}"
  return 0
}

function noproxy()
{
  local env=/usr/bin/env
  [[ ! -x ${env} ]] && return 1
  local proxies=($(${env} | grep -i _proxy | cut -d= -f1))
  for proxy in ${proxies[@]}
  do
    unset ${proxy}
  done
}
