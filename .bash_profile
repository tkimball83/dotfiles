# .bash_profile

# Source bash aliases
[ -f ${HOME}/.bash_aliases ] && . ${HOME}/.bash_aliases

# Source bash exports
[ -f ${HOME}/.bash_exports ] && . ${HOME}/.bash_exports

# Source bash functions
[ -f ${HOME}/.bash_functions ] && . ${HOME}/.bash_functions

# Source bash proxies
[ -f ${HOME}/.bash_proxies ] && . ${HOME}/.bash_proxies

# Source bash scripts
[ -f ${HOME}/.bash_scripts ] && . ${HOME}/.bash_scripts

# Source liquidprompt
if [ -f /usr/local/share/liquidprompt ]
then
  [[ $- = *i* ]] && source /usr/local/share/liquidprompt
fi
