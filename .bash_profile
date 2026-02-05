# .bash_profile

# Source global settings
for f in aliases exports functions proxies scripts; do
  if [ -f "${HOME}/.bash_${f}" ]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bash_${f}"
  fi
done

# Source local settings
if [ -f "${HOME}/.bash_local" ]; then
  # shellcheck source=/dev/null
  source "${HOME}/.bash_local"
fi
