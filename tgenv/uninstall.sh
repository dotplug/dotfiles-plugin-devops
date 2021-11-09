#!/usr/bin/env bash

set -uo pipefail
IFS=$'\n\t'

blue "Uninstalling tgenv..."
rm -rf ~/.tgenv
green "Successfull uninstall of tgenv"

