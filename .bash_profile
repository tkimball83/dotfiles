# .bash_profile

# Source global aliases
[ -f ${HOME}/.bash_aliases ] && source ${HOME}/.bash_aliases

# Source global exports
[ -f ${HOME}/.bash_exports ] && source ${HOME}/.bash_exports

# Source global functions
[ -f ${HOME}/.bash_functions ] && source ${HOME}/.bash_functions

# Source global proxies
[ -f ${HOME}/.bash_proxies ] && source ${HOME}/.bash_proxies

# Source global scripts
[ -f ${HOME}/.bash_scripts ] && source ${HOME}/.bash_scripts

# Source liquidprompt
if [ -f /usr/local/share/liquidprompt ]
then
  [[ $- = *i* ]] && source /usr/local/share/liquidprompt
fi

# Source local settings
[ -f ${HOME}/.bash_local ] && source ${HOME}/.bash_local
