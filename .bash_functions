# .bash_functions

function crypt ()
{
  local str="${1-}"
  local prefix="${2-${str:0:1}}"
  local shell="${SHELL##*/}"

  [[ -z "${str}" ]] && return 1
  [[ "${shell}" =~ 'zsh$' ]] && so=setopt || so=shopt

  "${so}" -s nocasematch

  while true
  do
    # shellcheck disable=SC2059
    passwd=$(/usr/bin/openssl passwd -crypt "${str}" 2>/dev/null)
    if [[ ! "${passwd}" =~ [./] ]] && [[ "${passwd}" =~ ^"${prefix}" ]]
    then
      echo "${passwd}" | /usr/bin/tr '[:upper:]' '[:lower:]'
      "${so}" -u nocasematch
      return 0
    fi
  done
}

function heic2jpg ()
{
  local mogrify=/opt/homebrew/bin/mogrify

  [[ ! -x "${mogrify}" ]] && return 1

  local images=()
  while IFS='' read -r line
  do
    images+=("${line}")
  done < <(/usr/bin/find . -maxdepth 1 -iname '*.heic')

  for heic in "${images[@]}"
  do
    "${mogrify}" -format jpg "${heic}"
  done

  return 0
}

function noproxy ()
{
  local proxies=()

  while IFS='' read -r line
  do
    proxies+=("${line}")
  done < <(/usr/bin/env | grep -i _proxy | cut -d= -f1)

  for proxy in "${proxies[@]}"
  do
    unset "${proxy}"
  done

  return 0
}

function op_key_pub ()
{
  local item="${1-}"
  local dir="${HOME}/.ssh"
  local jq=/opt/homebrew/bin/jq
  local op=/opt/homebrew/bin/op

  [[ -z "${item}" ]] && return 1
  [[ ! -x "${jq}" ]] && return 1
  [[ ! -x "${op}" ]] && return 1

  /bin/mkdir -p "${dir}"
  /bin/chmod 700 "${dir}"

  ! "${op}" item get "${item}" >/dev/null && return 1

  "${op}" item get "${item}" \
    --fields public_key \
    --format json \
  | "${jq}" -r '.value' > "${dir}/key.${item%%-*}.pub"

  return 0
}
