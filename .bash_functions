# .bash_functions

function crypt() (
  local str="${1-}"
  local prefix="${2-${str:0:1}}"
  local passwd

  [[ "${str}" =~ ^[a-zA-Z]+$ ]] || return 1
  [[ "${prefix}" =~ ^[a-zA-Z]$ ]] || return 1

  shellopt on nocasematch

  while true; do
    # Pinned to the system LibreSSL: Homebrew's OpenSSL has dropped -crypt.
    passwd=$(/usr/bin/openssl passwd -crypt "${str}" 2> /dev/null) || return 1
    if [[ ! "${passwd}" =~ [./] ]] && [[ "${passwd}" =~ ^"${prefix}" ]]; then
      echo "${passwd}" | tr '[:upper:]' '[:lower:]'
      return 0
    fi
  done
)

function heic2jpg() {
  ! command -v mogrify > /dev/null && return 1

  find . -maxdepth 1 -type f -iname '*.heic' -exec mogrify -format jpg {} +
}

function ls() {
  if command -v gls > /dev/null 2>&1; then
    command gls -AF --color=auto --group-directories-first "$@"
  elif [[ "${OSTYPE}" == linux* ]]; then
    command ls -AF --color=auto --group-directories-first "$@"
  else
    command ls -AFG "$@"
  fi
}

function noproxy() {
  local proxy

  while IFS='' read -r proxy; do
    unset "${proxy}"
  done < <(env | grep -iE '^[a-z_]*_proxy=' | cut -d= -f1)

  return 0
}

function op_key_pub() {
  local item="${1-}"
  local dir="${HOME}/.ssh"

  [[ -z "${item}" ]] && return 1
  ! command -v jq > /dev/null && return 1
  ! command -v op > /dev/null && return 1

  mkdir -p "${dir}"
  chmod 700 "${dir}"

  ! op item get "${item}" > /dev/null && return 1

  op item get "${item}" \
    --fields public_key \
    --format json |
    jq -r '.value' > "${dir}/key.${item}.pub"
}

function rcmount() {
  local remote="${1-}"
  local dir="${2:-${HOME}/Volumes}"
  local rc=0

  remote="${remote//:/}"

  [[ -z "${remote}" || "${remote}" == */* ]] && return 1
  ! command -v rclone > /dev/null && return 1

  mkdir -p "${dir}/${remote}" || return 1
  rclone nfsmount --vfs-cache-mode full "${remote}:" "${dir}/${remote}" || rc=$?
  rmdir "${dir}/${remote}"

  return "${rc}"
}

function shellopt() {
  local action="${1-}"
  local opt="${2-}"

  [[ -z "${action}" || -z "${opt}" ]] && return 1

  if [[ -n "${ZSH_VERSION-}" ]]; then
    case "${action}" in
      on) setopt "${opt}" ;;
      off) unsetopt "${opt}" ;;
      *) return 1 ;;
    esac
  else
    case "${action}" in
      on) shopt -s "${opt}" ;;
      off) shopt -u "${opt}" ;;
      *) return 1 ;;
    esac
  fi
}
