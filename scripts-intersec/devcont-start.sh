#!/bin/bash -eu

exec /bin/bash --rcfile "$(dirname "$(readlink -f "$0")")/devcont-bashrc" -i
