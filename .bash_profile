# .bash_profile

# Source global settings
for f in aliases exports functions proxies scripts; do
  if [ -f "${HOME}/.bash_${f}" ]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bash_${f}"
  fi
done

# Source liquidprompt
if [ -f /opt/homebrew/share/liquidprompt ]; then
  if [[ $- = *i* ]]; then
    # shellcheck disable=SC1091
    source /opt/homebrew/share/liquidprompt
  fi
fi

# Source local settings
if [ -f "${HOME}/.bash_local" ]; then
  # shellcheck source=/dev/null
  source "${HOME}/.bash_local"
fi
