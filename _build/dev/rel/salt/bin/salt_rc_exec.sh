#!/usr/bin/env bash

set -e

unset CDPATH

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
RELEASE_ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RELEASES_DIR="${RELEASE_ROOT_DIR}/releases"
RELEASE_MUTABLE_DIR="${RELEASE_MUTABLE_DIR:-"${RELEASE_ROOT_DIR}/var"}"
START_ERL_DATA="${RELEASE_MUTABLE_DIR}/start_erl.data"
REL_NAME="${REL_NAME:-salt}"

if [ ! -f "${START_ERL_DATA}" ]; then
    mkdir -p $RELEASE_MUTABLE_DIR
    cp "${RELEASES_DIR}/start_erl.data" "${START_ERL_DATA}"
fi
REL_VSN="${REL_VSN:-$(cut -d' ' -f2 "${START_ERL_DATA}")}"
ERTS_VSN="${ERTS_VSN:-$(cut -d' ' -f1 "${START_ERL_DATA}")}"


export RELEASE_ROOT_DIR
export RELEASES_DIR
export RELEASE_MUTABLE_DIR
export START_ERL_DATA
export REL_NAME
export REL_VSN
export ERTS_VSN
export DEBUG_BOOT

# Set DEBUG_BOOT to output verbose debugging info during execution
if [ ! -z "$DEBUG_BOOT" ]; then
    export PS4='+\D{%s} '
    set -x
fi

# Ensure TERM is set to something usable
# for remote shells. The only time we'll
# override this value is if it is set to "dumb"
export TERM="${TERM:-xterm}"
if [ "$TERM" = "dumb" ]; then
    TERM=xterm
fi

exec "$RELEASES_DIR/$REL_VSN/$REL_NAME.sh" "$@"
