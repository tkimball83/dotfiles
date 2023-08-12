# .bash_functions

function crypt ()
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

function heic2jpg ()
{
  local find=/usr/bin/find
  local mogrify=/opt/homebrew/bin/mogrify
  [[ ! -x ${find} ]] && return 1
  [[ ! -x ${mogrify} ]] && return 1
  for h in $(${find} . -maxdepth 1 -iname '*.heic')
  do
    ${mogrify} -format jpg ${h}
  done
  return 0
}

function md5salt ()
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

function noproxy ()
{
  local env=/usr/bin/env
  [[ ! -x ${env} ]] && return 1
  local proxies=($(${env} | grep -i _proxy | cut -d= -f1))
  for proxy in ${proxies[@]}
  do
    unset ${proxy}
  done
}

function sshpipe ()
{
  local file=${1}
  local host=${2}
  local ssh=/opt/homebrew/bin/ssh
  [[ -z "${file}" ]] && return 1
  [[ -z "${host}" ]] && return 1
  [[ ! -f "${file}" ]] && return 1
  [[ ! -x "${ssh}" ]] && return 1
  cat "${file}" | ${ssh} ${host} "cat > '${file}'"
  return 0
}
