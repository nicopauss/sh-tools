#!/bin/bash

set -eu

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_VERSION="$(tmux -V | cut -c 6-)"

load_conf() {
    local op="$0"
    local version="$1"

    if [[ $(echo "$TMUX_VERSION $op $version" | bc) -eq 1 ]] ; then
        tmux source-file "${tmux_home}/tmux-${version}.conf"
    fi
}

main() {
    local tmux_conf_dir="$DIR/tmux"

    tmux source-file "$tmux_conf_dir/tmux-global.conf"
    load_conf ">" "2.0"
    load_conf "<" "2.1"
    load_conf "<" "2.2"
}

main
