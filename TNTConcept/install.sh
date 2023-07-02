#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

DOTFILES_TNT_USERNAME=${DOTFILES_TNT_USERNAME:-}
DOTFILES_TNT_PASSWORD=${DOTFILES_TNT_PASSWORD:-}

# Needs to load the helpers before using it
source "${DOTFILES_ROOT}/lib/helpers"

setup_netrc () {
    set_debug_file_label "$BASH_SOURCE"

    local netrc_filepath=$HOME/.netrc
    local netrc_path_template=$DOTFILES_ROOT/plugins/dotfiles-plugin-devops/TNTConcept/netrc.template

    blue "[TNT Concept] Check if $netrc_filepath exist"

    if ! [ -f $netrc_filepath ]
    then
        blue '[TNT Concept] setup netrc'

        blue '[TNT Concept] What is your TNT username?'
        if [[ -z $DOTFILES_TNT_USERNAME ]]; then
          read -e tnt_username
        else
          tnt_username=$DOTFILES_TNT_USERNAME
        fi
        blue '[TNT Concept] What is your TNT password?'
        if [[ -z $DOTFILES_TNT_PASSWORD ]]; then
          read -e tnt_password
        else
          tnt_password=$DOTFILES_TNT_PASSWORD
        fi

        debug_msg "[TNT Concept] Replace values from the template to the original netrc"
        sed -e "s/USERNAME/$tnt_username/g" -e "s/PASSWORD/$tnt_password/g" $netrc_path_template > $netrc_filepath

        success_msg '[TNT Concept] netrc applied'
    else
        info_msg '[TNT Concept] netrc already exists'
    fi
}


setup_pipconf () {
    local pipconf_path_template=$DOTFILES_ROOT/plugins/dotfiles-plugin-devops/TNTConcept/pip.conf.template
    mkdir -p $HOME/.config/pip
    cp $pipconf_path_template $HOME/.config/pip/pip.conf
}

setup_netrc
setup_pipconf

blue "[TNT Concept] Check that at least python 3.7 is installed"
python3 --version

blue "[TNT Concept] Check that pip3 is installed:"
pip3 --version

blue "[TNT Concept] Show PIP configuration is properly set"
python3 -m pip config list

blue "[TNT Concept] Ensure that TNTGitHook is installed..."
if [[ $(pip3 list |grep 'TNTGitHooks') -eq 0 ]]; then
  blue "[TNT Concept] Installed, no action required"
else
  blue "[TNT Concept] Install TNTGitHook in the system"
  python3 -m pip install --upgrade TNTGitHook --user

  blue "[TNT Concept] Setup credentials"
  python3 -m TNTGitHook --set-credentials
fi

