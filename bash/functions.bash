#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:

BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[m'

trap on_error ERR

function on_error() {
    EXIT_STATUS="$?"
    printf "%bERROR%b: Last command(%s): %s" "${RED}" "${NC}" "${EXIT_STATUS}" "${BASH_COMMAND}\n"
    exit "${EXIT_STATUS}"
}


info() {
  printf "  [ %b..%b ] %s\n" "${BLUE}" "${NC}" "${1}"
}

warn() {
  printf "\r  [ %b?%b ] %s\n" "${YELLOW}" "${NC}" "${1}"
}

user() {
  printf "\r  [ %b?%b ] %s\n" "${YELLOW}" "${NC}" "${1}"
}

success() {
  printf "\r  [ %bOK%b ] %s\n" "${GREEN}" "${NC}" "${1} ✓"
}

fail() {
  printf "\r  [ %bFAIL%b ] %s\n" "${RED}" "${NC}" "${1}"
  echo ''
  exit
}

create_directory() {
    ABS_PATH="${1}"

    if [ -e "${ABS_PATH}" ]; then
        user "${ABS_PATH} exists"
    else
        mkdir -p "${ABS_PATH}"
        success "Created ${ABS_PATH}"
    fi
}
