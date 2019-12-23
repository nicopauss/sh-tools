#!/bin/bash

set -eu

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_DIR="$DIR/tmux"
TMUX_VERSION="$(tmux -V | cut -c 6- | sed 's/[^0-9\.]//g')"

load_conf() {
    local op="$1"
    local version="$2"
    local file="$3"

    if [[ $(echo "$TMUX_VERSION $op $version" | bc) -eq 1 ]] ; then
        echo "Source files for $op $version"
        tmux source-file "$TMUX_CONF_DIR/$file"
    fi
}

main() {
    tmux source-file "$TMUX_CONF_DIR/tmux-global.conf"
    load_conf ">=" "2.0" "tmux-2.0.conf"
    load_conf "<" "2.1" "tmux-inf-2.1.conf"
    load_conf "<" "2.2" "tmux-inf-2.2.conf"
    load_conf ">=" "2.2" "tmux-2.2.conf"
    load_conf "<" "2.4" "tmux-inf-2.4.conf"
    load_conf ">=" "2.4" "tmux-2.4.conf"
    source "$TMUX_CONF_DIR/tmux-resurrect/resurrect.tmux"
}

main
