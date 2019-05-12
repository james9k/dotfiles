#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:

BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[m'

trap on_error ERR

function on_error() {
    printf "%bERROR%b: Last command(%s): %s" "${RED}" "${NC}" "$?" "${BASH_COMMAND}\n"
    exit 1
}


function info() {
  printf "  [ %b..%b ] %s\n" "${BLUE}" "${NC}" "${1}"
}

function warn() {
  printf "\r  [ %b?%b ] %s\n" "${YELLOW}" "${NC}" "${1}"
}

function user() {
  printf "\r  [ %b?%b ] %s\n" "${YELLOW}" "${NC}" "${1}"
}

function success() {
  printf "\r  [ %bOK%b ] %s\n" "${GREEN}" "${NC}" "${1} ✓"
  #printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail() {
  printf "\r  [ %bFAIL%b ] %s\n" "${RED}" "${NC}" "${1}"
  #printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

function create_directory() {
    ABS_PATH="${1}"

    if [ -e "${ABS_PATH}" ]; then
        user "${ABS_PATH} exists"
    else
        mkdir -p "${ABS_PATH}"
        success "Created ${ABS_PATH}"
    fi
}
