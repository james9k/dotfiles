#!/bin/bash
set -u

CURRENT_VERSION=""
export KUBECTL="${HOME}/bin/kubectl"

trap on_error ERR

function on_error() {
    printf "\nERROR: Last command: %s %s\n\n" "$?" "${BASH_COMMAND}"
    exit 1
}

if [ -x "${KUBECTL}" ]; then
    CURRENT_VERSION=$(${KUBECTL} version --client=true --short=true | awk '{print $3}')
    printf "Current client version: %s\n" "${CURRENT_VERSION}"
fi

cd "${HOME}/bin" || exit 1
REMOTE_VERSION="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
if [ "${CURRENT_VERSION}" == "${REMOTE_VERSION}" ]; then
    printf "Up to date ✓\n"
    exit
fi
printf "Downloading kubectl..."
curl -s -LO https://storage.googleapis.com/kubernetes-release/release/"${REMOTE_VERSION}"/bin/linux/amd64/kubectl
printf " ✓\n"
chmod +x "${KUBECTL}" 

printf "New "
${KUBECTL} version --client=true --short=true
