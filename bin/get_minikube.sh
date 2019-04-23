#!/bin/bash
set -x

MINIKUBE="${HOME}/bin/minikube"

${MINIKUBE} version

if [ -e ${MINIKUBE} ]; then
    mv ${MINIKUBE} ${MINIKUBE}.previous
fi

pushd "/tmp"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && install minikube-linux-amd64 ${MINIKUBE}

popd

${MINIKUBE} version
