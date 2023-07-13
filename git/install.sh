#!/usr/bin/env bash

set -uo pipefail
IFS=$'\n\t'


blue "[Git] Configure git to store credentials globally"
git config --global credential.helper store
