#!/usr/bin/env sh

KEY_NAME=$1

if ! ( which bw > /dev/null ); then
  echo "Bitwarden CLI is required."
  exit 2
fi

# Require something to be passed to this command
if [ -z "${KEY_NAME}" ]; then
  echo "You need to specify a key name."
  exit 2
fi

KEY_NAME=${KEY_NAME}_Niflheimr

# Try to find the passed key path / name
if ! [ -e "${KEY_NAME}" ]; then
  if [ -e "${HOME}/.ssh/${KEY_NAME}" ]; then
    KEY_NAME="${HOME}/.ssh/${KEY_NAME}"
  else
    echo "Could not find key file ${KEY_NAME}"
    exit 1
  fi
fi

# If this key is already in the agent we don't need to do anything
if ( ssh-add -l | grep -q "${KEY_NAME}" ); then
  echo "Key already present."
  exit 0
fi

# Retrieve key from Bitwarden
bw logout --quiet
export BW_SESSION=$(bw login llamallamda@gmail.com --raw)
PASSWD=$(bw get password "passphrase: $(basename ${KEY_NAME})")

# In case bw exitted non-zero we have no password
if ! [ $? -eq 0 ]; then
  echo "Unable to get password. Not trying to unlock."
  exit 1
fi

# Fill password to ssh-add utility
expect <<EOF >/dev/null
spawn ssh-add ${KEY_NAME}
expect "Enter passphrase"
send "$PASSWD\n"
expect eof
EOF

echo "Complete."
