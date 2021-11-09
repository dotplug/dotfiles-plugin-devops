#!/usr/bin/env bash

set -uo pipefail
IFS=$'\n\t'

if [[ ! -d ~/.tgenv ]]; then
    # Installation process followed by https://github.com/cunymatthieu/tgenv
    blue "Installing tgenv"
    git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
    green "Successfully installed tgenv"
fi
