#!/bin/bash

set -eu

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_DIR="$DIR/tmux"
TMUX_VERSION="$(tmux -V | cut -c 6-)"

load_conf() {
    local op="$1"
    local version="$2"

    if [[ $(echo "$TMUX_VERSION $op $version" | bc) -eq 1 ]] ; then
        echo "Source files for $op $version"
        tmux source-file "$TMUX_CONF_DIR/tmux-${version}.conf"
    fi
}

main() {
    tmux source-file "$TMUX_CONF_DIR/tmux-global.conf"
    load_conf ">" "2.0"
    load_conf "<" "2.1"
    load_conf "<" "2.2"
}

main
