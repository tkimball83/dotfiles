#
# .bash_profile
#

# Use colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Set default editor
export EDITOR=vi

# Prepend brew manpath
BREW_MANPATH=/usr/local/share/man
[ -d ${BREW_MANPATH} ] && export MANPATH="${BREW_MANPATH}:${MANPATH}"

# Prepend coreutils path
COREUTILS_PATH=/usr/local/opt/coreutils/libexec/gnubin
[ -d ${COREUTILS_PATH} ] && export PATH="${COREUTILS_PATH}:${PATH}"

# Source aliases files
[ -f ${HOME}/.bash_aliases ] && . ${HOME}/.bash_aliases

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
