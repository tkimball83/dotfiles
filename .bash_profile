# .bash_profile

# Use colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Set default editor
export EDITOR=vi

# Export path to ansible vault password
[ -f ${HOME}/.ansible_vault ] && export ANSIBLE_VAULT_PASSWORD_FILE="${HOME}/.ansible_vault"

# Export manpath including brew man-pages
BREW_MANPATH=/usr/local/share/man
if [ -d ${BREW_MANPATH} ]
then
  [ ! -z ${MANPATH} ] && export MANPATH="${BREW_MANPATH}:${MANPATH}"
  [ -z ${MAHPATH} ] && export MANPATH="${BREW_MANPATH}"
fi

# Export path including brew coreutils
COREUTILS_PATH=/usr/local/opt/coreutils/libexec/gnubin
[ -d ${COREUTILS_PATH} ] && export PATH="${COREUTILS_PATH}:${PATH}"

# Source bash aliases
[ -f ${HOME}/.bash_aliases ] && . ${HOME}/.bash_aliases

# Source bash proxy
[ -f ${HOME}/.bash_proxy ] && . ${HOME}/.bash_proxy

# Source liquidprompt
if [ -f /usr/local/share/liquidprompt ]
then
  [[ $- = *i* ]] && source /usr/local/share/liquidprompt
fi

# Generate ssh config (7.3p1+)
if [ -d ${HOME}/.ssh ]
then
  [ -f ${HOME}/.ssh/config ] && rm -f ${HOME}/.ssh/config
  for config in ${HOME}/.ssh/config.*
  do
    echo "Include ${config##*/}" >> ${HOME}/.ssh/config
  done
fi

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
