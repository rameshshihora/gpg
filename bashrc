gpg-agent --daemon --enable-ssh-support \
          --write-env-file "${HOME}/.gpg-agent-info"
GPG_TTY=$(tty)
export GPG_TTY

# Below will fail then just run from root - I had problem with this
chmod o+rw $(tty)

# Paste these lines:
if test -f ${HOME}/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ${HOME}/.gpg-agent-info
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  GPG_TTY=$(tty)
  export GPG_TTY
else
  eval $(gpg-agent --daemon --write-env-file ${HOME}/.gpg-agent-info)
fi
