#!/bin/bash
set -u

VERSION=""
TARBALL_FN=""

trap on_error ERR

function on_error() {
    printf "\nERROR: Last command: %s %s\n\n" "$?" "${BASH_COMMAND}"
    exit 1
}

# Example of download link:
#   https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
BASE_URL="https://storage.googleapis.com/kubernetes-helm/"

function usage() {
    printf "\nUsage: get_helm.bash [VERSION]\n\n"
    printf "If no version specified, get the latest\n\n"
    printf "EXAMPLES:\n"
    printf "To get a specefic version:\n"
    printf "  get_helm.sh 2.11.0\n"
}

function find_latest() {
    HTML=$(curl -s https://github.com/helm/helm/releases/latest)
    TAG_URL=$(echo "${HTML}" | sed 's/^.*href="\(.*\)".*$/\1/')
    echo "TAG_URL: ${TAG_URL}"
    VERSION_STRING=$(basename "${TAG_URL}")
    VERSION=$(echo "${VERSION_STRING}"| cut -d"v" -f2)
    TARBALL_FN="helm-${VERSION_STRING}-linux-amd64.tar.gz"
}

function download_and_install() {
    pushd /tmp || exit
    wget "${BASE_URL}${TARBALL_FN}"
    tar xvf "${TARBALL_FN}"
    echo "INFO: Installing ${HOME}/bin/helm-${VERSION}"
    cp -v linux-amd64/helm "${HOME}/bin/helm-${VERSION}"
    ln -sf "${HOME}/bin/helm-${VERSION}" "${HOME}/bin/helm"
    if [ -e /tmp/linux-amd64/tiller ]; then
        echo "INFO: Installing ${HOME}/bin/tiller-${VERSION}"
        cp -v linux-amd64/tiller "${HOME}/bin/tiller-${VERSION}"
        ln -sf "${HOME}/bin/tiller-${VERSION}" "${HOME}/bin/tiller"
    fi
    popd || return
}

echo "$#"
if [ $# -lt 1 ]; then
    echo "No version specified, getting the latest..."
    find_latest
elif [ $# -gt 1 ]; then
    usage
    exit 9
else
    VERSION="${1}"
    VERSION_STRING="v${VERSION}"
    TARBALL_FN="helm-${VERSION_STRING}-linux-amd64.tar.gz"
fi

echo "VERSION: ${VERSION}"
echo "TARBALL_FN: ${TARBALL_FN}"

download_and_install
