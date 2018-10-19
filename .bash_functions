# .bash_functions

function auth()
{
  ssh_add=/usr/bin/ssh-add
  ssh_keygen=/usr/bin/ssh-keygen
  [[ ! -d "${HOME}/.ssh" ]] && return 1
  [[ ! -x ${ssh_add} ]] && return 1
  [[ ! -x ${ssh_keygen} ]] && return 1
  for key in ${HOME}/.ssh/id_*
  do
    if [[ ! ${key##*/} =~ \.pub$ ]]
    then
      ${ssh_add} ${key}
      [[ ! -e ${key}.pub ]] && ${ssh_keygen} -y -f ${key} > ${key}.pub
    fi
  done
  return 0
}

function crypt()
{
  string=$1
  awk=/usr/bin/awk
  openssl=/usr/bin/openssl
  [[ -z "${string}" ]] && return 1
  [[ ! -x ${awk} ]] && return 1
  [[ ! -x ${openssl} ]] && return 1
  while true
  do
    crypt=$(${openssl} passwd -crypt ${string} 2>/dev/null)
    if [[ ! ${crypt} =~ [./] ]]
    then
      echo ${crypt} | ${awk} '{ print tolower($0) }'
      return 0
    fi
  done
}

function gp()
{
  find=/usr/bin/find
  git=/usr/local/bin/git
  [[ ! -z $1 ]] && basedir="$1" || basedir="${HOME}/Git"
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
  git=/usr/local/bin/git
  oldtag=$2
  newtag=$1
  [[ ! -x ${git} ]] && return 1
  [[ -z ${oldtag} ]] && return 1
  [[ -z ${newtag} ]] && return 1
  ${git} tag ${newtag} ${oldtag}
  ${git} push --tags
  ${git} push origin :refs/tags/${oldtag}
  ${git} tag -d ${oldtag}
  return 0
}

function md5s()
{
  python=/usr/local/bin/python
  string=$1
  [[ ! -x ${python} ]] && return 1
  [[ -z ${string} ]] && return 1
  ${python} -c 'from hashlib import md5; import sys; print(md5(sys.argv[1]).hexdigest()[:7])' ${string}
  return 0
}
