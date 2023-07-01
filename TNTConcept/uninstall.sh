#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

blue "Install TNTGitHook in the system"
python3 -m pip uninstall TNTGitHook

blue "Delete credentials"
python3 -m keyring -b keyring.backends.chainer.ChainerBackend del com.autentia.TNTGitHook credentials
python3 -m keyring -b keyring.backends.macOS.Keyring del com.autentia.TNTGitHook credentials
